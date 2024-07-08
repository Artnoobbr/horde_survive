local player = {}

local status = {
    speed = 1,
    idleimg = "images/ball.png"
}

local coords = {
    x = 0,
    y = 0,
    speed = 1
}

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
    coords.x = coords.x + coords.speed * d.x
    coords.y = coords.y + coords.speed * d.y

    print(coords.x)
end

local function mouse()
    local dt = love.timer.getDelta()

    local mouse = {
        x = love.mouse.getX(),
        y = love.mouse.getY()
    }

    if love.mouse.isDown(1) then
        coords.x = mouse.x
        coords.y = mouse.y
    end
    print("Mouse X: " ..mouse.x)
    print("Mouse Y: " ..mouse.y)
end

function player.update()
    Character = love.graphics.newImage(status.idleimg)
    love.graphics.draw(Character, coords.x, coords.y)
end


function player.basic_moviment()
    movimento()
    mouse()
end


return player