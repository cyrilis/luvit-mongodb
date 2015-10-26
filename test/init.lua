--
-- Created by: Cyril.
-- Created at: 15/6/21 上午2:05
-- Email: houshoushuai@gmail.com
--

local Mongo = require("../")
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
            m:update("abc", {_id = _id}, {["$set"] = {height = "Hello World!"}}, true, nil,function(ures)
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

    m:insert("abc", {content = "Content"}, nil, function(result)
        m:find("abc", {_id = result[1]._id}, nil, nil, nil, function(res)
            assert(res[1].content == result[1].content, ":( not match")
            p("Wow , PASS")
        end)
    end )

    m:insert("abc", {
        _id = ObjectId.new(),
        long = Bit64(123.2),
        int = Bit32(23840.3),
        time = Date(os.time()),
        longTime = Bit64(os.time() * 1000),
        float = 123.4
    }, nil, function(result)
        p("Result:", result)
    end)

end)

