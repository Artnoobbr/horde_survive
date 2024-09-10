local menu = {}

local collision = require("scripts.collision.collision")

local tools = require("scripts.tools.tools")

local simple_slider = require("lib.simple-slider.simple-slider")

local data = require("scripts.data.data")

menu.main_menu = true

local mouse = {
    x = 0,
    y = 0
}

local width = love.graphics.getWidth()
local height = love.graphics.getHeight()

local monogram = love.graphics.newFont("fonts/monogram/ttf/monogram.ttf", 50)

local pontuacao = {
    ondas = 0,
    inimigos_mortos = 0
 }

menu.menu_loc = "principal"
menu.pausado = false
menu.slider = false

local textos = {
    principal = {
        titulo = {
            texto = love.graphics.newText(monogram, "Horde Survive"),
            x = width/2,
            y = 120,
            nome = "titulo"
        },
        jogar = {
            texto = love.graphics.newText(monogram, "Jogar"),
            x = width/2,
            y = 220,
            nome = "jogar",
            acao = function ()
                menu.deletar_texto()
                menu.deletar_mouse()
                menu.main_menu = false
            end
        },
        configuracoes = {
            texto = love.graphics.newText(monogram, "Configuracoes"),
            x = width/2,
            y = 320,
            nome = "configuracoes",
            acao = function ()
                menu.menu_loc = "configuracoes"
                carregar()
            end
        },
        creditos = {
            texto = love.graphics.newText(monogram, "Creditos"),
            x = width/2,
            y = 420,
            nome = "creditos",
            acao = function ()
                menu.menu_loc = "creditos"
                carregar()
            end
        },
        sair = {
            texto = love.graphics.newText(monogram, "Sair"),
            x = width/2,
            y = 520,
            nome = "sair",
            acao = function ()
                love.event.quit()
            end
        }
    },
    creditos = {
        cainos = {
            texto = love.graphics.newText(monogram, "Pixel Art Top Down Basic by Cainos"),
            x = width/2,
            y = 200,
            nome = 'cainos'
        },
        monogram = {
            texto = love.graphics.newText(monogram, "Monogram font by datagoblin"),
            x = width/2,
            y = 150,
            nome = 'monogram'
        },
        protagonist = {
            texto = love.graphics.newText(monogram, "Pixel Protagonist by Penzilla"),
            x = width/2,
            y = 100,
            nome = 'protagonist'
        },
        gun_pack = {
            texto = love.graphics.newText(monogram, "Pixel Art Assets 7 by Greenpixels"),
            x = width/2,
            y = 250,
            nome = 'gun_pack'
        },
        voltar = {
            texto = love.graphics.newText(monogram, "Voltar"),
            x = width/2,
            y = 550,
            nome = 'voltar',
            acao = function ()
                menu.menu_loc = "principal"
                carregar()
            end
        }

    },
    configuracoes = {
        volume = {
            texto = love.graphics.newText(monogram, "Volume Musica"),
            x = width/2,
            y = 250,
            slider = newSlider(width/2, 300, 200, data['user']['config']['volume'], 0, 1, function(v) data['user']['config']['volume'] = v end)
        },
        voltar = {
            texto = love.graphics.newText(monogram, "Voltar"),
            x = width/2,
            y = 550,
            nome = 'voltar',
            acao = function ()
                if menu.pausado == false then
                    menu.menu_loc = "principal"
                    data.fileupdate()
                    carregar()
                else
                    menu.menu_loc = 'pause'
                    data.fileupdate()
                    carregar()
                end
            end
        }
    },
    pause = {
        sair = {
            texto = love.graphics.newText(monogram, "Sair"),
            x = width/2,
            y = 420,
            nome = "sair",
            acao = function ()
                love.event.quit()
            end
        },
        resumir = {
            texto = love.graphics.newText(monogram, "Resumir"),
            x = width/2,
            y = 220,
            nome = "resumir",
            acao = function ()
                menu.pausado = false
            end
        },
        menu = {
            texto = love.graphics.newText(monogram, "menu"),
            x = width/2,
            y = 320,
            nome = "menu",
            acao = function ()
                menu.pausado = false
                menu.main_menu = true
                menu.menu_loc = 'principal'
                collision.reset()
                menu.criar_mouse()
                carregar()
            end
        },
        configuracoes = {
            texto = love.graphics.newText(monogram, "Configuracoes"),
            x = width/2,
            y = 520,
            nome = "configuracoes",
            acao = function ()
                menu.menu_loc = 'configuracoes'
                carregar()
            end
        },
    },
    morto = {
        pontuacao = {
            texto = love.graphics.newText(monogram, "Voce sobreviveu a "..pontuacao.ondas.. " ondas" ),
            x = width/2,
            y = 220,
            nome = "pontuacao",
        },
        menu = {
            texto = love.graphics.newText(monogram, "menu"),
            x = width/2,
            y = 320,
            nome = "menu",
            acao = function()
                menu.pausado = false
                menu.main_menu = true
                menu.menu_loc = 'principal'
                collision.reset()
                menu.criar_mouse()
                carregar()
            end
        },
        sair = {
            texto = love.graphics.newText(monogram, "Sair do jogo"),
            x = width/2,
            y = 420,
            nome = "sair",
            acao = function ()
                love.event.quit()
            end
        }
    }
}

