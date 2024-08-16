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

return inventario