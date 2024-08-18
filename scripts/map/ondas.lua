local ondas = {}

local gunners = require("scripts.enemy.gunner")
local tools   = require("scripts.tools.tools")
local player = require("scripts.player.player")

local width = love.graphics.getWidth()
local height = love.graphics.getHeight()

local monogram = love.graphics.newFont("fonts/monogram/ttf/monogram.ttf", 40)

local onda = {}

local status = {
    matou = 0
}

onda[1] = {
    max_inimigos = 5
}
onda[2] = {
    max_inimigos = 7
}

onda.onda_atual = 1
onda.onda_em_progresso = false


local tempo_texto = 20

function ondas.update(dt)
    if onda.onda_em_progresso == true then
       if gunners.quantidade_spawns < onda[onda.onda_atual].max_inimigos then
            gunners.random_create()
       end

       if gunners.mortos >= onda[onda.onda_atual].max_inimigos then
            tempo_texto = 20
            onda.onda_atual = onda.onda_atual + 1
            status.matou = gunners.mortos
            gunners.mortos = 0
            gunners.quantidade_spawns = 0
            onda.onda_em_progresso = false
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
end

return ondas