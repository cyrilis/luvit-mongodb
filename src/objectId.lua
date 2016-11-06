--
-- Created by: Cyril.
-- Created at: 15/6/20 下午2:39
-- Email: houshoushuai@gmail.com
--


local setmetatable = setmetatable
local strbyte, strchar = string.byte, string.char
local strformat = string.format
local strsub = string.sub
local t_insert = table.insert
local t_concat = table.concat
local openssl = require("openssl")
local ll = require ( "./utils" )
local num_to_le_uint = ll.num_to_le_uint
local num_to_be_uint = ll.num_to_be_uint

local object_id_mt = {
    __tostring = function ( ob )
        local t = { }
        for i = 1 , 12 do
            t_insert ( t , strformat ( "%02x" , strbyte ( ob.id , i , i ) ) )
        end
        --return "ObjectId('" .. t_concat ( t ) .. "')"
        return t_concat ( t )
    end ;
    __eq = function ( a , b ) return a.id == b.id end ;
}

local machineid = assert ( io.popen ( "uname -n" ) ):read ( "*l" )
machineid = openssl.digest.digest("md5", machineid):sub ( 1 , 3 )

local pid = process.pid
pid = num_to_le_uint ( pid , 2 )

local inc = math.floor(math.random() * 1000)
local function generate_id ()
    inc = inc + 1
    -- "A BSON ObjectID is a 12-byte value consisting of a 4-byte timestamp (seconds since epoch), a 3-byte machine id, a 2-byte process id, and a 3-byte counter. Note that the timestamp and counter fields must be stored big endian unlike the rest of BSON"
    return num_to_be_uint ( os.time ( ) , 4 ) .. machineid .. pid .. num_to_be_uint ( inc , 3 )

end

local function new_object_id ( str )
    if str then
        assert ( #str == 12 )
    else
        str = generate_id ( )
    end
    return setmetatable ( { id = str } , object_id_mt )
end

local function makeObjectId (str)
    if str then
        str = tostring(str)
        if not(type(str) == 'string' and #str == 24) then
            str = object_id_mt.__tostring({id = str})
        end
        assert(type(str) == 'string' and #str == 24, 'wrong ObjectId string')
        local t
        local time = tonumber(strsub(str, 1, 8), 16)
        local part1 = num_to_be_uint ( time , 4 )
        local r_t = {}
        for i=4, 8 do
            t = tonumber(strsub(str, 2*i+1, 2*i+2), 16)
            t_insert(r_t, strchar(t))
        end
        local part2 = t_concat(r_t)
        local part3 = num_to_be_uint(tonumber(strsub(str, 19, 24), 16), 3)

        local binstr = part1 .. part2 .. part3
        return setmetatable({id=binstr}, object_id_mt)
    else
        -- create new object id
        return new_object_id();
    end
end

return {
    ObjectId = makeObjectId,
    new = makeObjectId;
    metatable = object_id_mt ;
}
