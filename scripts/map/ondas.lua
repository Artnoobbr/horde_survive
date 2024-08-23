local ondas = {}

local gunners = require("scripts.enemy.gunner")
local tools   = require("scripts.tools.tools")
local player  = require("scripts.player.player")
local pistol  = require("scripts.guns.pistol")
local submachinegun = require("scripts.guns.submachinegun")

local width = love.graphics.getWidth()
local height = love.graphics.getHeight()

local monogram = love.graphics.newFont("fonts/monogram/ttf/monogram.ttf", 40)

local status = {
    matou = 0
}


local onda = {
    vida_inicial = 5,
    velocidade_inicial = 20,
    dano_incial = 1,
    quantidade_padrao = 5,
    onda_atual = 1,
    onda_em_progresso = false
}

local multiplicador = {
    vida_multiplicador = 1,
    velocidade_multiplicador = 1,
    dano_multiplicador = 1,
    quantidade_multiplicador = 1,
    player_dano_multiplicador = 1
}

ondas.score = {
    ondas_sobrevividas = 0,
    inimigos_mortos = 0
}

local tempo_texto = 20

-- TODO: Ondas infinitas

function ondas.update(dt)
    if onda.onda_em_progresso == true then
       if gunners.quantidade_spawns < onda.quantidade_padrao then
            gunners.random_create(onda.velocidade_inicial, onda.vida_inicial, onda.dano_incial)
       end

       if gunners.mortos >= onda.quantidade_padrao then
            tempo_texto = 20
            player.status.health = 20
            onda.onda_atual = onda.onda_atual + 1
            ondas.score.ondas_sobrevividas = ondas.score.ondas_sobrevividas + 1
            print(ondas.score.ondas_sobrevividas)
            ondas.score.inimigos_mortos = ondas.score.inimigos_mortos + gunners.mortos
            status.matou = gunners.mortos
            gunners.mortos = 0
            gunners.quantidade_spawns = 0
            onda.onda_em_progresso = false

            if onda.onda_atual < 5 then
                multiplicador.dano_multiplicador = multiplicador.dano_multiplicador + 0.030
                multiplicador.quantidade_multiplicador = multiplicador.quantidade_multiplicador + 0.090
                multiplicador.velocidade_multiplicador = multiplicador.velocidade_multiplicador + 0.040
                multiplicador.vida_multiplicador = multiplicador.vida_multiplicador + 0.095
                multiplicador.player_dano_multiplicador = multiplicador.player_dano_multiplicador + 0.05
            else
                multiplicador.dano_multiplicador = multiplicador.dano_multiplicador + 0.070
                multiplicador.quantidade_multiplicador = multiplicador.quantidade_multiplicador + 0.090
                multiplicador.velocidade_multiplicador = multiplicador.velocidade_multiplicador + 0.045
                multiplicador.vida_multiplicador = multiplicador.vida_multiplicador + 0.12
                multiplicador.player_dano_multiplicador = multiplicador.player_dano_multiplicador + 0.08
            end


            onda.dano_incial = onda.dano_incial * multiplicador.dano_multiplicador
            onda.vida_inicial = onda.vida_inicial * multiplicador.vida_multiplicador
            onda.quantidade_padrao = onda.quantidade_padrao * multiplicador.quantidade_multiplicador
            onda.velocidade_inicial = onda.velocidade_inicial * multiplicador.velocidade_multiplicador
            pistol.stats_global.dano = pistol.stats_global.dano * multiplicador.player_dano_multiplicador
            submachinegun.stats_global.dano = submachinegun.stats_global.dano * multiplicador.player_dano_multiplicador

       end
    end
end

function ondas.draw()
        if onda.onda_em_progresso == false and tempo_texto > 0 then
        local onda_texto = love.graphics.newText(monogram, "Onda "..onda.onda_atual)
        love.graphics.draw(onda_texto, width/2, 200, 0, 1, 1, onda_texto:getWidth()/2, onda_texto:getHeight()/2)
        tempo_texto = tempo_texto - 0.1
    elseif tempo_texto <= 0 then
        onda.onda_em_progresso = true
    end
end

function ondas.reset()
    tempo_texto = 20
    onda.onda_atual = 1
    gunners.mortos = 0
    gunners.quantidade_spawns = 0
    onda.onda_em_progresso = false

    onda.dano_incial = 1
    onda.vida_inicial = 5
    onda.velocidade_inicial = 20
    onda.quantidade_padrao = 5

    pistol.stats_global.dano = 1
    submachinegun.stats_global.dano = 1
    
    for i in pairs(multiplicador) do
        multiplicador[i] = 1
    end

    ondas.score.ondas_sobrevividas = 0
    ondas.score.inimigos_mortos = 0

end

return ondas