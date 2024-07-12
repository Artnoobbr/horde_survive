local pistol = {}

local player = require("player")

package.path = "./scripts/guns.lua"
local guns = require("guns")


-- TODO: Fazer a arma apontar para o mouse

local width, height = love.graphics.getDimensions()

coords = {
    x = player.coords.x,
    y = player.coords.y
}

local stats = {
    municao_max = 7,
    offsetX = 20,
    offsetY = 3,
    tempo_recarregar = 2.0,
    idle = "images/gun.png",
    bullet = "images/bullet.png",
    name = "Pistol"
}

-- TODO: Arrumar o problema da posição da arma

function love.mousepressed(x, y, button, istouch)
    if button == 1 then
        love.graphics.print("Shoot!", 700, 30)
        guns.bullet_create(coords.x, coords.y, stats.bullet)
    end
end

function pistol.update()
    local arma = love.graphics.newImage(stats.idle)
	local centerX = width/2 ; local centerY = height/2


    love.graphics.draw(arma, coords.x + stats.offsetX, coords.y + stats.offsetY, guns.rotacionar(coords.x, coords.y, stats.name), 1, 1, arma:getWidth()/2, arma:getHeight()/2)

    love.graphics.print("Pistola X: "..coords.x + stats.offsetX, 400, 45)
    love.graphics.print("Pistola Y: "..coords.y + stats.offsetY, 580, 45)
end
return pistol