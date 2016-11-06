local Emitter = require('core').Emitter

local Cursor = require("./cursor")


local Collection = Emitter:extend()

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
    local collectionName = self.collectionName
    local indexes = index
    local cmd = {
        { "_order_", "dropIndexes", collectionName },
        { "_order_", "index", indexes}
    }
    self.db:query("$cmd", cmd, nil, nil, 1, function(err, res)
        local result = res[1]
        if result.ok == 1 then
            cb(err, result)
        else
            cb(err or result)
        end
    end, nil)
end

function Collection:dropIndexes(cb)
    local collectionName = self.collectionName
    local indexes = "*"
    local cmd = {
        { "_order_", "dropIndexes", collectionName },
        { "_order_", "index", indexes}
    }
    self.db:query("$cmd", cmd, nil, nil, 1, function(err, res)
        local result = res[1]
        if result.ok == 1 then
            cb(err, result)
        else
            cb(err or result)
        end
    end, nil)
end

function Collection:ensureIndex(index, cb)
    self:createIndex(index, cb)
end

function Collection:createIndex(index, options, cb)
    local collectionName = self.collectionName
    local indexes
    local name = ""

    if type(options) == "function" then
      cb = options
      options = {}
    end

    if type(index) == "string" then
        indexes = index
    else
        if #index > 0 then
            for k,v in pairs(index) do
                if type(k) == "number" then
                    k = v[2]
                end
                name = name .. "_" .. k
            end
        else
            for k,v in pairs(index) do
                name = name .. "_" .. k
            end
        end
        local indexElem = { key = index, name = name }
        for k, v in pairs(options) do
            indexElem[k] = v
        end
        indexes = {indexElem}
    end

    local cmd = {
        { "_order_", "createIndexes", collectionName },
        { "_order_", "indexes", indexes}
    }
    self.db:query("$cmd", cmd, nil, nil, 1, function(err, res)
        local result = res[1]
        if result.ok == 1 then
            cb(err, result)
        else
            cb(err or result)
        end
    end, nil)
end

function Collection:getIndex(cb)
    local collectionName = self.collectionName
    local indexes = "*"
    local cmd = {
        ["listIndexes"] = collectionName
    }
    self.db:query("$cmd", cmd, nil, nil, 1, function(err, res)
        local result = res[1]
        if result.ok == 1 then
            cb(err, result)
        else
            cb(err or result)
        end
    end, nil)
end

function Collection:findAndModify(query, update, cb)
    local cursor = Cursor:new(self,query)
    return cursor:update(update, cb)
end

function Collection:findOne(query, cb)
    assert(cb and type(cb) == "function", "Callback should pass as 2nd param.")
    return Cursor:new(self, query):limit(1):exec(function (err, res)
        if err then
            cb(err)
            return false
        else
            cb(nil, res[1])
        end
    end)
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
    local cmd = {
        {"_order_", "renameCollection", oldCollectionName},
        {"_order_", "to", newCollectionName }
    }
    self.db:query("$cmd", cmd, nil, nil, 1, function(err, res)
        cb(err, res)
    end, nil)
end

return Collection
