local guns = {}

local bullets = {}

local collision = require("scripts.collision.collision")
local collisions = collision.collisions

local tools = require("scripts.tools.tools")

local player = require("scripts.player.player")

local function directionrotation(rotation, speed)
    --cos(degrees*pi/180)*distance - this will convert degrees to change of x
    --sin(degrees*pi/180)*distance - this will convert degrees to change of y

    -- TODO: Prestar mais atenção nas aulas de geometria
    
    -- rotation is on radians
    local angle = rotation * (180/math.pi)
    
    return {
        x = math.cos(angle*math.pi/180)*speed,
        y = math.sin(angle*math.pi/180)*speed
    }

end

function guns.rotacionar(gun_x, gun_y, playerS, mouseXplayer)
    -- Primeiro preciso pegar posição do mouse e da arma e subitrair os dois
    local angulo = 0
    local lado = 'nenhum'

    if playerS == nil or false then
        local mouseX = love.mouse.getX(); local mouseY = love.mouse.getY()
        angulo = math.atan2(mouseY-gun_y, mouseX-gun_x)
        
    elseif playerS == true then
        local playerX = player.coords.x ; local playerY = player.coords.y
        angulo = math.atan2(playerY-gun_y, playerX-gun_x)
    end

    if mouseXplayer == true then
        local mouseX = love.mouse.getX(); local mouseY = love.mouse.getY()
        local playerX = player.coords.x ; local playerY = player.coords.y

        angulo = math.atan2(playerY-mouseY, playerX-mouseX)
    end



    if angulo > 1.6 or angulo < -1.6 then
        lado = "direita"
    else
        lado = "esquerda"
    end
    
    

    return {angulo, lado}
end

function guns.flipimage(scaleXorY)
    local lado = guns.rotacionar(0, 0, false, true)[2]
    
    if lado == "esquerda" and scaleXorY > 0 then
        scaleXorY = -(scaleXorY)
        player.status.scaleX = -(player.status.scaleX)
    elseif lado == "direita" and scaleXorY < 0 then
        scaleXorY = -(scaleXorY)
        player.status.scaleX = -(player.status.scaleX)
    end

    return scaleXorY
end


-- Essa função vai criar um ponto que orbite a uma posição da arma
-- Usado para cria o ponto do cano da arma e aonde a bala deve sair
function guns.point(gun_x, gun_y, gun_length, angle)
    local dt = love.timer.getDelta()
    local new_angle = angle + 1*dt
    local new_x = gun_x + math.cos(new_angle) * gun_length
    local new_y = gun_y + math.sin(new_angle) * gun_length

    return {new_x, new_y}
end

function guns.bullet_create(gun_x, gun_y, sprite, rotation, damage, type)
    local info = {}
    info.sprite = love.graphics.newImage(sprite)
    info.x = gun_x
    info.y = gun_y
    info.name = "bullet"
    info.speed = 250
    info.timer = 200
    info.type = type
    info.rotation = rotation
    info.selfdestruct = function ()
        info.sprite = nil
    end

    info.damage = damage

    -- maybe remove this, because is not necessary in the table
    info.rx = info.x-info.sprite:getWidth()/2
    info.ry = info.y-info.sprite:getHeight()/2
    info.rw = info.sprite:getWidth()-15
    info.rh = info.sprite:getHeight()
    info.id = tools.uuid()

    collision.create(info.rx, info.ry, info.rh, info.rw, 255, 0 ,0, info.name, info.id, true, collision.collisions.bullets, info.damage, info.type)

    

    table.insert(bullets, info)

end

function guns.bulletupdate()
    dt = love.timer.getDelta()
    
    for i, x in pairs(bullets) do

        --Gambiarra, enquanto eu não achar a forma de rotacionar o retangulo que fique na posição
        --Da bala, eu vou deixar assim mesmo

        -- Informações da caixa de colisão
        for v in pairs(collisions.bullets) do
            if collisions.bullets[v].id == bullets[i].id then
                collisions.bullets[v].xbox = (bullets[i].x+7)-bullets[i].sprite:getWidth()/2
                collisions.bullets[v].ybox = bullets[i].y-bullets[i].sprite:getHeight()/2
                Co_id = v
            end
        end

        
        love.graphics.draw(bullets[i].sprite, bullets[i].x, bullets[i].y, bullets[i].rotation, 1, 1, bullets[i].sprite:getWidth()/2,  bullets[i].sprite:getHeight()/2)

        if bullets[i].timer > 0 and collisions.bullets[Co_id].hit == false then
            bullets[i].timer = bullets[i].timer - 1
            local direction = directionrotation(bullets[i].rotation, bullets[i].speed)

            bullets[i].x = bullets[i].x + direction.x * dt
            bullets[i].y = bullets[i].y + direction.y * dt
        else
            if bullets[i].timer == 0 then
                print("Times over")
            end
            bullets[i].selfdestruct()
            table.remove(bullets, i)
            table.remove(collisions.bullets, Co_id)
            collectgarbage()
        end

    end
    love.graphics.print("Balas: "..tools.tablelength(bullets), 400, 65)
    love.graphics.print("Colisões de bala: "..tools.tablelength(collisions.bullets), 400, 80)
end


return guns