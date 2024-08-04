local inventario = {}


inventario.municao = {
    pistola = 0,
    metralhadora = 0,
    shotgun = 0
}

inventario.guns = {
    pistol = {
        disponivel = true,
        equipado = true,
        regarregando = false,
        tecla = '1',
        municao = 10
    },
    submachinegun = {
        disponivel = true,
        equipado = false,
        regarregando = false,
        municao = 25,
        tecla = '2'
    }
}

function inventario.hotbar()
    function love.keypressed(key, scancode, isrepeat)
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

return inventario