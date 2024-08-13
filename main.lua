-- Variaveis globais usam maisculo no começo

-- Player Packages
local player = require "scripts.player.player"
local inventario = require("scripts.player.inventario")

-- Enemy Packages

local dummy = require "scripts.enemy.dummy"

local gunner = require "scripts.enemy.gunner"


-- Map and Objects

local map = require("scripts.map.map")

local menu = require("scripts.menu.menu")

local loader = require("scripts.map.loader")


-- Guns Packages
local guns = require("scripts.guns.guns")


local pistol = require("scripts.guns.pistol")

local submachinegun = require("scripts.guns.submachinegun")

-- Collision

local collision = require("scripts.collision.collision")

local global = require("scripts.global")


function love.update(dt)

  if menu.main_menu == true then
    menu.update()
  else
    loader.load()
    player.update(dt)
    inventario.hotbar()
    guns.bulletupdate(dt)
    dummy.update(dt)
    loader.checkupdate(dt)
    gunner.random_create()

    if inventario.guns.pistol.equipado == true then
      pistol.update(dt)
    elseif inventario.guns.submachinegun.equipado == true then
      submachinegun.update(dt)
    end
    Fps = love.timer.getFPS()
  end

end

function love.draw()
  --map should be the first always
  if menu.main_menu == true then
    menu.draw()
  else
    map.drawmap()
    map.test()
  
    love.graphics.print(guns.rotacionar(0,0,false,true)[1], 400, 30)
    player.draw()
  
    guns.bulletdraw()
  
    if inventario.guns.pistol.equipado == true then
      pistol.draw()
    elseif inventario.guns.submachinegun.equipado == true then
      submachinegun.draw()
    end
  
    dummy.draw()
    loader.checkdraw()
  
    love.graphics.print("Fps: "..Fps, 10, 0)
  end

  if global.debug == true then
    collision.draw()
  end

end
