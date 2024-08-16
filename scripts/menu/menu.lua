local menu = {}

local collision = require("scripts.collision.collision")

menu.main_menu = true

local monogram = love.graphics.newFont("fonts/monogram/ttf/monogram.ttf", 50)

local tools = require("scripts.tools.tools")

local width = love.graphics.getWidth()
local height = love.graphics.getHeight()

local mouse = {
    x = 0,
    y = 0
}

local textos = {
    principal = {
        titulo = {
            texto = love.graphics.newText(monogram, "Luagame"),
            x = width/2,
            y = 120,
            nome = "titulo"
        },
        jogar = {
            texto = love.graphics.newText(monogram, "Jogar"),
            x = width/2,
            y = 220,
            nome = "jogar"
        },
        sair = {
            texto = love.graphics.newText(monogram, "Sair"),
            x = width/2,
            y = 420,
            nome = "sair"
        },
        creditos = {
            texto = love.graphics.newText(monogram, "Creditos"),
            x = width/2,
            y = 320,
            nome = "creditos"
        }
    },
    creditos = {
        lorem = {
            texto = love.graphics.newText(monogram, "Lorem ipsum dolor sit amet "),
            x = width/2,
            y = height/2,
            nome = 'lorem'
        },

        voltar = {
            texto = love.graphics.newText(monogram, "Voltar"),
            x = width/2,
            y = 550,
            nome = 'voltar'
        }

    },
    pause = {
        sair = {
            texto = love.graphics.newText(monogram, "Sair"),
            x = width/2,
            y = 420,
            nome = "sair"
        },
        resumir = {
            texto = love.graphics.newText(monogram, "Resumir"),
            x = width/2,
            y = 220,
            nome = "resumir"
        },
        menu = {
            texto = love.graphics.newText(monogram, "menu"),
            x = width/2,
            y = 320,
            nome = "menu"
        },
    }
}

local menu_loc = "principal"
local text_loc = textos.principal
menu.pausado = false



function menu.criar_mouse()
    collision.create(mouse.x, mouse.y, 5, 5, 255, 255, 255, "mouse", 0, false, collision.collisions.mouse)
end

function menu.deletar_mouse()
    table.remove(collision.collisions.mouse, 1)
end

menu.criar_mouse()

function menu.deletar_texto()
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
        menu.deletar_texto()
        menu.deletar_mouse()
        menu.main_menu = false
    elseif name == "creditos" then
        menu_loc = "creditos"
        carregar()
    elseif name == "voltar" then
        menu_loc = "principal"
        carregar()
    elseif name == "resumir" then
        menu.pausado = false
    elseif name == "menu" then
        menu.pausado = false
        menu.main_menu = true
        collision.reset()
        menu.criar_mouse()
        carregar()
    end
end


local function adicionar_texto(localizacao)
    for i in pairs(localizacao) do
        collision.create(localizacao[i].x, localizacao[i].y, localizacao[i].texto:getHeight(), localizacao[i].texto:getWidth(), 255, 255, 255, localizacao[i].nome, 0, false, collision.collisions.textos)
    end
end


function carregar()
    menu.deletar_texto()
    if menu_loc == "principal" then
        adicionar_texto(textos.principal)
        text_loc = textos.principal
    elseif menu_loc == "creditos" then
        adicionar_texto(textos.creditos)
        text_loc = textos.creditos
    end
end

function menu.draw()
    local height = love.graphics.getHeight()
    love.graphics.setBackgroundColor(0, 0, 255)

    for i in pairs(text_loc) do
        love.graphics.draw(text_loc[i].texto, text_loc[i].x, text_loc[i].y, 0, 1, 1, text_loc[i].texto:getWidth()/2, text_loc[i].texto:getHeight()/2)
    end
end

function menu.update()
    collision.collisions.mouse[1].xbox = love.mouse.getX()
    collision.collisions.mouse[1].ybox = love.mouse.getY()

    function love.mousepressed(x, y, button, istouch)
        if button == 1 and (menu.main_menu == true or menu.pausado == true) then          
            if collision.check(collision.collisions.mouse[1].xbox, collision.collisions.mouse[1].ybox, collision.collisions.mouse[1].wbox, collision.collisions.mouse[1].hbox, collision.collisions.textos) then
                local id = collision.check(collision.collisions.mouse[1].xbox, collision.collisions.mouse[1].ybox, collision.collisions.mouse[1].wbox, collision.collisions.mouse[1].hbox, collision.collisions.textos)[2]
                acao_btn(collision.collisions.textos[id].name)
            end
        end
    end
end

function menu.pause()
    if menu.pausado == true then
        menu.criar_mouse()
        adicionar_texto(textos.pause)
        text_loc = textos.pause
        menu.update()
    else
        menu.deletar_mouse()
        menu.deletar_texto()
    end
end

if tools.tablelength(collision.collisions.textos) <= 0 and menu.main_menu == true then
    carregar()
end



return menu