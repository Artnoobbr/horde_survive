local collision = {}

local collisions = {}


function collision.create(x, y, height, width, name)
    local info = {}
    info.x = x
    info.y = y
    info.height = height
    info.width = width
    info.name = name

    info.xbox = info.x-info.width/2
    info.ybox = info.y-info.height/2
    info.wbox = info.width-2
    info.hbox = info.height
    
    table.insert(collisions, info)
end

function collision.update()
    for i in pairs(collisions) do
        love.graphics.rectangle("line", collisions[i].xbox, collisions[i].ybox, collisions[i].wbox, collisions[i].hbox)
    end
end

function collision.check(x1, y1, w1, h1, name2)
    
    for i, x in pairs(collisions) do
        local x2 = collisions[i].xbox
        local y2 = collisions[i].ybox
        local w2 = collisions[i].wbox
        local h2 = collisions[i].hbox


        if collisions[i].name == name2 then
            if x1 + w1 >= x2 and x1 <= x2 + w2 and y1 + h1 >= y2 and y1 <= y2 + h2 then
                print("Hit!")
                return true
            else
                return false
            end
        else
            return false
        end
    end
end


return collision