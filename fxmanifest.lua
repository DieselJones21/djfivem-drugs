fx_version 'cerulean'
game 'gta5'
lua54 'yes'

name 'djfivem-drugs'
author 'DieselJones21'
description 'Config-driven harvest → process → /trap sell drug economy'
version '1.0.0'

shared_scripts {
    '@ox_lib/init.lua',
    'shared/utils.lua',
    'config/config.lua',
    'config/drugs.lua',
}

client_scripts {
    'client/main.lua',
    'client/harvest.lua',
    'client/process.lua',
    'client/sell.lua',
}

server_scripts {
    'server/main.lua',
    'server/harvest.lua',
    'server/process.lua',
    'server/sell.lua',
}

dependencies {
    'ox_lib',
    'ox_target',
    'ox_inventory',
    'qb-core',
}