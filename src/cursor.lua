local Emitter = require('core').Emitter
local ObjectId= require ( "./objectId" ).ObjectId
local Cursor = Emitter:extend()

function Cursor:initialize(collection, query, cb)
    self.db = collection.db
    self.collectionName = collection.collectionName
    self.collection = collection
    self.query = query or {}
    if cb and type(cb) == "function" then
        self.cb = cb
        self:_exec()
    end
end

function Cursor:remove(cb)
    self.action = "REMOVE"
    if cb and type(cb) == "function" then
        self.cb = cb
        self:_exec()
    end
    return self
end

function Cursor:find(query, cb)
    self.query = query or {}
    if cb and type(cb) == "function" then
        self.cb = cb
        self:_exec()
    end
    return self
end

function Cursor:fields(fields, cb)
    self._fields = fields or {}
    if cb and type(cb) == "function" then
        self.cb = cb
        self:_exec()
    end
    return self
end

function Cursor:skip(skip, cb)
    if skip then
        self._skip = skip
    end
    if cb and type(cb) == "function" then
        self.cb = cb
        self:_exec()
    end
    return self
end

function Cursor:limit(limit, cb)
    if limit then
        self._limit = limit
    end
    if cb and type(cb) == "function" then
        self.cb = cb
        self:_exec()
    end
    return self
end

function Cursor:sort(doc, cb)
    if doc then
        self._sort = doc
    end
    if cb and type(cb) == "function" then
        self.cb = cb
        self:_exec()
    end
    return self
end

function Cursor:count(cb)
    self.action = "COUNT"
    if cb and type(cb) == "function" then
        self.cb = cb
        self:_exec()
    end
end

function Cursor:update(update, cb)
    self.action = "UPDATE"
    if update then
        self._update = update
    end
    if cb and type(cb) == "function" then
        self.cb = cb
        self:_exec()
    end
    return self
end

function Cursor:_exec()
    if self.action == "COUNT" then
        local cmd = {{"_order_", "count", self.collectionName}, {"_order_", "query", self.query} }
        self.db:query("$cmd", cmd, nil, nil, 1, function(err, res)
            if err then
                self.cb(err, nil)
                return
            end
            if res[1]["errmsg"] or res[1]["err"] then
                self.cb(res[1])
                return
            end
            self.cb(err, res[1].n)
        end)
        return self
    end
    if self._sort then
        if self.query and not self.query["$query"] or not self.query then
            self.query = {{"_order_", "$query", self.query}, {"_order_", "$orderby", self._sort} }
        end
    end
    self.db:find(self.collectionName, self.query, self._fields, self._skip, self._limit, function(err, res)
        if self._update and self.action == "UPDATE" then
            if next(res) == nil then
                p("No result match: ", self.query, " for update")
                self.cb(err, {})
            else
                local ids = {}
                for _, v in pairs(res) do
                    table.insert(ids, {_id = ObjectId(v._id)})
                end
                self.db:update(self.collectionName, {["$or"]=ids}, self._update, nil, 1, self.cb)
            end
        elseif self.action == "REMOVE" then
            if next(res) == nil then
                p("No result match: ", self.query, " for remove")
                self.cb(err, {})
            else
                local ids = {}
                for _, v in pairs(res) do
                    table.insert(ids, {_id = ObjectId(v._id)})
                end
                self.db:remove(self.collectionName, {["$or"]=ids}, nil, self.cb)
            end
        else
            self.cb(err, res)
        end
    end)
end

function Cursor:exec(cb)
    assert(type(cb) == "function")
    if cb and type(cb) == "function" then
        self.cb = cb
        self:_exec()
    end
    return self
end

return Cursor