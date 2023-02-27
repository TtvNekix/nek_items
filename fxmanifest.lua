fx_version 'cerulean'
game 'gta5'
lua54 'yes'

author 'Nekix'
description 'Script to be able to have items in hand and be able to use them through a function.'

shared_scripts { 
    '@es_extended/imports.lua',
    'shared/*.lua'
}

client_scripts {
    'client/*.lua'
}

server_script {
    '@oxmysql/lib/MySQL.lua',
    'server/*.lua'
}

escrow_ignore {
    'shared/config.lua'
}

exports {
    'checkItem'
}