local player = {}

local collision = require("scripts.collision.collision")
local collisions = collision.collisions

local global = require("scripts.global")

local anim8 = require("lib.anim8.anim8")
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

collision.create(player.coords.x, player.coords.y, 35, 27, 124, 23, 23, "player", "player", false, collision.collisions.player)

local function movimento()
    -- Parte do Movimento
    -- Temos um problema para resolver que é o player andando mais rapido na diagonal
    -- Para resolver isso a gente precisa usar a matematica

    -- Criamos uma variavel para criar um simples calculo de vetor com os movimentos

    
    local d = {x = 0, y = 0} -- direction to move in
    D = d

    local dt = love.timer.getDelta()
    local movimentando = false

    local mouseX = love.mouse.getX(); local mouseY = love.mouse.getY()
    local playerX = player.coords.x ; local playerY = player.coords.y

    local angulo = math.atan2(playerY-mouseY, playerX-mouseX)

    if (angulo > 1.6 or angulo < -1.6) then
        if player.status.scaleX < 0 then
            player.status.scaleX = -(player.status.scaleX)
        end
       
    else
        if player.status.scaleX > 0 then
            player.status.scaleX = -(player.status.scaleX)
        end
    end


    -- NÃO USE ELSEIF NO MOVIMENTO
    if love.keyboard.isDown("w") then  
        d.y = d.y - 1
        movimentando = true
    end

    if love.keyboard.isDown("s") then
        d.y = d.y + 1
        movimentando = true
    end

    if love.keyboard.isDown("a") then 
        d.x = d.x - 1
        movimentando = true
    end

    if love.keyboard.isDown("d") then 
        d.x = d.x + 1
        movimentando = true
    end

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
            collisions.player[i].xbox = coords.x-24/2
            collisions.player[i].ybox = coords.y-25/2
            Co_id = i
        end

        if collision.check(collisions.player[Co_id].xbox, collisions.player[Co_id].ybox, collisions.player[Co_id].wbox, collisions.player[Co_id].hbox, collision.collisions.paredes) and movimentando == true then
            local length_point_x = 10
            local length_point_y = 20
            -- Número é negativo
            if d.x < 0 then
                length_point_x = -(length_point_x)
            end
            if d.y < 0 then
                length_point_y = -10
            end

            local ws = false
            local ad = false

            --Verifica se pode andar pela direita ou pela esquerda
            if collision.ponto_retangulo(coords.x + (d.x + length_point_x), coords.y, collision.collisions.paredes) then
                ws = true
            end

            if collision.ponto_retangulo(coords.x, coords.y + (d.y + length_point_y), collision.collisions.paredes) then
                ad = true
            end

            if ws == true then
                coords.x = coords.x - d.x
            end

            if ad == true then
                coords.y = coords.y - d.y
            end

        end
    end
    
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

    if collision.check(collisions.player[1].xbox, collisions.player[1].ybox, collisions.player[1].wbox, collisions.player[1].hbox, collisions.bullets, "enemy") then
        local id = collision.check(collisions.player[1].xbox, collisions.player[1].ybox, collisions.player[1].wbox, collisions.player[1].hbox, collisions.bullets, "enemy")[2]
        player.status.health = player.status.health - collisions.bullets[id].damage
    end
 
end

function player.basic_moviment()
    movimento()
end


return player