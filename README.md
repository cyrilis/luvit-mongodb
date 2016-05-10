# Luvit MongoDB Driver

[![Join the chat at https://gitter.im/cyrilis/luvit-mongodb](https://badges.gitter.im/Join%20Chat.svg)](https://gitter.im/cyrilis/luvit-mongodb?utm_source=badge&utm_medium=badge&utm_campaign=pr-badge&utm_content=badge)

This is a pure luvit Mongodb driver with async Api. 

## What is Luvit?

[Luvit](https://luvit.io) is a Node.js like, with Asynchronous I/O support language for Lua.

Learn more a: [Luvit](https://luvit.io/docs.html)

## Install

- #### With [lit](https://luvit.io/lit.html):

    Run

  ```bash
    lit install cyrilis/luvit-mongodb
  ```

  in terminal under your project path, then `require("luvit-mongodb")` in your project.

- #### Or copy source files:

  Just put source file in your project, then require it with `./path/to/luvit-mongodb`


## Getting started

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

- ### update

  `cursor:update(doc[, callback])`

  - `doc`: *table*, **required**, The modifications to apply.
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

  - `query`: *table*, **optional** , Specifies selection criteria using query operators. To return all documents in a collection, omit this parameter or pass an empty document ({}).
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

- ### Sort

  `cursor:sort(doc[, callback])`

  - `doc`: **table**,
  - `callback`: optional, callback function

  Example:

  ```lua
  local User = db:collection("user")
  User:find():sort({age = 1}):exec(function(err, res)
      p(err, res)
  end)
  ```

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

- ### exec

  `cursor:exec(callback)`

  - `callback`: **required**, callback function

    Execute callback function after set query and limit skip params.

## Collection

- ### initialize

  A collection should initialize with db instance.

  `db:collection(collectionName)`

  - collectionName: *string*, name for collection in name.

  ```lua
  	local coll = db:collection("post")
  ```

- ### find

  `coll:find(query[, callback])`

  - query: *table*, **optional**, Specifies selection criteria using query operators. To return all documents in a collection, omit this parameter or pass an empty document ({}).
  - callback: *function*, **optional**, callback function.

  ```lua
  	 coll:find({id = 1}):exec(function(err, res)
  		 p(err, res)
  	 end)
     -- same as bellow ⬇️
  	 coll:find({id = 1}, function(err, res)
  		 p(err, res)
  	 end)
  ```

- ### distinct

```
`coll:distinct(field[, query][, callback])`
```

- field: *string*, **required**, The field for which to return distinct values.

- query: *table*, **optional**, A query that specifies the documents from which to retrieve the distinct values.

- callback: *function*, **optional**, Callback function.

  ```lua
  coll:distinct("category", {public = true}, function(err, res)
  	p(err, res)
  end)
  ```


- ### drop

  `coll:drop(callback)`

  - callback: *function*, **required**, callback function

  ```lua
  coll:drop(function(err, res)
  	 p(err, res)
  end)
  ```

- ### findAndModify

  `coll:findAndModify(query, update[, callback])`

  - query: *table*, **required**, Optional. The selection criteria for the modification. The query field employs the same query selectors as used in the `collection.find()` method. Although the query may match multiple documents, `findAndModify()` will only select one document to modify.
  - update: *table*, **required**, The update field employs the same update operators or field: value specifications to modify the selected document.
  - callback: *function*, **optional**, Callback function.

  ```lua
  coll:findAndModify({abc = 123}, {def = true}, function(err, res)
  		 p(err, res)
  end)
  ```

- ### findOne

  `coll:findOne(query[, callback])`

  - query: *table*, **required**, Optional. The selection criteria for the modification. The query field employs the same query selectors as used in the `collection.find()` method. Although the query may match multiple documents, `findAndModify()` will only select one document to modify.
  - callback: *function*, **optional**, Callback function.

  ```lua
  coll:findOne({abc = 123}, function(err, res)
  		 p(err, res)
  end)
  ```


- ### remove

  `coll:remove(query[, callback])`

  - query: *table*, **required**, Optional. The selection criteria for the modification. The query field employs the same query selectors as used in the `collection.find()` method
  - callback: *function*, **optional**, Callback function.

  ```lua
  coll:remove({public = false}, function(err, res)
  	 	p(err, res)
  end)
  ```

- ### insert

  `coll:insert(doc[, callback])`

  - doc: *table*, **required**, A document or array of documents to insert into the collection.
  - callback: *function*, **optional**, Callback function.

  ```lua
  coll:insert({title = "Hello World!"}, function(err, res)
  	  	p(err, res)
  end)
  ```

#### chainable cursor example:

```lua
coll:find():update({public = true}):exec(function(err, res)
	p(err, res)
end)
```

## Database

- ### insert:

  ```
  `db:insert(collection, document, continue, callback)`
  - `collection`: Database collection name, **required**
  - `document`: lua table, **required**
  ```

  - `continue`: if continue when error occured
  - `callback`: function, with inserted document as #1 parameter

- ### find:

  ```
  `db:find(collection, query, fields, skip, limit, callback)`
  ```

  - `collection`: Database collection name, **required**
  - `query`: mongodb query eg: `{ type: { $in: [ 'food', 'snacks' ] } }` or just `{ type: "snacks" }`, **required**
  - `fields`: limit field for return, eg: `{ item: 1, qty: 1, _id:0 }`
  - `skip`: skip counts, *int*
  - `limit`: limit return counts, *int*
  - `callback`: function, with found documents array as #1 parameter

- ### update:

  ```
  `db:update(collection, query, update, upsert, single, callback)`
  - `collection`: Database collection name, **required**
  ```

  - `query`: mongodb query eg: `{ type: { $in: [ 'food', 'snacks' ] } }` or just `{ type: "snacks" }`, **required**
  - `update`: mongodb update, eg: `{ $set: { "detail": "14Q2" } }`, **required**
  - `upsert`: if not find result with `query` params, insert a record with `update` params.
  - `single`: update multiple records or single record, **boolean**.
  - `callback`: function, without parameters

- ### remove

  ```
  `(collection, query, single, callback)`
  - `collection`: Database collection name, **required**
  ```

  - `query`: mongodb query eg: `{ type: { $in: [ 'food', 'snacks' ] } }` or just `{ type: "snacks" }`, **required**

  - `single`: remove multiple records or single, **boolean**.

    ```
    - `callback`: function, without parameters
    ```

- ### count

  ```
  `(collection, query, callback)`
  - `collection`: Database collection name, **required**
  ```

  - `query`: mongodb query eg: `{ type: { $in: [ 'food', 'snacks' ] } }` or just `{ type: "snacks" }`, **required**

    ```
    - `callback`: function, without parameters
    ```

- ### findOne:

  ```
  `db:find(collection, query, fields, skip, callback)`
  ```

  - `collection`: Database collection name, **required**
  - `query`: mongodb query eg: `{ type: { $in: [ 'food', 'snacks' ] } }` or just `{ type: "snacks" }`, **required**
  - `fields`: limit field for return, eg: `{ item: 1, qty: 1, _id:0 }`
  - `skip`: skip counts, *int*
  - `callback`: function, without found document as #1 parameter

- ### createIndex:

- ### dropIndex:

- ### dropIndexes

- ### getIndexes


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
- [x] Create index
- [x] Get index
- [x] Remove index

## License

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

