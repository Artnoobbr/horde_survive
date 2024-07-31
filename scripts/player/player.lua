local player = {}

package.path = "./scripts/collision/collision.lua"
local collision = require("collision")
local collisions = collision.collisions

package.path = "./lib/anim8/anim8.lua"
local anim8 = require("anim8")

love.graphics.setDefaultFilter("nearest", "nearest")

local width, height = love.graphics.getDimensions()

player.status = {
    speed = 1,
    Character = love.graphics.newImage("images/characters/robert.png"),
    health = 20,
    scaleX = 2,
    scaleY = 2
}

local player_sheet = love.graphics.newImage("images/characters/player/player-sheet.png")
local player_grid = anim8.newGrid(24, 25, player_sheet:getWidth(), player_sheet:getHeight()) 

local player_animations = {
    idle = anim8.newAnimation(player_grid('1-2', 1), 2),
    movimento = anim8.newAnimation(player_grid('1-4', 2), 0.2),
}

player_animations.anim = player_animations.idle

player.coords = {
    x = width/2,
    y = height/2,
}

player.guns = {
    pistol = false,
    submachinegun = false
}

-- Gambiarra também, provavelmente tem um método melhor
local line_coords = {
    line1 = {x2 = 0, y2 = 0, fx = 0, fy = 0},
    line2 = {x2 = 0, y2 = 0, fx = 5, fy = 25},
    line3 = {x2 = 0, y2 = 0, fx = 25, fy = 5}
}

local esq = false
local dir = false
local cima = false
local baixo = false

collision.create(player.coords.x, player.coords.y, player.status.Character:getHeight()-2, player.status.Character:getWidth(), 124, 23, 23, "player", "player", false, collision.collisions.player)

