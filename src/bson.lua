--
-- Created by: Cyril.
-- Created at: 15/6/20 下午2:37
-- Email: houshoushuai@gmail.com
--


local assert, error = assert, error
local pairs = pairs
local getmetatable = getmetatable
local type = type
local tonumber, tostring = tonumber, tostring
local t_insert = table.insert
local t_concat = table.concat
local strformat = string.format
local strmatch = string.match
local strbyte = string.byte

local function toLSB(bytes, value)
    local str = ""
    for j = 1, bytes do
        str = str .. string.char(value % 256)
        value = math.floor(value / 256)
    end
    return str
end

local ffi = require("ffi")
if pcall(ffi.typeof, "struct timeval") then
else
    ffi.cdef[[
        typedef long time_t;

        typedef struct timeval {
            time_t tv_sec;
            time_t tv_usec;
        } timeval;

        int gettimeofday(struct timeval* t, void* tzp);
    ]]
end

local gettimeofday_struct = ffi.new("timeval")
local function getTime()
    ffi.C.gettimeofday(gettimeofday_struct, nil)
    return tonumber(gettimeofday_struct.tv_sec) * 1000 + tonumber(gettimeofday_struct.tv_usec / 1000)
end

local function toLSB32(value) return toLSB(4,value) end
local function toLSB64(value) return toLSB(8,value) end
local function to_int32(n,v) return "\016"..n.."\000"..toLSB32(v) end
local function to_int64(n,v) return "\018"..n.."\000"..toLSB64(v) end
local function to_date(n,v) return "\09"..n.."\000"..toLSB64(v) end

local bit64_meta = {
    __tonumber = function(obj)
        return obj.value
    end,
    __tostring = function(obj)
        return tostring(obj.value)
    end,
    __eq = function(a, b)
        return getmetatable(a) == getmetatable(b) and a.value == b.value
    end,
    metatype = "bit64"
}

local bit32_meta = {
    __tonumber = function(obj)
        return obj.value
    end,
    __tostring = function(obj)
        return tostring(obj.value)
    end,
    __eq = function(a, b)
        return getmetatable(a) == getmetatable(b) and a.value == b.value
    end,
    metatype = "bit32"
}

local date_meta = {
    __tonumber = function(obj)
        return obj.value
    end,
    __tostring = function(obj)
        return tostring(obj.value)
    end,
    eq = function(a, b)
        return getmetatable(a) == getmetatable(b) and a.value == b.value
    end,
    metatype = "date"
}

function Bit64(value)
    return setmetatable({ value = value }, bit64_meta)
end

function Bit32(value)
    return setmetatable({ value = value }, bit32_meta)
end

function Date(value)
    value = value or getTime()
    value = tonumber(value)
    if #tostring(value) < 13 then
        value = value * 1000
    end
    return setmetatable({ value = value }, date_meta)
end

p(Date())

local ll = require("./utils")
local le_uint_to_num = ll.le_uint_to_num
local le_int_to_num = ll.le_int_to_num
local num_to_le_uint = ll.num_to_le_uint
local from_double = ll.from_double
local to_double = ll.to_double

local getlib = require("./get")
local read_terminated_string = getlib.read_terminated_string

local obid = require("./objectId")
local ObjectId = obid
local new_object_id = obid.new
local object_id_mt = obid.metatable


local function read_document(get, numerical)
    local bytes = le_uint_to_num(get(4))

    local ho, hk, hv = false, false, false
    local t = {}
    while true do
        local op = get(1)
        if op == "\0" then break end
        local e_name = read_terminated_string ( get )
        local v
        if op == "\1" then -- Double
            v = from_double ( get ( 8 ) )
        elseif op == "\2" then -- String
            local len = le_uint_to_num ( get ( 4 ) )
            v = get ( len - 1 )
            assert ( get ( 1 ) == "\0" )
        elseif op == "\3" then -- Embedded document
            v = read_document ( get , false )
        elseif op == "\4" then -- Array
            v = read_document ( get , true )
        elseif op == "\5" then -- Binary
            local len = le_uint_to_num ( get ( 4 ) )
            local subtype = get ( 1 )
            v = get ( len )
        elseif op == "\7" then -- ObjectId
            v = new_object_id(get(12))
            if _G.usePureObjectId == true then
                v = tostring(v)
            end
        elseif op == "\8" then -- false
            local f = get ( 1 )
            if f == "\0" then
                v = false
            elseif f == "\1" then
                v = true
            else
                error ( f:byte ( ) )
            end
        elseif op == "\9" then -- unix time
            v = get(8)
            if v == nil then
                v = nil
            else
                v = Date(le_uint_to_num ( v , 1 , 8 ))
            end
        elseif op == "\10" then -- Null
            v = nil
        elseif op == "\16" then --int32
            v = le_int_to_num ( get ( 4 ) , 1 , 4 )
        elseif op == "\18" then --int64
            v = le_int_to_num ( get ( 8 ) , 1 , 8 )
        else
            error("Unknown BSON type " .. strbyte(op))
        end
        if numerical then
            -- tg add
            -- t [ tonumber ( e_name ) ] = v
            -- for lua array, start from 1, always +1
            t[tonumber(e_name) + 1] = v
        else
            t[e_name] = v
        end

        -- Check for special universal map
        if e_name == "_keys" then
            hk = v
        elseif e_name == "_vals" then
            hv = v
        else
            ho = true
        end
    end

    if not ho and hk and hv then
        t = {}
        for i = 1, #hk do
            t[hk[i]] = hv[i]
        end
    end

    return t
