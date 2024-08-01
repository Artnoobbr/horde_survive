local pistol = {}

local player = require("scripts.player.player")

local guns = require("scripts.guns.guns")

local shoot = love.audio.newSource("sounds/guns/pistol/pistol.wav", "static")

-- TODO: Fazer a arma apontar para o mouse

local width, height = love.graphics.getDimensions()

coords = {
    x = player.coords.x,
    y = player.coords.y
}

local stats = {
    offsetX = 2,
    offsetY = 11,
    idle = love.graphics.newImage("images/guns/pistol/M92.png"),
    bullet = "images/guns/pistol/bullet.png",
    damage = 1,
    scaleX = 1.2,
    scaleY = 1.2,
    offsetX_Barrel = 6,
    offsetY_Barrel = 7
}

-- TODO: Arrumar o problema da posição da arma

local timer = 0

function pistol.update()
	local centerX = width/2 ; local centerY = height/2
    Angulo = guns.rotacionar(coords.x, coords.y)[1]
    local barrel_point = guns.point(coords.x + stats.offsetX_Barrel, coords.y + stats.offsetY_Barrel, 10, Angulo)

    --love.graphics.circle( "fill", barrel_point[1], barrel_point[2], 5 )

    stats.scaleY = guns.flipimage(stats.scaleY)

    if player.guns.pistol == true then
        function love.mousepressed(x, y, button, istouch)
            if button == 1 and timer <= 0 then
                shoot:play()
                guns.bullet_create(barrel_point[1], barrel_point[2], stats.bullet, guns.rotacionar(coords.x, coords.y)[1], 1, "player")
                timer = 5
            end
        end
    end

    --TODO: TROCAR ISSO DA AQUI PARA UMA FUNÇÃO


    love.graphics.draw(stats.idle, coords.x + stats.offsetX, coords.y + stats.offsetY, Angulo, stats.scaleX, stats.scaleY, stats.idle:getWidth()/2, stats.idle:getHeight()/2)

    love.graphics.print("Pistola X: "..coords.x + stats.offsetX, 400, 45)
    love.graphics.print("Pistola Y: "..coords.y + stats.offsetY, 580, 45)

    
    if timer > 0 then
        timer = timer - 0.1
    end
end
return pistol