local function movimento()
    -- Parte do Movimento
    -- Temos um problema para resolver que é o player andando mais rapido na diagonal
    -- Para resolver isso a gente precisa usar a matematica

    -- Criamos uma variavel para criar um simples calculo de vetor com os movimentos

    
    local d = {x = 0, y = 0} -- direction to move in
    D = d

    local dt = love.timer.getDelta()
    local movimentando = false

    local fx1 = line_coords.line1.fx   local fy1 = line_coords.line1.fy
    local fx2 = line_coords.line2.fx   local fy2 = line_coords.line2.fy
    local fx3 = line_coords.line3.fx   local fy3 = line_coords.line3.fy


    -- NÃO USE ELSEIF NO MOVIMENTO
    if love.keyboard.isDown("w") then  
        d.y = d.y - 1 
        cima = true
        fy1 = -30 fx1 = 0

        fx2 = 10 fy2 = -30

        fx3 = -10 fy3 = -30
        movimentando = true
    else
        cima = false
    end

    if love.keyboard.isDown("s") then
        d.y = d.y + 1
        baixo = true
        movimentando = true  
        fy1 = 30 fx1 = 0

        fx2 = 10 fy2 = 30

        fx3 = -10 fy3 = 30
    else
        baixo = false
    end

    if love.keyboard.isDown("a") then 
        d.x = d.x - 1 
        esq = true
        fx1 = -30 fy1 = 0

        fx2 = -30 fy2 = 10

        fx3 = -30 fy3 = -10
        movimentando = true
    else
        esq = false
    end

    if love.keyboard.isDown("d") then 
        d.x = d.x + 1 
        dir = true
        fx1 = 30 fy1 = 0

        fx2 = 30 fy2 = 10

        fx3 = 30 fy3 = -10
        movimentando = true
    else
        dir = false
    end

    if cima and dir then
        fx1 = 20 fy1 = -20

        fx2 = 5 fy2 = -25

        fx3 = 25 fy3 = -5
    elseif cima and esq then
        fx1 = -20 fy1 = -20

        fx2 = -5 fy2 = -25

        fx3 = -25 fy3 = -5
    end

    if baixo and dir then
        fx1 = 20 fy1 = 20

        fx2 = 5 fy2 = 25

        fx3 = 25 fy3 = 5
    elseif baixo and esq then
        fx1 = -20 fy1 = 20

        fx2 = -5 fy2 = 25

        fx3 = -25 fy3 = 5
    end
    
    line_coords.line1.x2 = coords.x + fx1 line_coords.line1.y2 = coords.y + fy1

    line_coords.line2.x2 = coords.x + fx2 line_coords.line2.y2 = coords.y + fy2

    line_coords.line3.x2 = coords.x + fx3 line_coords.line3.y2 = coords.y + fy3

    -- De acordo com o teorema de pitagoras quando andamos na diagonal (x: 1 e y: 1) o resultado
    -- vai ser 1.4 ao inves do 1.0, ai a gente vê o porque da diferança da velocidade
    -- Para resolver isso a gente tem que "normalizar" a direção do vetor, mantendo a direção, mas mantendo a direção
    -- Então para isso dividimos pela largura
    local length = math.sqrt(d.x^2 + d.y^2)
    if length > 0 then
        d.x = d.x / length
        d.y = d.y / length
    end


    for i in pairs(collisions.player) do
        if collisions.player[i].name == "player" then
            collisions.player[i].xbox = coords.x-player.status.Character:getWidth()/2
            collisions.player[i].ybox = coords.y-player.status.Character:getHeight()/2
            Co_id = i
        end
    end

    local line1 = false
    local line2 = false
    local line3 = false
    
    if collision.ponto_retangulo(line_coords.line1.x2, line_coords.line1.y2, collision.collisions.paredes) then
        line1 = true
    else
        line1 = false
    end

    if collision.ponto_retangulo(line_coords.line2.x2, line_coords.line2.y2, collision.collisions.paredes) then
        line2 = true
    else
        line2 = false
    end

    if collision.ponto_retangulo(line_coords.line3.x2, line_coords.line3.y2, collision.collisions.paredes) then
        line3 = true
    else
        line3 = false
    end
    

    for i in pairs(collisions.player) do
        if collision.check(collisions.player[Co_id].xbox, collisions.player[Co_id].ybox, collisions.player[Co_id].wbox, collisions.player[Co_id].hbox, collision.collisions.paredes) and (line1 or line2 or line3) then
            movimentando = false
            player.status.speed = 0
        else
            player.status.speed = 1
        end
    end
    --print("X: "..d.x)
    --print("Y: "..d.y)
    
    -- depois é so aplicar com a velocidade propria
    coords.x = coords.x + player.status.speed * (d.x)
    coords.y = coords.y + player.status.speed * d.y


    player.coords.x = coords.x
    player.coords.y = coords.y

    if movimentando == true then
        player_animations.anim = player_animations.movimento
    else
        player_animations.anim = player_animations.idle
    end

   player_animations.anim:update(dt)

end

function player.update()
    local pl_x = "Player X: " ..coords.x
    local pl_y = "Player Y: " ..coords.y
    love.graphics.print(player.status.health, player.coords.x-3, player.coords.y-30)

    --love.graphics.draw(player.status.Character, coords.x, coords.y, 0, 1, 1, player.status.Character:getWidth()/2, player.status.Character:getHeight()/2)
    player_animations.anim:draw(player_sheet, coords.x, coords.y, 0, player.status.scaleX, player.status.scaleY, 24/2, 25/2)

    love.graphics.print(pl_x, 400, 15)
    love.graphics.print(pl_y, 580, 15)

    
    --love.graphics.line(coords.x, coords.y, line_coords.line1.x2 , line_coords.line1.y2)

    --love.graphics.line(coords.x, coords.y, line_coords.line2.x2 , line_coords.line2.y2)
    --love.graphics.line(coords.x, coords.y, line_coords.line3.x2 , line_coords.line3.y2)

    if collision.check(collisions.player[1].xbox, collisions.player[1].ybox, collisions.player[1].wbox, collisions.player[1].hbox, collisions.bullets, "enemy") then
        local id = collision.check(collisions.player[1].xbox, collisions.player[1].ybox, collisions.player[1].wbox, collisions.player[1].hbox, collisions.bullets, "enemy")[2]
        player.status.health = player.status.health - collisions.bullets[id].damage
    end
 
end

function player.basic_moviment()
    movimento()
end



return player