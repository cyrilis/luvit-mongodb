#Luvit MongoDB Driver

This is a pure luvit Mongodb driver with async Api. 

## What is Luvit?
[Luvit](https://luvit.io) is a Node.js like, with Asynchronous I/O support language for Lua.

See more at: [Luvit](https://luvit.io/docs.html)

## Install
- #### Copy Source File
	Just put source file in your project, then require it with `./path/to/luvit-mongodb`
    
- #### With Npm
	If you would like to install with NPM, you can just run `npm install luvit-mongodb` in terminal under your project path. then require `module/luvit-mongodb` in your project. 
    
## Usage
```lua
Mongo = require("./path/to/luvit-mongodb")

m = Mongo:new({db = "test"})

m:on("connect", function()

	local continueWithErr = true
    local collection = "test"
    
    m:insert(collection, {name = "c", age = 26}, continueWithErr, function(res)
        p("insert", res)
    end)

	return returnField = {}
    skip = 0
    limit = 10
    m:findOne("test", {name = "a"}, returnField, skip, function(res)
        p("findOne", res)
    end)

    m:find("test", query, returnField, skip, limit, function(res)
        p("find", res)
    end)

	local singleRemove = false
    m:remove("test", {name = "a"}, singleRemove, function()
        p("Deleted")
    end)

	local upsert = false
    local singleUpdate = false
    m:update("test", { name = "c"}, {height = "Hello World!"}, upsert, singleUpdate ,function()
        p("update")
    end)

    m:count("test", query, function(res)
        p("count", res)
    end)
end)

```

## Test and example
See files in "test/" Folder

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

