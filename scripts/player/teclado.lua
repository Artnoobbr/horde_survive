local teclado = {}

local inventario = require("scripts.player.inventario")
local menu       = require("scripts.menu.menu")


function teclado.update()
    function love.keypressed(key, scancode, isrepeat)

        if key == "escape" then
           menu.pausado = not menu.pausado
        end

        if menu.pausado == false then
            if key == inventario.guns.pistol.tecla and inventario.guns.pistol.equipado == false and inventario.guns.pistol.disponivel == true then
                inventario.guns.pistol.equipado = true
                inventario.guns.submachinegun.equipado = false
            end
    
            if key == inventario.guns.submachinegun.tecla and inventario.guns.submachinegun.equipado == false and inventario.guns.submachinegun.disponivel == true then
                inventario.guns.pistol.equipado = false
                inventario.guns.submachinegun.equipado = true
            end
        end

    end
end



return teclado