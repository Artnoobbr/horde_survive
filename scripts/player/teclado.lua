local teclado = {}

local inventario = require("scripts.player.inventario")
local menu       = require("scripts.menu.menu")
local player     = require("scripts.player.player")
local guns       = require("scripts.guns.guns")


function teclado.update()
    function love.keypressed(key, scancode, isrepeat)

        --print(key)

        if key == "escape" and player.status.morto == false then
           menu.pausado = not menu.pausado
           menu.menu_loc = 'pause'
        end

        if menu.pausado == false then
            if key == inventario.guns.pistol.tecla and inventario.guns.pistol.equipado == false and inventario.guns.pistol.disponivel == true and inventario.location.regarregando == false then
                inventario.guns.pistol.equipado = true
                inventario.guns.submachinegun.equipado = false
                inventario.location = inventario.guns.pistol
            end
    
            if key == inventario.guns.submachinegun.tecla and inventario.guns.submachinegun.equipado == false and inventario.guns.submachinegun.disponivel == true and inventario.location.regarregando == false then
                inventario.guns.pistol.equipado = false
                inventario.guns.submachinegun.equipado = true
                inventario.location = inventario.guns.submachinegun
            end

            if inventario.location.regarregando == false then
                if key == 'r' then
                    inventario.location.regarregando = true;
                end
            end
        end

    end
end



return teclado