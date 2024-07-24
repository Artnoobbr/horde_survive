local gunner = {}

local gunners = {}

package.path = "./scripts/guns/guns.lua"
local guns = require("guns")

package.path = "./scripts/collision/collision.lua"
local collision = require("collision")

package.path = "./scripts/tools/tools.lua"
local tools = require("tools")

package.path = "./scripts/player/player.lua"
local player = require("player")

local stats = {
    sprite = love.graphics.newImage("images/characters/enemy/gunner.png"),
    gun = love.graphics.newImage("images/guns/pistol/gun.png"),
    bullet = "images/guns/pistol/bullet.png",
    health = 20
}


function  gunner.create(x, y)
    local info = {}
    info.health = stats.health
    info.sprite = stats.sprite
    info.gun = stats.gun
    info.bullet = stats.gun
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

function gunner.update()
    for i in pairs(gunners) do
        local angulo = guns.rotacionar(gunners[i].x, gunners[i].y, true)

        for x in pairs(collision.collisions.gunners) do
            if collision.collisions.gunners[x] == gunners[i].id then
                collision.collisions.gunners[x].xbox = gunners[i].x
                collision.collisions.gunners[x].ybox = gunners[i].y
                Co_id = x
            end
        end
        
        if gunners[i].health > 0 then
            love.graphics.draw(gunners[i].sprite, gunners[i].x, gunners[i].y, 0, 1, 1, gunners[i].sprite:getWidth()/2,  gunners[i].sprite:getHeight()/2)
            love.graphics.draw(gunners[i].gun, gunners[i].x + 20, gunners[i].y + 3, angulo, 1, 1, gunners[i].gun:getWidth()/2,  gunners[i].gun:getHeight()/2)
            
            love.graphics.print(gunners[i].health, gunners[i].x-3, gunners[i].y-30)
        else
            gunners[i].selfdestruct()
            table.remove(gunners, i)
        end
    end
end




return gunner