local dummy = {}

local dummys = {}

package.path = "./scripts/collision/collision.lua"
local collision = require("collision")
local collisions = collision.collisions

local stats = {
    sprite = love.graphics.newImage("images/characters/enemy/dummy.png"),
    health = 5
}

package.path = "./scripts/tools/tools.lua"
local tools = require("tools")


function dummy.create (x, y)
    local info = {}
    info.sprite = stats.sprite
    info.rotation = 0
    info.health = stats.health
    info.x = x
    info.y = y

    info.rx = info.x-info.sprite:getWidth()/2
    info.ry = info.y-info.sprite:getHeight()/2
    info.rw = info.sprite:getWidth()
    info.rh = info.sprite:getHeight()
    info.id = tools.uuid()

    info.selfdestruct = function ()
        info.sprite = nil
    end
    collision.create(info.rx, info.ry,  info.rh, info.rw, 0, 255, 0, "dummy", info.id, false, collision.collisions.dummys)
    
    table.insert(dummys, info)
end


function dummy.load()
    for i in pairs(dummys) do

        for v in pairs(collisions.dummys) do

            if collisions.dummys[v].id == dummys[i].id then
                collisions.dummys[v].xbox = dummys[i].x-dummys[i].sprite:getWidth()/2
                collisions.dummys[v].ybox = dummys[i].y-dummys[i].sprite:getHeight()/2
                Co_id = v
            end
        end

        if dummys[i].health > 0 then
            love.graphics.draw(dummys[i].sprite, dummys[i].x, dummys[i].y, dummys[i].rotation, 1, 1, dummys[i].sprite:getWidth()/2,  dummys[i].sprite:getHeight()/2)
            
            love.graphics.print(dummys[i].health, dummys[i].x-3, dummys[i].y-30)

            if collision.check(collisions.dummys[Co_id].xbox, collisions.dummys[Co_id].ybox, collisions.dummys[Co_id].wbox, collisions.dummys[Co_id].hbox, collision.collisions.bullets) then
                local id = collision.check(collisions.dummys[Co_id].xbox, collisions.dummys[Co_id].ybox, collisions.dummys[Co_id].wbox, collisions.dummys[Co_id].hbox, collision.collisions.bullets)[2]
                dummys[i].health = dummys[i].health - collision.collisions.bullets[id].damage
            end
        else
            dummys[i].selfdestruct()
            table.remove(dummys, i)
            table.remove(collisions.dummys, Co_id)
        end
        

    end
end

return dummy