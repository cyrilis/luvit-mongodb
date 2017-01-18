--
-- Created by: Cyril.
-- Created at: 15/6/20 上午12:18
-- Email: houshoushuai@gmail.com
--

Emitter = require('core').Emitter
local net = require("net")
local ll = require ( "./utils" )
local num_to_le_uint = ll.num_to_le_uint
local num_to_le_int = ll.num_to_le_int
local le_uint_to_num = ll.le_uint_to_num
local le_bpeek = ll.le_bpeek
local bson = require("./bson")
local to_bson = bson.to_bson
local from_bson = bson.from_bson

local getlib = require ( "./get" )
local get_from_string = getlib.get_from_string
local ObjectId = require "./objectId"

local Collection = require("./collection")

Mongo = Emitter:extend()

_id = 0
function Mongo:initialize(options)
    options = options or {}
    self.options = options
    _id = _id + 1
    p("[Info] - Create connection.......")
    self.port = options.port or 27017
    self.host = options.host or '127.0.0.1'
    assert(options.db or options.dbname, "Should specify a database name.")
    self.db = options.db or options.dbname
    self.requestId = 0
    self.queues = {}
    self.callbacks = {}
    self:connect()
end

local opcodes = {
    REPLY = 1 ;
    MSG = 1000 ;
    UPDATE = 2001 ;
    INSERT = 2002 ;
    QUERY = 2004 ;
    GET_MORE = 2005 ;
    DELETE = 2006 ;
    KILL_CURSORS = 2007 ;
}