local text_loc = textos.principal

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


local function adicionar_texto(localizacao)
    for i in pairs(localizacao) do
        if localizacao[i].texto ~= nil then
           collision.create(localizacao[i].x, localizacao[i].y, localizacao[i].texto:getHeight(), localizacao[i].texto:getWidth(), 255, 255, 255, localizacao[i].nome, 0, false, collision.collisions.textos) 
        end
    end
end


function carregar()
    menu.deletar_texto()
    menu.slider = false

    if menu.pausado == false then
        if menu.menu_loc == "principal" then
            adicionar_texto(textos.principal)
            text_loc = textos.principal
        elseif menu.menu_loc == "creditos" then
            adicionar_texto(textos.creditos)
            text_loc = textos.creditos
        elseif menu.menu_loc == "configuracoes" then
            adicionar_texto(textos.configuracoes)
            text_loc = textos.configuracoes
            menu.slider = true
        end
    else
        if menu.menu_loc == 'pause' then
            adicionar_texto(textos.pause)
            text_loc = textos.pause
        elseif menu.menu_loc == 'configuracoes' then
            adicionar_texto(textos.configuracoes)
            text_loc = textos.configuracoes
            menu.slider = true
        end
    end

end

function menu.draw()
    local height = love.graphics.getHeight()
    love.graphics.setBackgroundColor(0, 0,255)

    
    for i in pairs(text_loc) do
        -- Renderizar o textos
        if text_loc[i].texto ~= nil then
            love.graphics.draw(text_loc[i].texto, text_loc[i].x, text_loc[i].y, 0, 1, 1, text_loc[i].texto:getWidth()/2, text_loc[i].texto:getHeight()/2)
        end

        -- Renderizar os sliders
        if text_loc[i].slider ~= nil then
            text_loc[i].slider:draw()
        end
    end


end

function menu.update()
    collision.collisions.mouse[1].xbox = love.mouse.getX()
    collision.collisions.mouse[1].ybox = love.mouse.getY()

    function love.mousepressed(x, y, button, istouch)
        if button == 1 and (menu.main_menu == true or menu.pausado == true) then          
            if collision.check(collision.collisions.mouse[1].xbox, collision.collisions.mouse[1].ybox, collision.collisions.mouse[1].wbox, collision.collisions.mouse[1].hbox, collision.collisions.textos) then
                local id = collision.check(collision.collisions.mouse[1].xbox, collision.collisions.mouse[1].ybox, collision.collisions.mouse[1].wbox, collision.collisions.mouse[1].hbox, collision.collisions.textos)[2]
                local name = collision.collisions.textos[id].name
                if text_loc[name]['acao'] ~= nil then
                    text_loc[name]['acao']()
                end
                
            end
        end
    end

    if menu.slider == true then
        for i in pairs(text_loc) do
            if text_loc[i].slider ~= nil then
                text_loc[i].slider:update()
                --print(text_loc[i].slider:getValue())
            end
        end

    end

end

function menu.pause(type, ondas, mortos)
    if menu.pausado == true and type == 'esc' then
        love.graphics.setBackgroundColor(0, 0, 255)
        menu.criar_mouse()
        carregar()
        menu.update()
    
    elseif menu.pausado == true and type == 'player' then
        love.graphics.setBackgroundColor(0, 0, 255)
        menu.criar_mouse()
        adicionar_texto(textos.morto)
        text_loc = textos.morto
        pontuacao.ondas = ondas
        pontuacao.inimigos_mortos = mortos
        if ondas < 2 then
            textos.morto.pontuacao.texto = love.graphics.newText(monogram, "Voce sobreviveu a "..pontuacao.ondas.. " onda" )
        else
            textos.morto.pontuacao.texto = love.graphics.newText(monogram, "Voce sobreviveu a "..pontuacao.ondas.. " ondas" )
        end
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