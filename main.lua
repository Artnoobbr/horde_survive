-- Variaveis globais usam maisculo no começo

-- Player Packages
local player = require "scripts.player.player"
local inventario = require("scripts.player.inventario")
local teclado = require("scripts.player.teclado")
local mouse = require("scripts.player.mouse")

local tools      = require("scripts.tools.tools")

-- Enemy Packages

local dummy = require "scripts.enemy.dummy"

local gunner = require "scripts.enemy.gunner"

local ondas = require("scripts.map.ondas")


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

local width = love.graphics.getWidth()
local height = love.graphics.getHeight()

love.window.setTitle("Horde Survive")
local background_music = love.audio.newSource("sounds/background/rose_at_nightfall.mp3", "stream")
background_music:setVolume(0.2)
local background_music2 = love.audio.newSource("sounds/background/Daniel_Bautista_Opening_Theme_(Music_for_a Film_).mp3", "stream")
background_music2:setVolume(0.2)

local ignore = false

function love.update(dt)
  mouse.update()
  if menu.main_menu == true then
      menu.update()
      map.active = false
      player.status.spawn = false
      ondas.reset()
      map.unload()
      guns.unload()
      gunner.unload()
      player.reset()
      inventario.reset()
      love.audio.stop()
  end

  if map.loaded == false and menu.main_menu == false then
      map.load()
  end

  if map.active == true then
      map.collision_bullets()

      if player.status.morto == true then
        menu.pause('player', ondas.score.ondas_sobrevividas, ondas.score.inimigos_mortos)
      else
        menu.pause('esc', 0, 0)
      end
      
      teclado.update()
      if player.status.spawn == false then
          player.spawn(width/2, height/2)
      end

      if menu.pausado == true then
        background_music:pause()
        background_music2:pause()
      end

      if menu.pausado == false then

        if tools.tablelength(collision.collisions.gunners) > 0 then
          gunner.update(dt)
        end


        if not background_music:isPlaying() and not background_music2:isPlaying() then
          local random = math.random(1, 2)

          if random == 1 then
            background_music:play()
          else
            background_music2:play()
          end
          --background_music:play()
          --background_music:setLooping(true)
        end
        
        gunner.spawn_update()
        guns.bullet_update(dt)
        guns.particle_update()
        player.update(dt)
        ondas.update(dt)

        if player.status.spawn == true and player.status.morto == false then
          if inventario.guns.pistol.equipado == true then
            pistol.update(dt)
          elseif inventario.guns.submachinegun.equipado == true then
            submachinegun.update(dt)
          end
        end
      end
  end

end


function love.draw()
    
  if menu.main_menu == true then
      menu.draw()
  end

  if map.loaded == true and menu.main_menu == false then
      map.drawmap()
  end


  if map.active == true then
      guns.particle_draw()
      player.draw()
      inventario.draw()

      if menu.pausado == true then
        menu.draw()
      end

      if tools.tablelength(collision.collisions.gunners) > 0 then
        gunner.draw()
      end

      gunner.spanw_draw()
      
      if player.status.spawn == true and player.status.morto == false then
        if inventario.guns.pistol.equipado == true then
          pistol.draw()
        elseif inventario.guns.submachinegun.equipado == true then
          submachinegun.draw()
        end
      end
      
      ondas.draw()
      guns.bullet_draw()
  end

  if global.debug == true then
    collision.draw()
  end

end