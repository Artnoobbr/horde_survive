local player = {}

local collision = require("scripts.collision.collision")
local menu      = require("scripts.menu.menu")
local collisions = collision.collisions

local global = require("scripts.global")

local anim8 = require("lib.anim8.anim8")
love.graphics.setDefaultFilter("nearest", "nearest")

local width, height = love.graphics.getDimensions()

player.status = {
    speed = 3,
    Character = love.graphics.newImage("images/characters/robert.png"),
    health = 20,
    max_health = 20,
    scaleX = 2,
    scaleY = 2,
    spawn = false,
    morto = false,
    timer_morto = 0.75
}

local player_sheet = love.graphics.newImage("images/characters/player/player-sheet.png")
local player_grid = anim8.newGrid(24, 25, player_sheet:getWidth(), player_sheet:getHeight()) 

local player_animations = {
    idle = anim8.newAnimation(player_grid('1-2', 1), 2),
    movimento = anim8.newAnimation(player_grid('1-4', 2), 0.2),
    morrendo = anim8.newAnimation(player_grid('6-8',5), 0.25)
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



function player.spawn(x, y)
    coords.x = x
    coords.y = y
    collision.create(player.coords.x, player.coords.y, 35, 27, 124, 23, 23, "player", "player", false, collision.collisions.player)
    player.status.spawn = true
end

function player.update(dt)
    if player.status.spawn == true then
        -- Parte do Movimento
        -- Temos um problema para resolver que é o player andando mais rapido na diagonal
        -- Para resolver isso a gente precisa usar a matematica

        -- Criamos uma variavel para criar um simples calculo de vetor com os movimentos

        
        local d = {x = 0, y = 0} -- direction to move in
        D = d

        local movimentando = false

        local mouseX = love.mouse.getX(); local mouseY = love.mouse.getY()
        local playerX = player.coords.x ; local playerY = player.coords.y

        local angulo = math.atan2(playerY-mouseY, playerX-mouseX)

        if player.status.morto == false then
            if (angulo > 1.6 or angulo < -1.6) then
                if player.status.scaleX < 0 then
                    player.status.scaleX = -(player.status.scaleX)
                end
            else
                if player.status.scaleX > 0 then
                    player.status.scaleX = -(player.status.scaleX)
                end
            end
        end
 


        -- NÃO USE ELSEIF NO MOVIMENTO
        if love.keyboard.isDown("w") and player.status.morto == false then  
            d.y = d.y - 1
            movimentando = true
        end

        if love.keyboard.isDown("s") and player.status.morto == false then
            d.y = d.y + 1
            movimentando = true
        end

        if love.keyboard.isDown("a") and player.status.morto == false then 
            d.x = d.x - 1
            movimentando = true
        end

        if love.keyboard.isDown("d") and player.status.morto == false then 
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
                    coords.x = coords.x - ( player.status.speed * d.x)
                end

                if ad == true then
                    coords.y = coords.y - (player.status.speed * d.y)
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

        if player.status.health <= 0 then
            player.status.morto = true
            player_animations.anim = player_animations.morrendo
            movimentando = false
            player.status.timer_morto = player.status.timer_morto - dt

            if player.status.timer_morto <= 0 then
                player_animations.anim:gotoFrame(3)
                menu.pausado = true
            end
        end

        

        if collision.check(collisions.player[1].xbox, collisions.player[1].ybox, collisions.player[1].wbox, collisions.player[1].hbox, collisions.bullets, "enemy") and global.god_mode == false and player.status.morto == false then
            local id = collision.check(collisions.player[1].xbox, collisions.player[1].ybox, collisions.player[1].wbox, collisions.player[1].hbox, collisions.bullets, "enemy")[2]
            player.status.health = player.status.health - collisions.bullets[id].damage
        end 

        player_animations.anim:update(dt)
    end
end

function player.draw()
    if player.status.spawn == true then
        local pl_x = "Player X: " ..coords.x
        local pl_y = "Player Y: " ..coords.y

        -- Basicamente pra criar uma barra de vida
        -- basta desenhar um quadrado com a largura dependendo da variavel de vida
        local c = player.status.health/player.status.max_health
        local cor = {2-2*c,2*c,0}
        love.graphics.setColor(cor)
        love.graphics.rectangle('fill', player.coords.x-10, player.coords.y-20, player.status.health, 5)
        love.graphics.setColor(1,1,1)
        love.graphics.rectangle('line',player.coords.x-10, player.coords.y-20,player.status.max_health, 5)

    
        player_animations.anim:draw(player_sheet, coords.x, coords.y, 0, player.status.scaleX, player.status.scaleY, 24/2, 25/2)
    
        --love.graphics.print(pl_x, 400, 15)
        --love.graphics.print(pl_y, 580, 15)

    end
end

function player.reset()
    player.status.morto = false
    player.status.spawn = false
    player.status.health = 20
    player.status.timer_morto = 0.75
end


return player