local pistol = {}

local player = require("scripts.player.player")

local guns = require("scripts.guns.guns")

local inventario = require("scripts.player.inventario")

local reload = love.audio.newSource("sounds/guns/pistol/pistolreload.mp3", "static")

local width, height = love.graphics.getDimensions()

coords = {
    x = player.coords.x,
    y = player.coords.y
}

pistol.stats_global = {
    bullet = "images/guns/pistol/bullet.png",
    bullet_exit = love.graphics.newImage("images/guns/pistol/PistolAmmoSmall.png"),
    shoot = love.audio.newSource("sounds/guns/pistol/pistol.wav", "static")
}

local stats = {
    offsetX = 2,
    offsetY = 11,
    idle = love.graphics.newImage("images/guns/pistol/M92.png"),
    damage = 1,
    max_ammo = 10,


    scaleX = 1.2,
    scaleY = 1.2,
    offsetX_Barrel = 6,
    offsetY_Barrel = 7,
    offsetX_exit = 0,
    offsetY_exit = 6
}

pistol.timer = 0
local timer_reload


function pistol.draw()
    love.graphics.draw(stats.idle, coords.x + stats.offsetX, coords.y + stats.offsetY, Angulo, stats.scaleX, stats.scaleY, stats.idle:getWidth()/2, stats.idle:getHeight()/2)

    --love.graphics.print("Munição Pistola: "..inventario.guns.pistol.municao, 400, 45)
    --love.graphics.print("Pistola Y: "..coords.y + stats.offsetY, 580, 45)
end

function pistol.update(dt)

    Angulo = guns.rotacionar(coords.x, coords.y)[1]
    pistol.barrel_point = guns.point(coords.x + stats.offsetX_Barrel, coords.y + stats.offsetY_Barrel, 10, Angulo)
    pistol.exitbullet_point = guns.point(coords.x + stats.offsetX_exit, coords.y + stats.offsetY_exit, 0, Angulo )


    stats.scaleY = guns.flipimage(stats.scaleY, false, 0, 0)

    if love.keyboard.isDown("r") and inventario.guns.pistol.municao < stats.max_ammo and inventario.guns.pistol.regarregando == false then
        reload:play()
        pistol.timer = 2.5
        inventario.guns.pistol.regarregando = true
    end

    if inventario.guns.pistol.regarregando == true and pistol.timer <= 0 then
        guns.reload(inventario.guns.pistol, stats.max_ammo)
        inventario.guns.pistol.regarregando = false
    end

    if pistol.timer > 0 then
        pistol.timer = pistol.timer - dt
    end
end

return pistol