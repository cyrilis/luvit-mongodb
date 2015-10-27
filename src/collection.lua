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
    self.db:query("$cmd", {drop = 1}, nil, nil, 1, function(err, res)
        cb(err, res)
    end, nil)
end

function Collection:drop(cb)
    -- Todo: Drop
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
    -- Todo: Insert
end

function Collection:remove(query, cb)
    local cursor = Cursor:new(query)
    cursor:remove(cb)
end

function Collection:renameCollection(newName, cb)
    self.collectionName = newName
    -- TODO: Rename Collection
end

module.exports = Collection