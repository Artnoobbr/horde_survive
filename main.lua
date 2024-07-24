-- Variaveis globais usam maisculo no começo

-- Player Packages
package.path = "./scripts/player/player.lua"
local player = require("player")


-- Enemy Packages

package.path = "./scripts/enemy/dummy.lua"
local dummy = require("dummy")

package.path = "./scripts/enemy/gunner.lua"
local gunner = require("gunner")


-- Map and Objects

package.path = "./scripts/map/map.lua"
local map = require("map")


-- Guns Packages
package.path = "./scripts/guns/guns.lua"
local guns = require("guns")

package.path = "./scripts/guns/pistol.lua"
local pistol = require("pistol")

package.path = "./scripts/guns/submachinegun.lua"
local submachinegun = require("submachinegun")

package.path = "./scripts/guns/submachinegun.lua"

-- Collision

package.path = "./scripts/collision/collision.lua"
local collision = require("collision")


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

  player.update()
  guns.bulletupdate()

  if player.guns.pistol == true then
    pistol.update()
  end

  if player.guns.submachinegun == true then
    submachinegun.update()
  end

  dummy.load()
  gunner.update()
  collision.update()

  love.graphics.print("Fps: "..Fps, 10, 0)

  function love.keypressed(key, scancode, isrepeat)
    if key == '1' then
      if player.guns.pistol == false then
        player.guns.pistol = true
        player.guns.submachinegun = false
      end
    elseif key == '2' then
      if player.guns.submachinegun == false then
        player.guns.submachinegun = true
        player.guns.pistol = false
      end
    end
  end

end
