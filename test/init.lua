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
    m:collection("abc"):createIndex({name = 1, age = 1}, function(err, res)
        p(err, res)
    end)

    m:collection("abc"):getIndex(function(err, res)
        p(err, res)
    end)

    m:insert("abc", {name = "a", age = 2}, nil, function(err, res)
        local _id = res[1]._id
        m:find("abc", {_id = res[1]._id},nil, nil, nil, function(err, res)
            if assert(#res == 1, "Should be 1") then
                p("Insert Pass!")
            end
            m:update("abc", {_id = _id}, {["$set"] = {height = "Hello World!"}}, true, nil,function(err, ures)
                m:find("abc", {_id = _id}, nil, nil, nil, function(err, res)
                    if assert(res[1].height == "Hello World!", "Update faied") then
                        p("Update Passed!!!")
                        m:remove("abc", {_id = _id}, nil, function()
                            p("Deleted")
                            m:count("abc", {_id = _id}, function(err, res)
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


--    for i = 1,500 do
--        local insert = {
--            uid = math.floor(math.random(1000)),
--            bean = math.floor(math.random(1000))
--        }
--        p( "INSERT: ----------->", i, insert)
--        m:insert("Leaderboard", insert, nil, function(err, res)
--            p("Result: ----------->", err, res)
--        end)
--    end

    m:insert("abc", {content = "Content"}, nil, function(err, result)
        m:find("abc", {_id = result[1]._id}, nil, nil, nil, function(err, res)
            p(res, "1")
            m:find("abc", {["$or"]=res}, nil, nil, nil, function(errs, ress)
                p(ress, "2")
            end)
            p("Wow , PASS")
        end)
    end )

    -- sort test
    m:collection("number"):insert({{number = 1},{number = 2},{number = 3}}, function(err, res)
        p("SORT------", err, res)
        m:collection("number"):find():sort({number = 1}):exec(function(err, res)
            p("SORT------ TEST ---------", err, res)
            print("\n\n")
            m:collection("number"):drop(function() end)
        end)
    end)

    local coll = m:collection("abc")
    coll:insert({{abc = 123}, {abc = 222}, {abc = 123}}, function(err, res)
        if err then
            p(err)
            return false
        end
        coll:find({abc = 123}):fields({_id = 1}):exec(function(err, res)
            p(err, res, "collection:find")
        end)

        coll:findAndModify({abc = 123}, {["$set"] = { mark = "xxxxxxx"}}, function(err, res)
            p(err, res, "Cursor:limit, Cursor:update")
            coll:find({mark = {["$ne"] = "xxx"}}):exec(function(err, res)
                p(err, res, "Cursor:find for Cursor limit and update")
                coll:find({abc = 123}):count(function(err, res)
                    p(err, res, "Cursor:count")
                    coll:drop(function(err, res)
                        p(err, res, "DROP") -- Test Passed!!!
                    end)
                end)
            end)
        end)


        coll:distinct("abc",nil, function(err, res)
            p(err, res)
        end)

    end)

    m:insert("abc", {
        _id = ObjectId.new(),
        long = Bit64(123.2),
        int = Bit32(23840.3),
        time = Date(os.time()),
        longTime = Bit64(os.time() * 1000),
        float = 123.4
    }, nil, function(err, result)
        p("Result:", result)
    end)

    local User = m:collection("user")
    local insertAndRemove = function()
        p("Inserting......")
        User:insert({
            name = "Cyril Hou",
            id = 1,
            birthday = os.date(),
            bio = "Weak tables is a good mechanism, but how to find proper objects to use in weak tables? There is about 2Mb of lua code in project and it's problematically to find what objects are not deallocated and still has a reference. Transforming all tables into weak tables will cause objects premature destroying. Also tables are mostly used to take ownership of objects and to free them only when it's necessary. Problem is that not all references are released and i cant' find them"
        }, function(err, users)
            p("Removing.......")
            User:remove(users[1]):exec(function(err, res)
                p("Done")
            end)
        end)
    end
    insertAndRemove()

end)

