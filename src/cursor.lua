local Emitter = require('core').Emitter

Cursor = Emitter:extend()

function Cursor:initialize(collection, query, cb)
    self.db = collection.db
    self.collectionName = collection.collectionName
    self.collection = collection
    self.query = query
    if cb and type(cb) == "function" then
        self.cb = cb
        self._exec()
    end
    return self
end

function Cursor:remove(cb)
    self.action = "REMOVE"
    if cb and type(cb) == "function" then
        self.cb = cb
        self._exec()
    end
    return self
end

function Cursor:find(query, cb)
    if query then
        self.query = query
    end
    if cb and type(cb) == "function" then
        self.cb = cb
        self._exec()
    end
    return self
end

function Cursor:order(order, cb)
    if order then
        self.order = order
    end
    if cb and type(cb) == "function" then
        self.cb = cb
        self._exec()
    end
    return self
end

function Cursor:skip(skip, cb)
    if skip then
        self.skip = skip
    end
    if cb and type(cb) == "function" then
        self.cb = cb
        self._exec()
    end
    return self
end

function Cursor:limit(limit, cb)
    if limit then
        self.limit = limit
    end
    if cb and type(cb) == "function" then
        self.cb = cb
        self._exec()
    end
    return self
end

function Cursor:count(cb)
    if cb and type(cb) == "function" then
        self.cb = cb
        self._exec()
    end
    return self
end

function Cursor:update(update, cb)
    if update then
        self.update = update
    end
    if cb and type(cb) == "function" then
        self.cb = cb
        self._exec()
    end
    return self
end

function Cursor:_exec()
    self.db:find(self.collectionName, self.query, self.fields, self.skip, self.limit, function(err, res)
        -- TODO: update and remove and find
        -- TODO: What if update $set or something else?
    end)
end

function Cursor:exec(cb)
    assert(type(cb) == "function")
    if cb and type(cb) == "function" then
        self.cb = cb
        self._exec()
    end
    return self
end

module.exports = Cursor