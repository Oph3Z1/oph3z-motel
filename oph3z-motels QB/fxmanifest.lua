fx_version 'cerulean'
game 'gta5'

description 'FiveM motel script made by Oph3Z & Yusuf'
discord 'https://discord.gg/Pnq5R4HszK'
author 'oph3z & yusufkaracolak'

client_scripts {
    'client/*.lua',
}

server_scripts {
    '@oxmysql/lib/MySQL.lua',
    'server/*.lua',
}

shared_scripts { 
    'config/config.lua',
    'config/config_langue.lua',
    'config/lang.lua',
    'config/config_motels.lua'
}

ui_page {
    'html/index.html'
}

files {
    'html/style.css',
    'html/index.html',
    'html/script.js',
    'html/img/*.png',
    'html/img/*.svg',
    'html/img/*.gif'
}
lua54 "yes"