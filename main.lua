-- Variaveis globais usam maisculo no começo

package.path = "./scripts/player.lua"

local player = require("player")

function love.update(dt)
    player.basic_moviment()
end

function love.load()
    Dt = love.timer.getDelta()
    
end

function love.draw()
    player.update()
end
