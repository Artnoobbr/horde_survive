local guns = {}

local bullets = {}

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
    local info = {
        sprite = love.graphics.newImage(sprite),
        x = gun_x,
        y = gun_y,
        speed = 250,
        timer = 300,
        rotation = rotation
    }
    table.insert(bullets, info)
end

function guns.bulletupdate()
    dt = love.timer.getDelta()
    
    for i, x in pairs(bullets) do

        love.graphics.draw(bullets[i].sprite, bullets[i].x, bullets[i].y, bullets[i].rotation, 1, 1, bullets[i].sprite:getWidth()/2,  bullets[i].sprite:getHeight()/2)

        local d = {x = 0, y = 0}

        if bullets[i].timer > 0 then
            bullets[i].timer = bullets[i].timer - 1
            local direction = directionrotation(bullets[i].rotation, bullets[i].speed)

            bullets[i].x = bullets[i].x + direction.x * dt
            bullets[i].y = bullets[i].y + direction.y * dt
            

        else
            bullets[i].sprite = nil
            table.remove(bullets, i)
            collectgarbage()
        end
    end
    love.graphics.print("Balas: "..tablelength(bullets), 400, 65)
end


return guns