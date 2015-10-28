local Emitter = require('core').Emitter

local Cursor = require("./cursor")


Collection = Emitter:extend()

function Collection:initialize(db, collectionName)
    self.collectionName = collectionName
    self.db = db
end

function Collection:find(query, cb)
    return Cursor:new(self, query, cb)
end

function Collection:distinct(field, cb)
    local cmd = {["distinct"] = self.collectionName, ["key"] = field }
    self.db:query("$cmd", cmd, nil, nil, 1, function(err, res)
        cb(err, res)
    end, nil)
end

function Collection:drop(cb)
    local cmd = {["drop"] = self.collectionName}
    self.db:query("$cmd", cmd, nil, nil, 1, function(err, res)
        cb(err, res)
    end, nil)
end

function Collection:dropIndex(index, cb)
    -- Todo: drop index
end

function Collection:dropIndexs(cb)
    -- Todo: drop All Index
end

function Collection:createIndex(index, cb)
    -- Todo: create Index
end

function Collection:findAndModify(query, update, cb)
    local cursor = Cursor:new(query)
    return cursor:update(update, cb)
end

function Collection:findOne(query, cb)
    return Cursor:new(query):limit(1, cb)
end

function Collection:getIndexs(cb)
    -- Todo: return all index
end

function Collection:insert(doc, cb)
    self.db:insert(self.collectionName, doc, nil, cb)
end

function Collection:remove(query, cb)
    local cursor = Cursor:new(query)
    cursor:remove(cb)
end

function Collection:renameCollection(newName, cb)
    local oldCollectionName = self.db.db .. "." ..self.collectionName .. "\0"
    local newCollectionName = self.db.db .. "." ..newName .. "\0"
    local cmd = {["renameCollection"] = oldCollectionName, ["to"] = newCollectionName }
    self.db:query("$cmd", cmd, nil, nil, 1, function(err, res)
        cb(err, res)
    end, nil)
end

module.exports = Collection