local function composeMessage (reqId, resId, opcode, message)
    local reqId = num_to_le_uint(reqId)
    resId = resId or "\255\255\255\255"
    opcode = num_to_le_uint( assert( opcodes[opcode] ) )
    return num_to_le_uint (#message + 16 ) .. reqId .. resId .. opcode .. message
end

local function getCollectionName (self, collection)
    local db = self.db
    return  db .. "." .. collection .. "\0"
end


local function parseMsgHeader(data)
    local header = assert(get_from_string(data)(16))
    local length = le_uint_to_num(header, 1, 4)
    local reqId = le_uint_to_num(header, 5,8)
    local resId = le_uint_to_num(header, 9, 12)
    local opcode = le_uint_to_num(header, 13, 16)
    return length, reqId, resId, opcode
end

local function parseData ( data )
    local offset_i =  0
    local length , reqId , resId , opcode = parseMsgHeader( data )
    assert ( opcode == opcodes.REPLY )
    local data = assert ( data )
    local get = get_from_string ( data )
    local abadon = get(16)
    local responseFlags = get ( 4 )
    local cursorId = le_uint_to_num(get ( 8 ))
    local tags = { }
    tags.startingFrom = le_uint_to_num ( get ( 4 ) )
    tags.numberReturned = le_uint_to_num ( get ( 4 ) )
    tags.CursorNotFound = le_bpeek ( responseFlags , 0 )
    tags.QueryFailure = le_bpeek ( responseFlags , 1 )
    tags.ShardConfigStale = le_bpeek ( responseFlags , 2 )
    tags.AwaitCapable = le_bpeek ( responseFlags , 3 )
    local res = {}
    for i = 1 , tags.numberReturned do
        res[ i + offset_i ] = from_bson ( get )
    end
    return resId, cursorId , res, tags, length, reqId
end

function Mongo:command (opcode, message, callback, collection, query)
    self.requestId = self.requestId + 1
    local message = composeMessage(self.requestId, nil, opcode, message)
    local requestId = self.requestId
    self.queues[requestId] = {
        ["message"] = message,
        ["requestId"] = self.requestId,
        ["opcode"] = opcode,
        ["query"] = query,
        ["collection"] = collection,
        ["callback"] = (callback or function() p("-------") end)
    }
    local currentQueue = self.queues[requestId]
    self.socket:write(currentQueue["message"], "hex")
    local opcode = currentQueue["opcode"]
    -- Insert Update, and Delete method has no response
    if opcode == "UPDATE" or opcode == "INSERT" or opcode == "DELETE" then
        local query = currentQueue.query
        local collection = currentQueue.collection
        self:getLastError(function(error)
            if error then
                currentQueue.callback(error)
                self.queues[requestId] = nil
            else
                self:find(collection, query, nil, nil, nil, function(err, result)
                    currentQueue.callback(nil, result)
                    self.queues[requestId] = nil
                end)
            end
        end)
    end
end

function Mongo:getLastError(cb)
    self:query("$cmd", {getLastError = true}, nil, nil, 1, function(err, res)
        if res[1].err or res[1]["errmsg"] then
            cb(res[1])
        else
            cb()
        end
    end, nil)
end

function Mongo:query ( collection , query , fields , skip , limit , callback, options )
    skip = skip or 0
    local flags = 0
    if options then
        flags = 2^1*( options.TailableCursor and 1 or 0 )
                + 2^2*( options.SlaveOk and 1 or 0 )
                + 2^3*( options.OplogReplay and 1 or 0 )
                + 2^4*( options.NoCursorTimeout and 1 or 0 )
                + 2^5*( options.AwaitData and 1 or 0 )
                + 2^6*( options.Exhaust and 1 or 0 )
                + 2^7*( options.Partial and 1 or 0 )
    end
    query = to_bson(query)
    if fields then
        fields = to_bson(fields)
    else
        fields = ""
    end
    local m = num_to_le_uint ( flags ) .. getCollectionName ( self , collection )
            .. num_to_le_uint ( skip ) .. num_to_le_int ( limit or 0 )
            .. query .. fields
    self:command("QUERY", m, callback)
end

function Mongo:update (collection, query, update, upsert, single, callback)
    local flags = 2^0*( upsert and 1 or 0 ) + 2^1*( single and 0 or 1 )
    local queryBson = to_bson(query)
    update = to_bson(update)
    local m = "\0\0\0\0" .. getCollectionName ( self , collection ) .. num_to_le_uint ( flags ) .. queryBson .. update
    self:command("UPDATE", m, callback, collection, query)
end

function Mongo:insert (collection, docs, continue, callback)
    if not(#docs >= 1) and docs then
        docs = {docs}
    end
    assert(#docs >= 1)
    local flags = 2^0*( continue and 1 or 0 )
    local t = {}
    local ids = {}
    for i , v in ipairs ( docs ) do
        if not v._id then
            v._id = ObjectId.new()
        end
        table.insert(ids, v._id)
        t [ i ] = to_bson ( v )
    end
    local m = num_to_le_uint ( flags ) .. getCollectionName ( self , collection ) .. table.concat( t )

    local query = {_id = {["$in"] = ids}}

    self:command("INSERT", m, callback, collection, query)
end

function Mongo:remove(collection, query, singleRemove, callback)
    local flags = 2^0*( singleRemove and 1 or 0 )
    local queryBson = to_bson(query)
    local m = "\0\0\0\0" .. getCollectionName ( self , collection ) .. num_to_le_uint ( flags ) .. queryBson
    self:command("DELETE", m, callback, collection, query)
end

function Mongo:findOne(collection, query, fields, skip,  cb)
    local function callback(err, res)
        if res and  #res >= 1 then
            cb(err, res[1])
        else
            cb(err, nil)
        end
    end
    self:query(collection, query, fields, skip, 1, callback)
end

function Mongo:find(collection, query, fields, skip, limit, callback)
    self:query(collection, query, fields, skip, limit, callback)
end

function Mongo:count(collection, query, callback)
    local function cb(err, r)
        callback(err, #r)
    end
    self:query(collection, query, nil, nil, nil, cb)
end

function Mongo:_onData(data)
    local stringToParse = ""
    if #self.tempData > 0 then
        stringToParse = self.tempData .. data
    else
        stringToParse = data
    end

    local status, docLength = pcall(function() return parseMsgHeader(stringToParse) end)
    if not status then
        return
    end

    if docLength == #stringToParse then
        local reqId, cursorId, res, tags = parseData(stringToParse)
        self.tempData = ""
        self.queues[reqId].callback(nil, res, tags, cursorId)
        self.queues[reqId] = nil
    elseif docLength > #stringToParse then
        self.tempData = stringToParse
    elseif docLength < #stringToParse then
        local stringToParseSub = stringToParse:sub(1, docLength)
        local reqId, cursorId, res, tags = parseData(stringToParseSub)
        self.queues[reqId].callback(nil, res, tags, cursorId)
        self.queues[reqId] = nil
        self.tempData = stringToParse:sub(docLength + 1)
        self:_onData("")
    end
end

function Mongo:connect()
    local socket
    socket = net.createConnection(self.port, self.host)
    socket:on("connect", function()
        p("[Info] - Database is connected.......")
        self.tempData = ""
        socket:on("data", function(data)
            self:_onData(data)
        end)

        socket:on('end', function()
            socket:destroy()
            self:emit("end")
            self:emit("close")
            p('client end')
        end)

        socket:on("error", function(err)
            p("Error!", err)
            self:emit("error", err)
        end)

        self:emit("connect")
    end)
    socket:on("error", function (code)
        if(code == "ECONNREFUSED") then
            self:emit("error", code)
            print("\x1b[37;41m Database connection failed. \x1b[0m")
        end
    end)
    self.socket = socket
end

function Mongo:collection(collectionName)
    return Collection:new(self, collectionName)
end

Mongo.ObjectId = ObjectId
Mongo.Bit32 = bson.Bit32
Mongo.Bit64 = bson.Bit64
Mongo.Date = bson.Date

return Mongo
