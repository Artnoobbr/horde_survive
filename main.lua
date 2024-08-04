-- Variaveis globais usam maisculo no começo

-- Player Packages
local player = require "scripts.player.player"
local inventario = require("scripts.player.inventario")

-- Enemy Packages

local dummy = require "scripts.enemy.dummy"

local gunner = require "scripts.enemy.gunner"


-- Map and Objects

local map = require("scripts.map.map")


-- Guns Packages
local guns = require("scripts.guns.guns")


local pistol = require("scripts.guns.pistol")

local submachinegun = require("scripts.guns.submachinegun")

-- Collision

local collision = require("scripts.collision.collision")

local global = require("scripts.global")


function love.update(dt)
  player.basic_moviment()
  Fps = love.timer.getFPS()
end

dummy.create(600, 380)
dummy.create(600, 500)

gunner.create( 600, 300)

function love.load()
  map.update()
end

function love.draw()
  --map should be the first always
  map.drawmap()
  map.test()

  love.graphics.print(guns.rotacionar(0,0,false,true)[1], 400, 30)
  player.update()
  inventario.hotbar()

  guns.bulletupdate()

  if inventario.guns.pistol.equipado == true then
    pistol.update()
  elseif inventario.guns.submachinegun.equipado == true then
    submachinegun.update()
  end


  dummy.load()
  gunner.update()

  if global.debug == true then
    collision.update()
  end
  

  love.graphics.print("Fps: "..Fps, 10, 0)

end
