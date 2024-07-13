local map = {}

local sti = require("lib/sti")

function map.update()
    Testmap = sti("maps/testMap.lua")
end

function map.drawmap()
    Testmap:draw()
end


return map