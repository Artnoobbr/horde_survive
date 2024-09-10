local inventario = {}

local monogram = love.graphics.newFont("fonts/monogram/ttf/monogram.ttf", 50)

inventario.guns = {
    pistol = {
        disponivel = true,
        equipado = true,
        regarregando = false,
        tecla = '2',
        municao = 10,
        max_municao = 10,
        tempo_regarregar = 2.5,
        tempo_max = 2.5,
        multiplicador = 9,
        som = love.audio.newSource("sounds/guns/pistol/pistolreload.mp3", "static"),
        img_equipado = love.graphics.newImage("images/hud/guns/pistol_on.png"),
        img_desequipado = love.graphics.newImage("images/hud/guns/pistol_off.png")
    },
    submachinegun = {
        disponivel = true,
        equipado = false,
        regarregando = false,
        municao = 25,
        max_municao = 25,
        tecla = '1',
        tempo_regarregar = 3.25,
        tempo_max = 3.25,
        multiplicador = 7,
        som = love.audio.newSource("sounds/guns/submachinegun/submachinegun_reload.wav", "static"),
        img_equipado = love.graphics.newImage("images/hud/guns/submachinegun_on.png"),
        img_desequipado = love.graphics.newImage("images/hud/guns/submachinegun_off.png")
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
    
    if inventario.guns.pistol.equipado then
        love.graphics.draw(inventario.guns.pistol.img_equipado, 400, 545)
        love.graphics.draw(inventario.guns.submachinegun.img_desequipado, 300, 545)
    else
        love.graphics.draw(inventario.guns.pistol.img_desequipado, 400, 545)
        love.graphics.draw(inventario.guns.submachinegun.img_equipado, 300, 545)
    end
    
    love.graphics.draw(municao_info, 90, 555)
end

return inventario