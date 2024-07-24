local pistol = {}

local player = require("player")

package.path = "./scripts/guns/guns.lua"
local guns = require("guns")

local shoot = love.audio.newSource("sounds/guns/pistol/pistol.wav", "static")


-- TODO: Fazer a arma apontar para o mouse

local width, height = love.graphics.getDimensions()

coords = {
    x = player.coords.x,
    y = player.coords.y
}

local stats = {
    offsetX = 20,
    offsetY = 3,
    idle = love.graphics.newImage("images/guns/pistol/gun.png"),
    bullet = "images/guns/pistol/bullet.png",
    damage = 1
}

-- TODO: Arrumar o problema da posição da arma

local timer = 0

function pistol.update()
	local centerX = width/2 ; local centerY = height/2
    Angulo = guns.rotacionar(coords.x, coords.y)

    if player.guns.pistol == true then
        function love.mousepressed(x, y, button, istouch)
            if button == 1 and timer <= 0 then
                shoot:play()
                guns.bullet_create(coords.x + 25, coords.y, stats.bullet, guns.rotacionar(coords.x, coords.y), 1)
                timer = 5
            end
        end
    end


    love.graphics.draw(stats.idle, coords.x + stats.offsetX, coords.y + stats.offsetY, Angulo, 1, 1, stats.idle:getWidth()/2, stats.idle:getHeight()/2)

    love.graphics.print("Pistola X: "..coords.x + stats.offsetX, 400, 45)
    love.graphics.print("Pistola Y: "..coords.y + stats.offsetY, 580, 45)

    
    if timer > 0 then
        timer = timer - 0.1
    end
end
return pistol