local Mongo = require("../")
local Bit64 = Mongo.Bit64
local Bit32 = Mongo.Bit32
local Date = Mongo.Date
local ObjectId = Mongo.ObjectId

local db = Mongo:new({db = "test"})

db:on("connect", function()
    db:collection("post"):drop(function()
        db:collection("post"):insert({
            created_at = Date(),
            title = "Title One"
        }, function(err, result)
            p("1", err, result)
            local post = result[1]
            post.updated_at = Date()
            db:collection("post"):find({title = "Title One"}):update({["$set"] = post}):exec(function(err, result)
                p("2", err, result)
            end)
        end)
    end)

end)