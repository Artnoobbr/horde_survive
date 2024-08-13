local loader = {}

-- Player Packages
local player = require "scripts.player.player"
local inventario = require("scripts.player.inventario")

local tools = require("scripts.tools.tools")

-- Enemy Packages

local dummy = require "scripts.enemy.dummy"

local gunner = require "scripts.enemy.gunner"


-- Map and Objects

local map = require("scripts.map.map")

local menu = require("scripts.menu.menu")


-- Guns Packages
local guns = require("scripts.guns.guns")


local pistol = require("scripts.guns.pistol")

local submachinegun = require("scripts.guns.submachinegun")

-- Collision

local collision = require("scripts.collision.collision")

local global = require("scripts.global")

function loader.load()
    if map.loaded == false then
        map.load()
    end

    if map.loaded == true and player.status.spawn == false then
        player.spawn(300, 500)
    end
end


function loader.checkupdate(dt)
    if tools.tablelength(collision.collisions.gunners) > 0 then
        gunner.update(dt)
    end
end

function loader.checkdraw()
    if tools.tablelength(collision.collisions.gunners) > 0 then
        gunner.draw()
    end
end



return loader 