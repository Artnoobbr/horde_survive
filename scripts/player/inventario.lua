local inventario = {}

local monogram = love.graphics.newFont("fonts/monogram/ttf/monogram.ttf", 50)

inventario.guns = {
    pistol = {
        disponivel = true,
        equipado = true,
        regarregando = false,
        tecla = '1',
        municao = 10,
        max_municao = 10
    },
    submachinegun = {
        disponivel = true,
        equipado = false,
        regarregando = false,
        municao = 25,
        max_municao = 25,
        tecla = '2'
    }
}

inventario.location = inventario.guns.pistol

function inventario.reset()
    inventario.guns.pistol.municao = 10
    inventario.guns.submachinegun.municao = 25
    inventario.guns.pistol.max_municao = 10
    inventario.guns.submachinegun.max_municao = 25
end



function inventario.draw()
    local municao_info = love.graphics.newText(monogram, inventario.location.municao.."/"..inventario.location.max_municao)
    love.graphics.draw(municao_info, 90, 555)
end

return inventario