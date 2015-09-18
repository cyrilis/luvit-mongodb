--
-- Created by: Cyril.
-- Created at: 15/6/21 上午2:05
-- Email: houshoushuai@gmail.com
--

Mongo = require("../")
Bit64 = Mongo.Bit64
Bit32 = Mongo.Bit32
Date = Mongo.Date

m = Mongo:new({db = "test"})

m:on("connect", function()
    m:insert("abc", {name = "c", age = 26}, nil, function(res)
        p("insert", res)
    end)

    m:insert("abc", {long = Bit64(123.2), longTime = Bit64(os.time() * 1000), int = Bit32(23840.3), time = Date(os.time()*1000 + 197), float = 123.4}, nil, function(result)
        print("Result:")
        p(result)
    end)

    m:findOne("abc", {name = "a"}, {}, nil, function(res)
        p("findOne", res)
    end)

    m:find("abc", {}, nil, nil, nil, function(res)
        p("find", res)
    end)

    m:remove("abc", {name = "a"}, nil, function()
        p("Deleted")
    end)

    m:update("abc", { name = "c"}, {["$set"] = {height = "Hello World!"}}, true, nil,function()
        p("update")
    end)

    m:count("abc", {}, function(res)
        p("count", res)
    end)
end)

