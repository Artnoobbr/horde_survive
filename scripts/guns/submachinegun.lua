local submachinegun = {}

local player = require("scripts.player.player")

local guns  = require("scripts.guns.guns")

local inventario = require("scripts.player.inventario")

coords = {
    x = player.coords.x,
    y = player.coords.y
}

submachinegun.stats_global = {
    dano = 1
}

local shoot = love.audio.newSource("sounds/guns/pistol/pistol.wav", "static")
local reload = love.audio.newSource("sounds/guns/submachinegun/submachinegun_reload.wav", "static")

local timer = 0

local width, height = love.graphics.getDimensions()

local stats = {
    offsetX = 3,
    offsetY = 11,
    idle = love.graphics.newImage("images/guns/submachinegun/MP5.png"),
    bullet = "images/guns/submachinegun/bullet.png",
    bullet_exit = love.graphics.newImage("images/guns/submachinegun/PistolAmmoSmall.png"),
    max_ammo = 25,
    scaleX = 1.1,
    scaleY = 1.1,
    offset_barrelX = 8,
    offset_barrelY = 7,
    offset_exitX = 0,
    offset_exitY = 0
}

shoot:setVolume(0.3)

function submachinegun.draw()
    love.graphics.draw(stats.idle, coords.x + stats.offsetX, coords.y + stats.offsetY, Angulo, stats.scaleX, stats.scaleY, stats.idle:getWidth()/2, stats.idle:getHeight()/2)
    --love.graphics.print("Munição Submetralhadora: "..inventario.guns.submachinegun.municao, 400, 45)
end

function submachinegun.update(dt)

    Angulo = guns.rotacionar(coords.x, coords.y)[1]
    stats.scaleY = guns.flipimage(stats.scaleY)

    local barrel_point = guns.point(coords.x + stats.offset_barrelX, coords.y + stats.offset_barrelY, 10, Angulo)
    local exit_point = guns.point(coords.x + stats.offset_exitX, coords.y + stats.offset_exitY, 0, Angulo)

    if love.mouse.isDown(1) and timer <= 0  and inventario.guns.submachinegun.municao > 0 and inventario.guns.submachinegun.equipado == true then
        shoot:play()
        guns.bullet_create(barrel_point[1], barrel_point[2], stats.bullet, guns.rotacionar(coords.x, coords.y)[1], submachinegun.stats_global.dano, "player")
        guns.particle(stats.bullet_exit, exit_point[1], exit_point[2])
        inventario.guns.submachinegun.municao = inventario.guns.submachinegun.municao - 1
        timer = 0.32
    end

    if love.keyboard.isDown("r") and inventario.guns.submachinegun.municao < stats.max_ammo and inventario.guns.pistol.regarregando == false then
        timer = 3.0
        inventario.guns.submachinegun.regarregando = true
        reload:play()
    end

    if inventario.guns.submachinegun.regarregando == true and timer <= 0 then
        guns.reload(inventario.guns.submachinegun, stats.max_ammo)
        inventario.guns.submachinegun.regarregando = false
    end

    if timer > 0 then
        timer = timer - dt
    end
end

return submachinegun