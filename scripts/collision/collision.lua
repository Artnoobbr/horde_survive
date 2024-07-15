local collision = {}

local collisions = {}


function collision.create(x, y, height, width)
    local info = {}
    info.x = x
    info.y = y
    info.height = height
    info.width = width
    
    table.insert(collisions, info)
end

function collision.update()
    for i, x in pairs(collisions) do
        love.graphics.rectangle("line", collisions[i].x-collisions[i].width/2, collisions[i].y-collisions[i].height/2, collisions[i].width-2, collisions[i].height)
    end
end


return collision