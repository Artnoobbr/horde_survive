local gunner = {}

local gunners = {}

local points = {}

local guns = require("scripts.guns.guns")

local collision = require("scripts.collision.collision")

local tools = require("scripts.tools.tools")
local anim8 = require("lib.anim8.anim8")
local pistol = require("scripts.guns.pistol")

local player = require("scripts.player.player")

local stats = {
    sprite = love.graphics.newImage("images/characters/enemy/gunner.png"),
    gun = love.graphics.newImage("images/guns/pistol/M92.png"),
    bullet = "images/guns/pistol/bullet.png",
    health = 20,
    damage = 1,
    scaleX = 2,
    scaleY = 2
}
local enemy_sheet = love.graphics.newImage("images/characters/player/player-sheet.png")
local enemy_grid = anim8.newGrid(24, 25, enemy_sheet:getWidth(), enemy_sheet:getHeight())

function  gunner.create(x, y)
    local info = {}
    info.health = stats.health
    info.sprite = stats.sprite
    info.gun = stats.gun
    info.gun_scaleX = 1.2
    info.gun_scaleY = 1.2
    info.bullet = stats.gun
    info.damage = stats.damage
    info.x = x
    info.y = y
    info.andando = false
    info.speed = 20
    info.scaleX = stats.scaleX
    info.scaleY = stats.scaleY
    info.animations = {
        idle = anim8.newAnimation(enemy_grid('1-2', 1), 2),
        movimento = anim8.newAnimation(enemy_grid('1-4', 2), 0.2),
    }
    info.anim = info.animations.idle

    info.rx = info.x
    info.ry = info.y
    info.rw = 27
    info.rh = 35
    info.id = tools.uuid()

    info.selfdestruct = function ()
        info.sprite = nil
    end

    collision.create(info.rx, info.ry,  info.rh, info.rw, 255, 0, 0, "gunners", info.id, false, collision.collisions.gunners)
    table.insert(gunners, info)
end

local timer = 0
local timer_andando = 0


-- Tome cuidado quando for mudar os numeros
local function create_point(enemy_x, enemy_y, id, random, width, height)
    local info = {}

    local x = enemy_x
    local y = enemy_y

    if random == true then
        x = math.random(-100, 100)
        y = math.random(-100, 100)

        x = x + enemy_x
        y = y + enemy_y
    end


    local valid = true



    collision.create(x, y, height, width, 255, 255 ,255, "point", id, false, collision.collisions.ponto)
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


function gunner.draw()
    for i in pairs(gunners) do
        local angulo = guns.rotacionar(gunners[i].x, gunners[i].y, true)[1]
        if gunners[i].health > 0 then
            gunners[i].anim:draw(enemy_sheet, gunners[i].x, gunners[i].y, 0, gunners[i].scaleX,  gunners[i].scaleY, 24/2, 25/2)
            love.graphics.draw(gunners[i].gun, gunners[i].x, gunners[i].y , angulo, 1, 1, gunners[i].gun:getWidth()/2,  gunners[i].gun:getHeight()/2)
            love.graphics.print(gunners[i].health, gunners[i].x-3, gunners[i].y-30)
        end

        if gunners[i].andando == true then
            for x in pairs(points) do
                if points[x].id == gunners[i].id then
                    point_id = x
                end
            end
            love.graphics.line(gunners[i].x, gunners[i].y, points[point_id].x, points[point_id].y)
        end
    end
end

function gunner.update(dt)
    for i, x in pairs(gunners) do
        local angulo = guns.rotacionar(gunners[i].x, gunners[i].y, true)[1]
        local lado = guns.rotacionar(gunners[i].x, gunners[i].y, true)[2]
        local id_collision = 0

        if (angulo > 1.6 or angulo < -1.6) then
            if gunners[i].scaleX > 0 then
                gunners[i].scaleX = -(gunners[i].scaleX)
            end
        else
            if gunners[i].scaleX < 0 then
                gunners[i].scaleX = -(gunners[i].scaleX)
            end
        end

        for x in pairs(collision.collisions.gunners) do
            if collision.collisions.gunners[x].id == gunners[i].id then
                collision.collisions.gunners[x].xbox = gunners[i].x-gunners[i].sprite:getWidth()/2
                collision.collisions.gunners[x].ybox = gunners[i].y-gunners[i].sprite:getHeight()/2
                id_collision = x
            end
        end
        
        if gunners[i].health > 0 then

            if collision.check(collision.collisions.gunners[id_collision].xbox, collision.collisions.gunners[id_collision].ybox, collision.collisions.gunners[id_collision].wbox, collision.collisions.gunners[id_collision].hbox, collision.collisions.bullets, "player") then
                local id = collision.check(collision.collisions.gunners[id_collision].xbox, collision.collisions.gunners[id_collision].ybox, collision.collisions.gunners[id_collision].wbox, collision.collisions.gunners[id_collision].hbox, collision.collisions.bullets, "player")[2]
                gunners[i].health = gunners[i].health - collision.collisions.bullets[id].damage
            end

            if gunners[i].andando == false then
                gunners[i].anim = gunners[i].animations.idle
                local found = false
               create_point(gunners[i].x, gunners[i].y, gunners[i].id, true, 10, 10)
                for b in pairs(points) do
                    if points[b].id == gunners[i].id then
                        found = true
                        gunners[i].andando = true
                    end
                end
            end

            if gunners[i].andando == true then
                gunners[i].anim = gunners[i].animations.movimento
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

            gunners[i].anim:update(dt)
        elseif gunners[i].health <= 0 then
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

local cooldown_spawn = 20

function gunner.random_create()
    local x = math.random(75, 725)
    local y = math.random(105, 523)
    local id = tools.uuid()
    local collision_id = 0

    if cooldown_spawn <= 0 then
        create_point(x, y, id, false, 30, 30)
    else
        cooldown_spawn = cooldown_spawn - 0.1
    end
    
    for i in pairs(collision.collisions.ponto) do
        if collision.collisions.ponto[i].id == id then
            collision_id = i
        end
    end

    for i in pairs(points) do
        if points[i].id == id then
            print("Point is valid!")
            gunner.create(x, y)
            table.remove(points, i)
            table.remove(collision.collisions.ponto, collision_id)
            cooldown_spawn = 50
        end
    end
end


return gunner