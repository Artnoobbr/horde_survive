local map = {}

local sti = require("lib.sti")

local collision = require("scripts.collision.collision")

package.path = "./scripts/tools/tools.lua"
local tools = require("tools")

--local parede = {}

function map.update()
    DebugMap = sti("maps/dungeontest2.lua")

    if DebugMap.layers["paredes"] then
        for i, obj in pairs(DebugMap.layers["paredes"].objects) do
            collision.create(obj.x+obj.width/2+1, obj.y+obj.height/2, obj.height, obj.width, 0, 0, 255, "parede", math.random(), false, collision.collisions.paredes)
        end
    end    
end

function map.test()
    for i in pairs(collision.collisions.paredes) do
        local col = collision.collisions.paredes[i]
        collision.check(col.xbox, col.ybox, col.wbox, col.hbox, collision.collisions.bullets)
    end
end

function map.drawmap()
    DebugMap:draw()
    love.graphics.print("Colisões paredes: "..tools.tablelength(collision.collisions.paredes), 500, 65)
end


return map