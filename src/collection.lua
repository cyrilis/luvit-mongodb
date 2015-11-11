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

function Collection:distinct(field, query, cb)
    if type(query) == "function" and not cb then
        cb = query
        query = nil
    end
    local cmd = {{"_order_", "distinct", self.collectionName}, {"_order_", "key", field} }
    if query then
        table.insert(cmd, {"_order_", "query", query})
    end
    self.db:query("$cmd", cmd, nil, nil, 1, function(err, res)
        if err then
            cb(err, nil)
            return
        end
        if res[1]["errmsg"] or res[1]["err"] then
            cb(res[1])
            return
        end
        cb(err, res[1].values)
    end, nil)
end

function Collection:drop(cb)
    local cmd = {["drop"] = self.collectionName }
    self.db:query("$cmd", cmd, nil, nil, 1, function(err, res)
        if err then
            cb(err, nil)
            return
        end
        if res[1]["errmsg"] or res[1]["err"] then
            cb(res[1])
            return
        end
        cb(nil, res[1])
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
    local cursor = Cursor:new(self,query)
    return cursor:update(update, cb)
end

function Collection:findOne(query, cb)
    return Cursor:new(self, query):limit(1, function(err, res)
        if err then
            cb(err)
            return false
        end
        cb(nil, res[1])
    end)
end

function Collection:getIndexs(cb)
    -- Todo: return all index
end

function Collection:insert(doc, cb)
    self.db:insert(self.collectionName, doc, nil, cb)
end

function Collection:remove(query, cb)
    local cursor = Cursor:new(self, query)
    return cursor:remove(cb)
end

function Collection:renameCollection(newName, cb)
    local oldCollectionName = self.db.db .. "." ..self.collectionName .. "\0"
    local newCollectionName = self.db.db .. "." ..newName .. "\0"
    local cmd = {{"_order_", "renameCollection", oldCollectionName}, {"_order_", "to", newCollectionName}}
    self.db:query("$cmd", cmd, nil, nil, 1, function(err, res)
        cb(err, res)
    end, nil)
end

module.exports = Collection