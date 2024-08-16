local pistol = {}

local player = require("scripts.player.player")
local menu   = require("scripts.menu.menu")

local guns = require("scripts.guns.guns")

local inventario = require("scripts.player.inventario")

local shoot = love.audio.newSource("sounds/guns/pistol/pistol.wav", "static")
local reload = love.audio.newSource("sounds/guns/pistol/pistolreload.mp3", "static")

local width, height = love.graphics.getDimensions()

coords = {
    x = player.coords.x,
    y = player.coords.y
}

local stats = {
    offsetX = 2,
    offsetY = 11,
    idle = love.graphics.newImage("images/guns/pistol/M92.png"),
    bullet = "images/guns/pistol/bullet.png",
    bullet_exit = love.graphics.newImage("images/guns/pistol/PistolAmmoSmall.png"),
    damage = 1,
    max_ammo = 10,


    scaleX = 1.2,
    scaleY = 1.2,
    offsetX_Barrel = 6,
    offsetY_Barrel = 7,
    offsetX_exit = 0,
    offsetY_exit = 6
}

local timer = 0
local timer_reload


function pistol.draw()
    love.graphics.draw(stats.idle, coords.x + stats.offsetX, coords.y + stats.offsetY, Angulo, stats.scaleX, stats.scaleY, stats.idle:getWidth()/2, stats.idle:getHeight()/2)

    love.graphics.print("Munição Pistola: "..inventario.guns.pistol.municao, 400, 45)
    love.graphics.print("Pistola Y: "..coords.y + stats.offsetY, 580, 45)
end

function pistol.update(dt)

    Angulo = guns.rotacionar(coords.x, coords.y)[1]
    local barrel_point = guns.point(coords.x + stats.offsetX_Barrel, coords.y + stats.offsetY_Barrel, 10, Angulo)
    local exitbullet_point = guns.point(coords.x + stats.offsetX_exit, coords.y + stats.offsetY_exit, 0, Angulo )


    stats.scaleY = guns.flipimage(stats.scaleY)
    if menu.pausado == false then
        function love.mousepressed(x, y, button, istouch)
            if button == 1 and timer <= 0 and inventario.guns.pistol.municao > 0 and inventario.guns.pistol.equipado == true then
                shoot:play()
                guns.bullet_create(barrel_point[1], barrel_point[2], stats.bullet, guns.rotacionar(coords.x, coords.y)[1], 1, "player")
                guns.particle(stats.bullet_exit, exitbullet_point[1], exitbullet_point[2])
                inventario.guns.pistol.municao = inventario.guns.pistol.municao - 1
                timer = 0.8
            end
        end
    end



    if love.keyboard.isDown("r") and inventario.guns.pistol.municao < stats.max_ammo and inventario.guns.pistol.regarregando == false then
        reload:play()
        timer = 2.5
        inventario.guns.pistol.regarregando = true
    end

    if inventario.guns.pistol.regarregando == true and timer <= 0 then
        guns.reload(inventario.guns.pistol, stats.max_ammo)
        inventario.guns.pistol.regarregando = false
    end

    if timer > 0 then
        timer = timer - dt
    end
end

return pistol