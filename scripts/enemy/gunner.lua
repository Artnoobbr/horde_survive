local gunner = {}

local gunners = {}

local points = {}

local guns = require("scripts.guns.guns")

local collision = require("scripts.collision.collision")

local tools = require("scripts.tools.tools")

local player = require("scripts.player.player")

local stats = {
    sprite = love.graphics.newImage("images/characters/enemy/gunner.png"),
    gun = love.graphics.newImage("images/guns/pistol/gun.png"),
    bullet = "images/guns/pistol/bullet.png",
    health = 20,
    damage = 1
}


function  gunner.create(x, y)
    local info = {}
    info.health = stats.health
    info.sprite = stats.sprite
    info.gun = stats.gun
    info.bullet = stats.gun
    info.damage = stats.damage
    info.x = x
    info.y = y
    info.andando = false
    info.speed = 20

    info.rx = info.x-info.sprite:getWidth()/2
    info.ry = info.y-info.sprite:getHeight()/2
    info.rw = info.sprite:getWidth()
    info.rh = info.sprite:getHeight()
    info.id = tools.uuid()



    info.selfdestruct = function ()
        info.sprite = nil
    end

    collision.create(info.rx, info.ry,  info.rh, info.rw, 255, 0, 0, "gunners", info.id, false, collision.collisions.gunners)
    table.insert(gunners, info)
end

local timer = 0
local timer_andando = 0

function create_point(enemy_x, enemy_y, id)
    info = {}
    local x = math.random(-100, 100)
    local y = math.random(-100, 100)

    local valid = true


    x = x + enemy_x
    y = y + enemy_y

    collision.create(x, y, 10, 10, 255, 255 ,255, "point", id, false, collision.collisions.ponto)
    for i in pairs(collision.collisions.ponto) do
        if id == collision.collisions.ponto[i].id then
            collision_id = i
        end
    end

    if collision.check(collision.collisions.ponto[collision_id].xbox, collision.collisions.ponto[collision_id].ybox, collision.collisions.ponto[collision_id].wbox, collision.collisions.ponto[collision_id].hbox, collision.collisions.paredes) then
        print("invalid")
        table.remove(collision.collisions.ponto, collision_id)
        return
    end
    info.x = x
    info.y = y
    info.id = id
    table.insert(points, info)
end

function gunner.update()
    for i in pairs(gunners) do
        local angulo = guns.rotacionar(gunners[i].x, gunners[i].y, true)[1]
        local id_collision = 0
        local dt = love.timer.getDelta()

        for x in pairs(collision.collisions.gunners) do
            if collision.collisions.gunners[x].id == gunners[i].id then
                collision.collisions.gunners[x].xbox = gunners[i].x-gunners[i].sprite:getWidth()/2
                collision.collisions.gunners[x].ybox = gunners[i].y-gunners[i].sprite:getHeight()/2
                id_collision = x
            end
        end
        
        if gunners[i].health > 0 then
            love.graphics.draw(gunners[i].sprite, gunners[i].x, gunners[i].y, 0, 1, 1, gunners[i].sprite:getWidth()/2,  gunners[i].sprite:getHeight()/2)
            love.graphics.draw(gunners[i].gun, gunners[i].x + 20, gunners[i].y + 3, angulo, 1, 1, gunners[i].gun:getWidth()/2,  gunners[i].gun:getHeight()/2)

            love.graphics.print(gunners[i].health, gunners[i].x-3, gunners[i].y-30)

            if collision.check(collision.collisions.gunners[id_collision].xbox, collision.collisions.gunners[id_collision].ybox, collision.collisions.gunners[id_collision].wbox, collision.collisions.gunners[id_collision].hbox, collision.collisions.bullets, "player") then
                local id = collision.check(collision.collisions.gunners[id_collision].xbox, collision.collisions.gunners[id_collision].ybox, collision.collisions.gunners[id_collision].wbox, collision.collisions.gunners[id_collision].hbox, collision.collisions.bullets, "player")[2]
                gunners[i].health = gunners[i].health - collision.collisions.bullets[id].damage
            end

            if gunners[i].andando == false then
                local found = false
               create_point(gunners[i].x, gunners[i].y, gunners[i].id)
                for b in pairs(points) do
                    if points[b].id == gunners[i].id then
                        found = true
                        gunners[i].andando = true
                    end
                end
            end

            -- TODO: Consertar bug de multiplos inimigos terem o mesmo ponto de movimento
            if gunners[i].andando == true then
                local point_id = 0
                local collision_id = 0
                for x in pairs(points) do
                    if points[x].id == gunners[i].id then
                        point_id = x
                    end
                end

                for muuuu in pairs(collision.collisions.ponto) do
                    if collision.collisions.ponto[muuuu].id == gunners[i].id then
                        collision_id = muuuu
                    end
                end

                local distanciaX = gunners[i].x - points[point_id].x
                local distanciaY = gunners[i].y - points[point_id].y
                distance = math.sqrt(distanciaX*distanciaX+distanciaY*distanciaY)

                velocityX = distanciaX/distance*gunners[i].speed
                velocityY = distanciaY/distance*gunners[i].speed

                -- Se somar ele vai se afastar do ponto, se subtrair ele vai ir até o ponto
                gunners[i].x = gunners[i].x - velocityX * dt
                gunners[i].y = gunners[i].y - velocityY * dt
                timer_andando = timer_andando - dt

                 love.graphics.line(gunners[i].x, gunners[i].y, points[point_id].x, points[point_id].y)

                if collision.check(collision.collisions.ponto[collision_id].xbox, collision.collisions.ponto[collision_id].ybox, collision.collisions.ponto[collision_id].wbox, collision.collisions.ponto[collision_id].hbox, collision.collisions.gunners) then
                    table.remove(collision.collisions.ponto, collision_id)
                    table.remove(points, point_id)
                    gunners[i].andando = false
                end

            end

            if timer == 0 then
                guns.bullet_create(gunners[i].x + 20, gunners[i].y + 3, stats.bullet, angulo, gunners[i].damage, "enemy")
                timer = 20
            else
                timer = timer - 0.5
            end

        else
            gunners[i].selfdestruct()

            -- Por favor tirar isso da aqui depois
            for x in pairs(points) do
                if points[x].id == gunners[i].id then
                    point_id = x
                end
            end

            for muuuu in pairs(collision.collisions.ponto) do
                if collision.collisions.ponto[muuuu].id == gunners[i].id then
                    collision_id = muuuu
                end
            end
            table.remove(collision.collisions.gunners, id_collision)
            table.remove(gunners, i)
            table.remove(points, point_id)
            table.remove(collision.collisions.ponto, collision_id)
        end
    end
end




return gunner