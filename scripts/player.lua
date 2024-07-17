local player = {}

local status = {
    speed = 1,
    Character = love.graphics.newImage("images/characters/robert.png")
}

player.coords = {
    x = 0,
    y = 0,
}

package.path = "./scripts/collision/collision.lua"
local collision = require("collision")
local collisions = collision.collisions


collision.create(player.coords.x, player.coords.y, status.Character:getHeight(), status.Character:getWidth(), 124, 23, 23, "player", "player", false)

local function movimento()
    -- Parte do Movimento
    -- Temos um problema para resolver que é o player andando mais rapido na diagonal
    -- Para resolver isso a gente precisa usar a matematica

    -- Criamos uma variavel para criar um simples calculo de vetor com os movimentos
    local d = {x = 0, y = 0} -- direction to move in

    -- NÃO USE ELSEIF NO MOVIMENTO
    if love.keyboard.isDown("w") then d.y = d.y - 1 end
    if love.keyboard.isDown("s") then d.y = d.y + 1 end
    if love.keyboard.isDown("a") then d.x = d.x - 1 end
    if love.keyboard.isDown("d") then d.x = d.x + 1 end

    -- De acordo com o teorema de pitagoras quando andamos na diagonal (x: 1 e y: 1) o resultado
    -- vai ser 1.4 ao inves do 1.0, ai a gente vê o porque da diferança da velocidade
    -- Para resolver isso a gente tem que "normalizar" a direção do vetor, mantendo a direção, mas mantendo a direção
    -- Então para isso dividimos pela largura
    local length = math.sqrt(d.x^2 + d.y^2)
    if length > 0 then
        d.x = d.x / length
        d.y = d.y / length
    end

    -- depois é so aplicar com a velocidade propria
    coords.x = coords.x + status.speed * d.x
    coords.y = coords.y + status.speed * d.y

end



function player.update()
    local pl_x = "Player X: " ..coords.x
    local pl_y = "Player Y: " ..coords.y

    love.graphics.draw(status.Character, coords.x, coords.y, 0, 1, 1, status.Character:getWidth()/2, status.Character:getHeight()/2)

    love.graphics.print(pl_x, 400, 15)
    love.graphics.print(pl_y, 580, 15)

    for i in pairs(collisions) do
        if collisions[i].id == "player" then
            print("found")
            collisions[i].xbox = player.coords.x
            collisions[i].ybox = player.coords.y
        end
    end
end





function player.basic_moviment()
    movimento()
end


return player