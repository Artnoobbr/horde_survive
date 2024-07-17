-- Variaveis globais usam maisculo no começo

package.path = "./scripts/player.lua"
local player = require("player")

package.path = "./scripts/pistol.lua"
local pistol = require("pistol")

package.path = "./scripts/guns.lua"
local guns = require("guns")

package.path = "./scripts/map/map.lua"
local map = require("map")

package.path = "./scripts/enemy/dummy.lua"
local dummy = require("dummy")

package.path = "./scripts/collision/collision.lua"
local collision = require("collision")

function love.update(dt)
  player.basic_moviment()
end


dummy.create(600, 380)
dummy.create(600, 500)

function love.load()
  map.update()
  
end

function love.draw()
  --map should be the first always
  map.drawmap()

  player.update()
  pistol.update()  
  guns.bulletupdate()

  dummy.load()
  collision.update()
end
