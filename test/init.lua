--
-- Created by: Cyril.
-- Created at: 15/6/21 上午2:05
-- Email: houshoushuai@gmail.com
--

Mongo = require("../")

m = Mongo:new({db = "test"})

m:on("connect", function()
    m:insert("abc", {name = "c", age = 26}, nil, function(res)
        p("insert", res)
    end)

    m:findOne("abc", {name = "a"}, {}, nil, nil, function(res)
        p("findOne", res)
    end)

    m:find("abc", {}, nil, nil, nil, function(res)
        p("find", res)
    end)

    m:remove("abc", {name = "a"}, nil, function()
        p("Deleted")
    end)

    m:update("abc", { name = "c"}, {height = "Hello World!"}, true, nil,function()
        p("update")
    end)

    m:count("abc", {}, nil, nil, nil, function(res)
        p("count", res)
    end)
end)

