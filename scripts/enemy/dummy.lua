local dummy = {}

local dummys = {}

package.path = "./scripts/collision/collision.lua"
local collision = require("collision")

local stats = {
    sprite = love.graphics.newImage("images/characters/enemy/dummy.png"),
    health = 5
}


function dummy.create (x, y)
    local info = {}
    info.sprite = stats.sprite
    info.rotation = 0
    info.health = stats.health
    info.x = x
    info.y = y

    table.insert(dummys, info)
end


function dummy.load()
    for i, x in pairs(dummys) do
        love.graphics.draw(dummys[i].sprite, dummys[i].x, dummys[i].y, dummys[i].rotation, 1, 1, dummys[i].sprite:getWidth()/2,  dummys[i].sprite:getHeight()/2)
        collision.create(dummys[i].x, dummys[i].y, dummys[i].sprite:getHeight(), dummys[i].sprite:getWidth())
    end
end

return dummy