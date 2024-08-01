local submachinegun = {}

local player = require("scripts.player.player")

local guns  = require("scripts.guns.guns")

coords = {
    x = player.coords.x,
    y = player.coords.y
}

local shoot = love.audio.newSource("sounds/guns/pistol/pistol.wav", "static")

local timer = 0

local width, height = love.graphics.getDimensions()

local stats = {
    offsetX = 3,
    offsetY = 11,
    idle = love.graphics.newImage("images/guns/submachinegun/MP5.png"),
    bullet = "images/guns/submachinegun/bullet.png",
    damage = 1,
    scaleX = 1.1,
    scaleY = 1.1,
    offset_barrelX = 8,
    offset_barrelY = 7
}

function submachinegun.update()
    -- Ideia de colocar a arma no centro do player com umas mãos
    
    Angulo = guns.rotacionar(coords.x, coords.y)[1]
    stats.scaleY = guns.flipimage(stats.scaleY)
    
    local barrel_point = guns.point(coords.x + stats.offset_barrelX, coords.y + stats.offset_barrelY, 10, Angulo)


    if player.guns.submachinegun == true then
        if love.mouse.isDown(1) and timer <= 0 then
            shoot:play()
            guns.bullet_create(barrel_point[1], barrel_point[2], stats.bullet, guns.rotacionar(coords.x, coords.y)[1], 1.5, "player")
            timer = 5
        end
    end

    love.graphics.draw(stats.idle, coords.x + stats.offsetX, coords.y + stats.offsetY, Angulo, stats.scaleX, stats.scaleY, stats.idle:getWidth()/2, stats.idle:getHeight()/2)


    if timer > 0 then
        timer = timer - 0.5
    end
end

return submachinegun