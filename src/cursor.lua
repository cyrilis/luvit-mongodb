local Emitter = require('core').Emitter

Cursor = Emitter:extend()

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
    self.db:find(self.collectionName, self.query, self.fields, self._skip, self._limit, function(err, res)
        if self._update and self.action == "UPDATE" then
            self.db:update(self.collectionName, {["$or"]=res}, self._update, nil, 1, self.cb)
        elseif self.action == "REMOVE" then
            self.db:remove(self.collectionName, {["$or"]=res}, nil, self.cb)
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