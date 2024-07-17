local collision = {}

collision.collisions = {}

package.path = "./scripts/tools/tools.lua"
local tools = require("tools")


function collision.create(x, y, height, width, r,g,b ,name, id, destroy)
    local info = {}
    info.x = x
    info.y = y
    info.height = height
    info.width = width
    info.name = name
    info.r = r
    info.g = g
    info.b = b
    info.id = id

    --Isso é para objectos que se destroem quando atigem algum alvo
    if destroy == true then
        info.hit = false
    end


    info.xbox = info.x-info.width/2
    info.ybox = info.y-info.height/2
    info.wbox = info.width-2
    info.hbox = info.height
    
    table.insert(collision.collisions, info)
end

function collision.update()
    for i in pairs(collision.collisions) do
        local collisions = collision.collisions
        love.graphics.setColor(collisions[i].r, collisions[i].g, collisions[i].b)
        love.graphics.rectangle("line", collisions[i].xbox, collisions[i].ybox, collisions[i].wbox, collisions[i].hbox)
        love.graphics.setColor(255,255,255)
    end
end

function collision.check(x1, y1, w1, h1, name2)
    
    for i in pairs(collision.collisions) do
        
        local collisions = collision.collisions
        local x2 = collisions[i].xbox
        local y2 = collisions[i].ybox
        local w2 = collisions[i].wbox
        local h2 = collisions[i].hbox

        if x1 + w1 >= x2 and x1 <= x2 + w2 and y1 + h1 >= y2 and y1 <= y2 + h2 and x1 ~= x2 then
            if collisions[i].name == name2 then
                print(name2.." Collision detected!")
                if collisions[i].hit ~= nil then
                    collisions[i].hit = true
                end
                return true
            else
                print("Collision detected")
            end
            
        end
    end
    return false
end

return collision