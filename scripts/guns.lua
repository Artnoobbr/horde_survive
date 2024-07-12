local guns = {}

local bullets = {}

local function tablelength(T)
    local count = 0
    for _ in pairs(T) do count = count + 1 end
    return count
  end


function guns.rotacionar(gun_x, gun_y, name_gun)
    -- Primeiro preciso pegar posição do mouse e da arma e subitrair os dois
    local mouseX = love.mouse.getX(); local mouseY = love.mouse.getY()

    local angulo = math.atan2(mouseY-gun_y, mouseX-gun_x)

    love.graphics.print("Angulo: "..angulo, 400, 30)

    return angulo
end

-- TODO: Aprender metatables do lua

function guns.bullet_create(gun_x, gun_y, sprite)
    local info = {
        x = gun_x,
        y = gun_y,
        speed = 100,
        timer = 300,
        sprite = love.graphics.newImage(sprite)
    }
    table.insert(bullets, info)
end

function guns.bulletdraw()
    dt = love.timer.getDelta()
    for i, x in pairs(bullets) do
        love.graphics.draw(bullets[i].sprite, bullets[i].x, bullets[i].y)
        if bullets[i].timer > 0 then
            bullets[i].timer = bullets[i].timer - 1
            bullets[i].x = bullets[i].x + bullets[i].speed * dt
        else
            bullets[i].sprite = nil
            table.remove(bullets, i)
            collectgarbage()
        end
    end
    print(tablelength(bullets))
end


return guns