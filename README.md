#Luvit MongoDB Driver

[![Join the chat at https://gitter.im/cyrilis/luvit-mongodb](https://badges.gitter.im/Join%20Chat.svg)](https://gitter.im/cyrilis/luvit-mongodb?utm_source=badge&utm_medium=badge&utm_campaign=pr-badge&utm_content=badge)

This is a pure luvit Mongodb driver with async Api. 

## What is Luvit?
[Luvit](https://luvit.io) is a Node.js like, with Asynchronous I/O support language for Lua.

See more at: [Luvit](https://luvit.io/docs.html)

## Install

- #### With [lit](https://luvit.io/lit.html):
    Run 
    ```bash
    lit install cyrilis/luvit-mongodb
    ``` 
in terminal under your project path, then `require("luvit-mongodb")` in your project.

- #### Or copy source files:
	Just put source file in your project, then require it with `./path/to/luvit-mongodb`
    
- #### Or with NPM:
	If you would like to install with NPM, you can just run `npm install luvit-mongodb` in terminal under your project path. then require `module/luvit-mongodb` in your project.

## Initialize

```lua
local Mongo = require("luvit-mongodb")
local db = Mongo:new({db = "DATABASE_NAME"})
db:on("connect", function()
	-- Do stuff here.
    -- db:find("xxx", {}, nil, nil, nil, function(res)p(res)end)
end)
```

## Method

- ###insert:
	`db:insert(collection, document, continue, callback)`
	- `collection`: Database collection name, **required**
	- `document`: lua table, **required**
    - `continue`: if continue when error occured
    - `callback`: function, with inserted document as #1 parameter
    
- ###find:
	`db:find(collection, query, fields, skip, limit, callback)`
    - `collection`: Database collection name, **required**
    - `query`: mongodb query eg: `{ type: { $in: [ 'food', 'snacks' ] } }` or just `{ type: "snacks" }`, **required**
    - `fields`: limit field for return, eg: `{ item: 1, qty: 1, _id:0 }` 
    - `skip`: skip counts, *int*
    - `limit`: limit return counts, *int*
    - `callback`: function, with found documents array as #1 parameter

- ###update: 
	`db:update(collection, query, update, upsert, single, callback)`
	- `collection`: Database collection name, **required**
    - `query`: mongodb query eg: `{ type: { $in: [ 'food', 'snacks' ] } }` or just `{ type: "snacks" }`, **required**
    - `update`: mongodb update, eg: `{ $set: { "detail": "14Q2" } }`, **required**
    - `upsert`: if not find result with `query` params, insert a record with `update` params.
    - `single`: update multiple records or single record, **boolean**.
    - `callback`: function, without parameters
    
- ###remove 
	`(collection, query, single, callback)`
	- `collection`: Database collection name, **required**
    - `query`: mongodb query eg: `{ type: { $in: [ 'food', 'snacks' ] } }` or just `{ type: "snacks" }`, **required**
    - `single`: remove multiple records or single, **boolean**.
	- `callback`: function, without parameters

- ###count
	`(collection, query, callback)`
	- `collection`: Database collection name, **required**
    - `query`: mongodb query eg: `{ type: { $in: [ 'food', 'snacks' ] } }` or just `{ type: "snacks" }`, **required**
	- `callback`: function, without parameters
    
- ###findOne:
	`db:find(collection, query, fields, skip, callback)`
    - `collection`: Database collection name, **required**
    - `query`: mongodb query eg: `{ type: { $in: [ 'food', 'snacks' ] } }` or just `{ type: "snacks" }`, **required**
    - `fields`: limit field for return, eg: `{ item: 1, qty: 1, _id:0 }` 
    - `skip`: skip counts, *int*
    - `callback`: function, without found document as #1 parameter
    
## Usage
```lua

local Mongo = require("path/to/luvit-mongo")
local Bit64 = Mongo.Bit64
local Bit32 = Mongo.Bit32
local Date = Mongo.Date
local ObjectId = Mongo.ObjectId

m = Mongo:new({db = "test"})

m:on("connect", function()
    m:insert("abc", {name = "a", age = 2}, nil, function(res)
        local _id = res[1]._id
        m:find("abc", {_id = res[1]._id}, nil, nil, nil, function(res)
            if assert(#res == 1, "Should be 1") then
                p("Insert Pass!")
            end
            m:update("abc", {_id = _id}, {["$set"] = {height = "Hello World!"}}, true, nil,function()
                m:find("abc", {_id = _id}, nil, nil, nil, function(res)
                    if assert(res[1].height == "Hello World!", "Update faied") then
                        p("Update Passed!!!")
                        m:remove("abc", {_id = _id}, nil, function()
                            p("Deleted")
                            m:count("abc", {_id = _id}, function(res)
                                if assert(res == 0, "Should be 0") then
                                    p("Remove and count pass!")
                                end
                            end)
                        end)
                    end
                end)
            end)
        end)
    end)

    m:insert("abc", {
        _id = ObjectId.new(),
        long = Bit64(123.2),
        int = Bit32(23840.3),
        time = Date(os.time()),
        longTime = Bit64(os.time() * 1000),
        float = 123.4
    }, nil, function(result)
        print("Result:")
        p(result)
    end)

end)


```

## Test and example
See files in "test/" Folder

If you have any issue while use this library please let me know. thanks.

## TODO:
- [x] Bit64 support
- [x] Bit32 support
- [x] Date type support
- [ ] Cursor
- [ ] Raw Command support
- [ ] Write concern

## MIT
The MIT License (MIT)

Copyright (c) 2015 Cyril Hou&lt;houshoushuai@gmail.com&gt;

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.

