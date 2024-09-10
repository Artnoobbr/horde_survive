local mouse = {}

local pistol = require("scripts.guns.pistol")
local guns = require("scripts.guns.guns")
local inventario = require("scripts.player.inventario")
local player = require("scripts.player.player")

function mouse.update()
    function love.mousepressed(x, y, button, istouch)

        if button == 1 and pistol.timer <= 0 and inventario.guns.pistol.municao > 0 and inventario.guns.pistol.equipado == true and inventario.guns.pistol.regarregando == false then
            pistol.stats_global.shoot:play()
            guns.bullet_create(pistol.barrel_point[1], pistol.barrel_point[2], pistol.stats_global.bullet, guns.rotacionar(player.coords.x, player.coords.y)[1], pistol.stats_global.dano, "player")
            guns.particle(pistol.stats_global.bullet_exit, pistol.exitbullet_point[1], pistol.exitbullet_point[2])
            inventario.guns.pistol.municao = inventario.guns.pistol.municao - 1
            pistol.timer = 0.8
        end
    end
end

return mouse