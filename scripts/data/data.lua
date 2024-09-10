local data = {}

local json = require("lib.json-lua.json")
local base64 = require("lib.lbase64.base64")

local default_path = 'data/default.json'
local user_path = 'data/user.json'

local default = {
    versao = 0.4,
    config = {
        volume = 0.5
    },
    pontuacao = {
        ondas = 0,
        matou = 0
    }
}

function data.load()
    local user_file = io.open(user_path, "r")
    local user_content = ""

    if user_file == nil then
        local default_content = json.encode(default)

        user_file = io.open(user_path, "w")

        if user_file == nil then
            print('Não foi possível criar user.json')
        else
            user_file:write(default_content)
            user_file:close()
        end
        user_file = io.open(user_path, 'r')

        user_content = user_file:read("a")
        user_file:close()

        user_content = json.decode(user_content)
        data['user'] = user_content

    else
        user_content = user_file:read("a")
        user_file:close()

        user_content = base64.decode(user_content)

        user_content = json.decode(user_content)
        data['user'] = user_content
    end
end


function data.fileupdate()
    local user_file = io.open(user_path,"w")

    if user_file == nil then
        data.load()
    end 

    local data_content = json.encode(data['user'])

    data_content = base64.encode(data_content)
    
    user_file:write(data_content)
    user_file:close()

end

return data