#Luvit MongoDB Driver

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
-- replace `DATABASE_NAME` above with a DB name.
db:on("connect", function()
	-- Do stuff here.
    local Post = db:collection("post")
    local page = 1
    Post:insert({
		    title = "Hello word!", 
		    content = "Here is the first blog post ....",
		    author = "Cyril Hou"
		},function(err, res)
		    p(res)
	    end)
	local posts = Post:find({author = "Cyril Hou"})
	posts:limit(10):skip(page * 10):update({authorAge = 25}):exec(function(err, res)
		p(err, res)
	end)
	
	Post:distinct("category", function(err, res)
		p("All distinct value of `category` in post collections: ", res)
	end)
end)
```

## Cursor
### Method:

- ### update
 `cursor:update(doc[, callback])`
 - `doc`: mongodb docs, table in lua 
 - `callback`: **optional**,  callback function

 ```lua
 post:update({abc = 123}, function(err, res)
	 p(err, res)
 end)
 -- same as bellow ⬇️
  post:update({abc = 123}):exec(function(err, res)
	 p(err, res)
 end)
 
 ```
- ### find
 `cursor:find(query[, callback])`
 - `query`:  mongodb query
 - `callback`: **optional**， callback function

  ```lua
 post:find({abc = 123}, function(err, res)
	 p(err, res)
 end)
 -- same as bellow ⬇️
  post:find({abc = 123}):exec(function(err, res)
	 p(err, res)
 end)

 ```
- ### remove
 `cursor:remove([callback])`
 - `callback`: **optional**, callback function

  ```lua
 post:remove(function(err, res)
	 p(err, res)
 end)
 -- same as bellow ⬇️
  post:remove():exec(function(err, res)
	 p(err, res)
 end)

 ```
- ### skip
 `cursor:skip(skip[, callback])`
 - `skip`: *number*, docs to skip in query.
 - `callback`:  **optional**, callback function

- ### limit
 `cursor:limit(limit[, callback])`
 - `limit`: *number*, limit return docs count.
 - `callback`:  **optional**, callback function

- ### count
 `cursor:count([callback])`
 - `callback`: **optional**, callback function

  ```lua
 post:count(function(err, res)
	 p(err, res)
 end)
 -- same as bellow ⬇️
  post:remove():exec(function(err, res)
	 p(err, res)
 end)
 ```




## db: method

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


## Test and example
See files in "test/" Folder

If you have any issue while use this library please let me know. thanks.

## TODO:
- [x] Bit64 support
- [x] Bit32 support
- [x] Date type support
- [x] Cursor
- [x] Raw Command support
- [x] Write concern
- [ ] Auth

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

