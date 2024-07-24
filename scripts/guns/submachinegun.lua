local submachinegun = {}

package.path = "./scripts/player/player.lua"
local player = require("player")

package.path = "./scripts/guns/guns.lua"
local guns  = require("guns")

coords = {
    x = player.coords.x,
    y = player.coords.y
}

local shoot = love.audio.newSource("sounds/guns/pistol/pistol.wav", "static")

local timer = 0

local width, height = love.graphics.getDimensions()

local stats = {
    offsetX = 20,
    offsetY = 3,
    idle = love.graphics.newImage("images/guns/submachinegun/sub.png"),
    bullet = "images/guns/submachinegun/bullet.png",
    damage = 1
}

function submachinegun.update()
    -- Ideia de colocar a arma no centro do player com umas mãos
    Angulo = guns.rotacionar(coords.x, coords.y)

    if player.guns.submachinegun == true then
        if love.mouse.isDown(1) and timer <= 0 then
            shoot:play()
            guns.bullet_create(coords.x + 25, coords.y, stats.bullet, guns.rotacionar(coords.x, coords.y), 1.5)
            timer = 5
        end
    end

    love.graphics.draw(stats.idle, coords.x + stats.offsetX, coords.y + stats.offsetY, Angulo, 1, 1, stats.idle:getWidth()/2, stats.idle:getHeight()/2)


    if timer > 0 then
        timer = timer - 0.5
    end
end

return submachinegun