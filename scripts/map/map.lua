local map = {}

local sti = require("lib/sti")

package.path = "./scripts/collision/collision.lua"
local collision = require("collision")
local collisions = collision.collisions

local paredes = {}

function map.update()
    DebugMap = sti("maps/debugmap.lua")

    if DebugMap.layers["paredes"] then
        for i, obj in pairs(DebugMap.layers["paredes"].objects) do
            collision.create(obj.x+obj.width/2+1, obj.y+obj.height/2, obj.height, obj.width, 0, 255, 0, "wall", math.random(), false)
        end
    end
end

function map.drawmap()
    DebugMap:draw()
end




return map