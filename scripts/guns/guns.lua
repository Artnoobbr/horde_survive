local guns = {}

local bullets = {}
local particles = {}

local collision = require("scripts.collision.collision")
local collisions = collision.collisions

local tools = require("scripts.tools.tools")

local player = require("scripts.player.player")

local inventario = require("scripts.player.inventario")

function directionrotation(rotation, speed)
    --cos(degrees*pi/180)*distance - this will convert degrees to change of x
    --sin(degrees*pi/180)*distance - this will convert degrees to change of y
    
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

function guns.flipimage(scaleXorY, enemy, enemy_x, enemy_y)
    local lado = guns.rotacionar(0, 0, false, true)[2]

    if enemy == true then
        lado = guns.rotacionar(enemy_x, enemy_y, true, false)[2]
    end
    
    if lado == "esquerda" and scaleXorY > 0 then
        scaleXorY = -(scaleXorY)
    elseif lado == "direita" and scaleXorY < 0 then
        scaleXorY = -(scaleXorY)
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

function guns.bullet_draw()
    for i in pairs(bullets) do
        love.graphics.draw(bullets[i].sprite, bullets[i].x, bullets[i].y, bullets[i].rotation, 1, 1, bullets[i].sprite:getWidth()/2,  bullets[i].sprite:getHeight()/2)
    end

    --love.graphics.print("Balas: "..tools.tablelength(bullets), 400, 65)
    --love.graphics.print("Colisões de bala: "..tools.tablelength(collisions.bullets), 400, 80)
    --love.graphics.print("Particulas Balas: "..tools.tablelength(particles), 400, 95)
end

function guns.particle_draw()
    for i in pairs(particles) do
        love.graphics.draw(particles[i].sprite, particles[i].x, particles[i].y, 0 , particles[i].scaleX, particles[i].scaleY, particles[i].sprite:getWidth()/2, particles[i].sprite:getHeight()/2)
    end
end

function guns.bullet_update(dt)

    -- Aqui ele faz o processo de desenhar a imagem e fazer ela se mover
    -- e depois deletar quando atingir um alvo
    for i in pairs(bullets) do
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


        if bullets[i].timer > 0 and collisions.bullets[Co_id].hit == false then
            bullets[i].timer = bullets[i].timer - 1
            local direction = directionrotation(bullets[i].rotation, bullets[i].speed)

            bullets[i].x = bullets[i].x + direction.x * dt
            bullets[i].y = bullets[i].y + direction.y * dt
        else
            --if bullets[i].timer == 0 then
              --  print("Times over")
            --end
            bullets[i].selfdestruct()
            table.remove(bullets, i)
            table.remove(collisions.bullets, Co_id)
            collectgarbage()
        end

    end

    --Carrega a particula da bala
    -- TODO: Ajeitar a "animação da bala" e variar também a posição que ela vai cair
end

function guns.particle_update()
    for i in pairs(particles) do

    if particles[i].timer > 0 then
        particles[i].timer = particles[i].timer - 0.1
        if particles[i].durationY > 0 then
            particles[i].durationY = particles[i].durationY - 0.5
            particles[i].y = particles[i].y + 2
        end
    else
        particles[i].selfdestruct()
        table.remove(particles, i)
        collectgarbage()
    end
end
end

function guns.reload_update(dt, gun_location)
    if gun_location.regarregando == true then
        gun_location.som:play()
        if gun_location.tempo_regarregar > 0 and gun_location.regarregando == true then
            gun_location.tempo_regarregar = gun_location.tempo_regarregar - dt
        end

        if gun_location.tempo_regarregar <= 0 then
            local falta = gun_location.max_municao - gun_location.municao
            gun_location.municao = gun_location.municao + falta
            gun_location.tempo_regarregar = gun_location.tempo_max
            gun_location.regarregando = false
        end
    end


end

function guns.reload_draw(gun_location)
    if gun_location.regarregando == true then
        local x_offset = 10
        local y_offset = 30
        love.graphics.setColor(0,0,0, 0.15)
        love.graphics.rectangle('fill',player.coords.x-x_offset, player.coords.y-y_offset, gun_location.multiplicador*gun_location.tempo_max, 5)
        love.graphics.setColor(255, 255,255)
        love.graphics.rectangle('fill', player.coords.x-x_offset, player.coords.y-y_offset, gun_location.multiplicador*gun_location.tempo_regarregar, 5)
        love.graphics.setColor(255, 255,255)
    end
    
end


function guns.particle(sprite_bullet, point_x, point_y, enemy, scaleY)
    local info = {}
    info.x = point_x
    info.y = point_y
    info.sprite = sprite_bullet
    info.timer = 15
    info.durationY = 5
    info.scaleX = guns.flipimage(1)
    if enemy == true then
        info.scaleX = -scaleY + 0.2
    end
    info.scaleY = 1
    info.selfdestruct = function ()
        info.sprite_bullet = nil
    end

    table.insert(particles, info)
end

function guns.unload()
    for i in pairs(bullets) do
        bullets[i] = nil
    end

    for i in pairs(particles) do
        particles[i] = nil
    end
end


return guns