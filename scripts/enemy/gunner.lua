local gunner = {}

local gunners = {}

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

function gunner.update()
    for i in pairs(gunners) do
        local angulo = guns.rotacionar(gunners[i].x, gunners[i].y, true)[1]
        local id_collision = 0

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

            if timer == 0 then
                guns.bullet_create(gunners[i].x + 20, gunners[i].y + 3, stats.bullet, angulo, gunners[i].damage, "enemy")
                timer = 20
            else
                timer = timer - 0.5
            end
            

        else
            gunners[i].selfdestruct()

            table.remove(collision.collisions.gunners, id_collision)
            table.remove(gunners, i)
        end
    end
end




return gunner