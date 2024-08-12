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
  player.update(dt)
  inventario.hotbar()
  Fps = love.timer.getFPS()
  guns.bulletupdate(dt)
  dummy.update(dt)
  gunner.update(dt)


  if inventario.guns.pistol.equipado == true then
    pistol.update(dt)
  elseif inventario.guns.submachinegun.equipado == true then
    submachinegun.update(dt)
  end

end

dummy.create(600, 380)
dummy.create(600, 500)

gunner.create( 600, 300)
gunner.create(600, 200)

gunner.create(600, 100)


gunner.create(300, 200)

function love.load()
  map.load()
end

function love.draw()
  --map should be the first always
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
  gunner.draw()

  if global.debug == true then
    collision.draw()
  end


  love.graphics.print("Fps: "..Fps, 10, 0)

end
