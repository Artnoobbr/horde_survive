local sound = {}

local tools = require("scripts.tools.tools")

local menu = require("scripts.menu.menu")
local data = require("scripts.data.data")

sound.info = {
    playing_background = false,
    music_path = sound.background,
    volume = data['user']['config']['volume'], -- 50% menor do volume original
    pausado = false
}

sound.background = {
    rose_at_nightfall =  {
        sound = love.audio.newSource("sounds/background/rose_at_nightfall.mp3", "stream"),
        name = 'rose_at_nightfall'
    },
    daniel_bautista_opening_theme = {
        sound = love.audio.newSource("sounds/background/Daniel_Bautista_Opening_Theme_(Music_for_a Film_).mp3", "stream"),
        name = 'daniel_bautista_opening_theme'
    },
    monastery_in_disguise = {
        sound = love.audio.newSource("sounds/background/Ragnarok_Online_-_Monastery_in_Disguise_(Cursed Abbey).mp3", "stream"),
        name = "monastery_in_disguise"
    }
}

-- Create a list of keys
local keys = {}
for key in pairs(sound.background) do
    table.insert(keys, key)
end


-- TODO: Verificar se as músicas estão realmente mudando!
-- Testar isso colocando aúdios curtos para checar

function sound.update(dt)
    sound.info.volume = data['user']['config']['volume']
    if sound.info.playing_background == false then
        local index_random = math.random(1, tools.tablelength(sound.background))
        local key = keys[index_random]

        sound.info.music_path = sound.background[key].sound
        sound.background[key].sound:setVolume(sound.info.volume)
        sound.background[key].sound:play()
        sound.info.playing_background = true
    elseif sound.info.playing_background == true and sound.info.pausado == false then
        sound.info.music_path:setVolume(sound.info.volume)
        if sound.info.music_path:isPlaying() == false then
            sound.info.playing_background = false
            --print("falso")
        end
    end

    if menu.pausado == true then
        sound.info.music_path:pause()
        sound.info.pausado = true
    elseif sound.info.music_path:isPlaying() == false and sound.info.playing_background == true then
        sound.info.music_path:play()
        --print("despause")
        sound.info.pausado = false
    end
end


function sound.reset()
    sound.info.music_path = nil
    sound.info.playing_background = false
    love.audio.stop()
    sound.info.pausado = false
end


return sound