end

local function from_bson(get)
    local t = read_document(get, false)
    return t
end

local to_bson
local function pack(k, v)
    local ot = type(v)
    local mt = getmetatable(v)

    if ot == "number" then
        if v ~= 0 and v * 2 == v then
            if v == math.huge then
                return "\001" .. k .. "\000\000\000\000\000\000\000\240\127"
            elseif v == -math.huge then
                return "\001" .. k .. "\000\000\000\000\000\000\000\240\255"
            else
                return "\001" .. k .. "\000\001\000\000\000\000\000\240\127"
            end
        end
        if math.floor(v) ~= v then
            return "\1" .. k .. "\0" .. to_double(v)
        elseif v > 2147483647 or v < -2147483648 then
            return to_int64(k, v)
        else
            return to_int32(k, v)
        end

    elseif ot == "nil" then
        return "\10" .. k .. "\0"
    elseif ot == "string" then
        return "\2" .. k .. "\0" .. num_to_le_uint(#v + 1) .. v .. "\0"
    elseif ot == "boolean" then
        if v == false then
            return "\8" .. k .. "\0\0"
        else
            return "\8" .. k .. "\0\1"
        end
    elseif mt == object_id_mt then
        return "\7" .. k .. "\0" .. v.id
    elseif mt == bit32_meta then
        return to_int32(k, v.value)
    elseif mt == bit64_meta then
        return to_int64(k, v.value)
    elseif mt == date_meta then
        return to_date(k, v.value)
    elseif ot == "table" then
        local doc, array = to_bson(v)
        if array then
            return "\4" .. k .. "\0" .. doc
        else
            return "\3" .. k .. "\0" .. doc
        end
    else
        error("Failure converting " .. ot .. ": " .. tostring(v))
    end
end

function to_bson(ob)
    -- Find out if ob if an array; string->value map; or general table
    local onlyarray = true
    local seen_n, high_n = {}, 0
    local onlystring = true
    local isEmpty = false
    local i = 0
    for k, v in pairs(ob) do
        local t_k = type(k)
        onlystring = onlystring and (t_k == "string")
        if onlyarray then
            if t_k == "number" and k >= 0 then
                if k > high_n then
                    high_n = k
                    seen_n[k - 1] = v
                end
            else
                onlyarray = false
            end
        end
        if not onlyarray and not onlystring then break end
        i = i + 1
    end
    -- for empty table, we consider it as array, rather than object
    if i == 0 then
        onlystring = false
        isEmpty = true
    end

    local retarray, m = false, nil
    if onlystring then -- Do string first so the case of an empty table is done properly
    local r = {}
    for k, v in pairs(ob) do
        t_insert(r, pack(k, v))
    end
    m = t_concat(r)
    elseif onlyarray then
        local r = {}

        local low = 0
        -- if seen_n [ 0 ] then low = 0 end

        local ordermap = true
        for i, v in ipairs(ob) do
            local vtype = type(v)
            if vtype ~= 'table' or #v ~= 3 or v[1] ~= '_order_' then ordermap = false; break end
        end
        if ordermap then
            for i, v in ipairs(ob) do
                if v[2] and v[3] then
                    t_insert(r, pack(v[2], v[3]))
                end
            end
            if isEmpty then
                retarray = true
            end
            m = t_concat(r)
        else
            -- for mongo internal, array start from 0 index
            for i = 0, high_n - 1 do
                r[i] = pack(i, seen_n[i])
            end

            -- print('low, high_n', low, high_n)
            m = t_concat(r, "", low, high_n - 1)
            retarray = true
        end
    else
        local ni = 1
        local keys, vals = {}, {}
        for k, v in pairs(ob) do
            keys[ni] = k
            vals[ni] = v
            ni = ni + 1
        end
        return to_bson({ _keys = keys, _vals = vals })
    end

    return num_to_le_uint(#m + 4 + 1) .. m .. "\0", retarray
end

return {
    from_bson = from_bson;
    to_bson = to_bson;
    Bit32 = Bit32;
    Bit64 = Bit64;
    Date = Date;
}
