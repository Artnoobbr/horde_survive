local tools = {}

function tools.tablelength(table)
    local counter = 0
    
    for i in pairs(table) do
        counter = counter + 1
    end

    return counter
end

local random = math.random
function tools.uuid()
    local template ='xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx'
    return string.gsub(template, '[xy]', function (c)
        local v = (c == 'x') and random(0, 0xf) or random(8, 0xb)
        return string.format('%x', v)
    end)
end


return tools