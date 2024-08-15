-- Variaveis globais usam maisculo no começo

-- Player Packages
local player = require "scripts.player.player"
local inventario = require("scripts.player.inventario")
local tools      = require("scripts.tools.tools")

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
  end

  if map.loaded == false and menu.main_menu == false then
      map.load()
  end

  if map.active == true then
      map.collision_bullets()
      if player.status.spawn == false then
          player.spawn(500, 500)
      elseif player.status.spawn == true then
        inventario.hotbar()
        if inventario.guns.pistol.equipado == true then
          pistol.update(dt)
        elseif inventario.guns.submachinegun.equipado == true then
          submachinegun.update(dt)
        end
      end

      


      gunner.update(dt)

      guns.bulletupdate(dt)
      gunner.random_create()
      
      player.update(dt)
  end

end


function love.draw()
    
  if menu.main_menu == true then
      menu.draw()
  end

  if map.loaded == true then
      map.drawmap()
  end

  if map.active == true then
      player.draw()

    
      gunner.draw()
      if player.status.spawn == true then
        if inventario.guns.pistol.equipado == true then
          pistol.draw()
        elseif inventario.guns.submachinegun.equipado == true then
          submachinegun.draw()
        end
      end
      

      guns.bulletdraw()
  end

  if global.debug == true then
    collision.draw()
  end

end