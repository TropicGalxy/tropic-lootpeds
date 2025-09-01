fx_version 'cerulean'
game 'gta5'

lua54 'yes'
author 'TropicGalxy'
description 'ped loot'
version '1.0'

shared_script 'config.lua'

server_scripts {
    'server.lua',
}

client_scripts {
    '@ox_lib/init.lua', 
    'client.lua'
}

