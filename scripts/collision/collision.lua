local collision = {}

collision.collisions = {}


function collision.create(x, y, height, width, r,g,b ,name, id)
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


        if collisions[i].name == name2 then
            print("found bullet")
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