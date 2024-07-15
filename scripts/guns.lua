local guns = {}

local bullets = {}

package.path = "./scripts/collision/collision.lua"
local collision = require("collision")

local function tablelength(T)
    local count = 0
    for _ in pairs(T) do count = count + 1 end
    return count
end


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

function guns.rotacionar(gun_x, gun_y)
    -- Primeiro preciso pegar posição do mouse e da arma e subitrair os dois
    local mouseX = love.mouse.getX(); local mouseY = love.mouse.getY()

    local angulo = math.atan2(mouseY-gun_y, mouseX-gun_x)
    love.graphics.print("Angulo: "..angulo, 400, 30)

    return angulo
end

-- TODO: Aprender metatables do lua

function guns.bullet_create(gun_x, gun_y, sprite, rotation)
    local info = {}
    info.sprite = love.graphics.newImage(sprite)
    info.x = gun_x
    info.y = gun_y
    info.speed = 250
    info.timer = 200
    info.rotation = rotation
    info.selfdestruct = function ()
        info.sprite = nil
    end

    table.insert(bullets, info)

end

function guns.bulletupdate()
    dt = love.timer.getDelta()
    
    for i, x in pairs(bullets) do

        --Gambiarra, enquanto eu não achar a forma de rotacionar o retangulo que fique na posição
        --Da bala, eu vou deixar assim mesmo

        -- Informações da caixa de colisão

        local rx = (bullets[i].x+7)-bullets[i].sprite:getWidth()/2
        local ry = bullets[i].y-bullets[i].sprite:getHeight()/2
        local rw = bullets[i].sprite:getWidth()-15
        local rh = bullets[i].sprite:getHeight()

        love.graphics.push()
        love.graphics.setColor(255,0,0)
        love.graphics.rectangle("line", rx, ry, rw, rh)
        love.graphics.setColor(255,255,255)
        love.graphics.pop()

        
        love.graphics.draw(bullets[i].sprite, bullets[i].x, bullets[i].y, bullets[i].rotation, 1, 1, bullets[i].sprite:getWidth()/2,  bullets[i].sprite:getHeight()/2)

        if bullets[i].timer > 0 and collision.check(rx,ry, rw, rh, "dummy") == false then
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
            collectgarbage()
        end

    end
    love.graphics.print("Balas: "..tablelength(bullets), 400, 65)
end


return guns