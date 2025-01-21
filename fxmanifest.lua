fx_version 'cerulean'
game 'gta5'

author 'sm-scripts'
description 'QB-Core Hunting Script'
version '1.0.0'

shared_scripts {
    '@qb-core/shared/locale.lua',
    'config.lua',
    'locales/*.lua'
}

client_scripts {
    'client/*.lua'
}

server_scripts {
    'server/*.lua'
}