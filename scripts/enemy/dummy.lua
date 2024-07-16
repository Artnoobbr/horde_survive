local dummy = {}

local dummys = {}
local limit = 1

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

    --collision.create(dummys[i].x+1, dummys[i].y, dummys[i].sprite:getHeight()-5, dummys[i].sprite:getWidth()-15, 0, 255, 0, "dummy", 12323)
    collision.create(info.rx, info.ry,  info.rh, info.rw, 0, 255, 0, "dummy", info.id)
    
    table.insert(dummys, info)
end


function dummy.load()
    for i in pairs(dummys) do

        for v in pairs(collisions) do

            if collisions[v].id == dummys[i].id then
                collisions[v].xbox = dummys[i].x-dummys[i].sprite:getWidth()/2
                collisions[v].ybox = dummys[i].y-dummys[i].sprite:getHeight()/2
                Collisions_id = v
                
                if collision.check(collisions[v].xbox, collisions[v].ybox, collisions[v].wbox, collisions[v].hbox, "bol") == true then
                    dummys[i].health = dummys[i].health - 1
                end
            
            end
        end

        if dummys[i].health > 0 then
            love.graphics.draw(dummys[i].sprite, dummys[i].x, dummys[i].y, dummys[i].rotation, 1, 1, dummys[i].sprite:getWidth()/2,  dummys[i].sprite:getHeight()/2)
            
            love.graphics.print(dummys[i].health, dummys[i].x-3, dummys[i].y-30)
        else
            dummys[i].selfdestruct()
            table.remove(dummys, i)
            table.remove(collisions, Collisions_id)
        end
        

    end
end

return dummy