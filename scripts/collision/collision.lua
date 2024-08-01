local collision = {}

collision.collisions = {
    player = {},
    paredes = {},
    dummys = {},
    bullets = {},
    gunners = {}
}


function collision.create(x, y, height, width, r,g,b ,name, id, destroy, place, damage, type)
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
    info.type = type
    

    --Isso é para objectos que se destroem quando atigem algum alvo
    if destroy == true then
        info.hit = false
    end

    if damage ~= nil then
        info.damage = damage
    end

    info.xbox = info.x-info.width/2
    info.ybox = info.y-info.height/2
    info.wbox = info.width-2
    info.hbox = info.height


    table.insert(place, info)
   
end


-- This is only to draw the image for debugging
function collision.update()
    for i in pairs(collision.collisions) do
        for x in pairs(collision.collisions[i]) do
            love.graphics.setColor(collision.collisions[i][x].r, collision.collisions[i][x].g, collision.collisions[i][x].b)
            love.graphics.rectangle("line", collision.collisions[i][x].xbox, collision.collisions[i][x].ybox, collision.collisions[i][x].wbox, collision.collisions[i][x].hbox)
            love.graphics.setColor(255,255,255)
        end
    end
end

-- The enemy here is to check if the collision should check for a enemy bullet
function collision.check(x1, y1, w1, h1, place, type)
    
    for i in pairs(place) do
        local x2 = place[i].xbox
        local y2 = place[i].ybox
        local w2 = place[i].wbox
        local h2 = place[i].hbox

        local id = i

        if x1 + w1 >= x2 and x1 <= x2 + w2 and y1 + h1 >= y2 and y1 <= y2 + h2 and x1 ~= x2 then
            
            if type ~= nil then
                if type == place[i].type then
                    place[i].hit = true
                    return {true, id}
                end
            else
                if place[i].hit ~= nil then
                    place[i].hit = true
                end
    
                return {true, id}
            end
            

        end
    end
    return false
end

function collision.ponto_retangulo(px, py, place)
    for i in pairs(place) do
        local rx = place[i].xbox
        local ry = place[i].ybox
        local rw = place[i].wbox
        local rh = place[i].hbox

        if px >= rx and px <= rx + rw and py >= ry and py <= ry + rh then
            return true
        end
    end
    return false
end

return collision