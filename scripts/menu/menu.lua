local menu = {}

local collision = require("scripts.collision.collision")

menu.main_menu = true

local monogram = love.graphics.newFont("fonts/monogram/ttf/monogram.ttf", 50)

local tools = require("scripts.tools.tools")

local width = love.graphics.getWidth()

local mouse = {
    x = 0,
    y = 0
}

local textos = {
    principal = {
        jogar = {
            texto = love.graphics.newText(monogram, "Jogar"),
            x = width/2,
            y = 200,
            nome = "jogar"
        },
        sair = {
            texto = love.graphics.newText(monogram, "Sair"),
            x = width/2,
            y = 300,
            nome = "sair"
        }
    }
}

local menu_loc = "principal"

collision.create(mouse.x, mouse.y, 5, 5, 255, 255, 255, "mouse", 0, false, collision.collisions.mouse)

local function delete_text()
    for i in pairs(collision.collisions.textos) do

        -- Quando for remover tudo de uma lista usar o nil
        -- Pois se usar o table.remove algum elemento fica de fora
        -- já que no instante que o item é deletado a ordem muda
        -- ou seja o que tava no [5] vai pro [4] então o i não pega
        
        collision.collisions.textos[i] = nil
    end
end


local function acao_btn(name)
    if name == "sair" then
        love.event.quit()
    elseif name == "jogar" then
        delete_text()
        table.remove(collision.collisions.mouse, 1)
        menu.main_menu = false
    end
end


local function carregar()
    if menu_loc == "principal" then
        for i in pairs(textos.principal) do
            collision.create(textos.principal[i].x, textos.principal[i].y, textos.principal[i].texto:getHeight(), textos.principal[i].texto:getWidth(), 255, 255, 255, textos.principal[i].nome, 0, false, collision.collisions.textos)
            print("adicionnado "..i)
        end
    end
end

function menu.draw()
    local height = love.graphics.getHeight()

    love.graphics.draw (textos.principal.jogar.texto, textos.principal.jogar.x, textos.principal.jogar.y, 0, 1, 1, textos.principal.jogar.texto:getWidth()/2, textos.principal.jogar.texto:getHeight()/2)
    love.graphics.draw (textos.principal.sair.texto, textos.principal.sair.x, textos.principal.sair.y, 0, 1, 1, textos.principal.sair.texto:getWidth()/2, textos.principal.sair.texto:getHeight()/2)
end

function menu.update()
    collision.collisions.mouse[1].xbox = love.mouse.getX()
    collision.collisions.mouse[1].ybox = love.mouse.getY()

    function love.mousepressed(x, y, button, istouch)
        if button == 1 and menu.main_menu == true then            
            if collision.check(collision.collisions.mouse[1].xbox, collision.collisions.mouse[1].ybox, collision.collisions.mouse[1].wbox, collision.collisions.mouse[1].hbox, collision.collisions.textos) then
                local id = collision.check(collision.collisions.mouse[1].xbox, collision.collisions.mouse[1].ybox, collision.collisions.mouse[1].wbox, collision.collisions.mouse[1].hbox, collision.collisions.textos)[2]
                acao_btn(collision.collisions.textos[id].name)
            end
        end
    end
end

if tools.tablelength(collision.collisions.textos) <= 0 and menu.main_menu == true then
    carregar()
end



return menu