fx_version 'cerulean'
game 'gta5'
lua54 'yes'

name 'djfivem-drugs'
author 'DieselJones21'
description 'Config-driven harvest → process → /trap sell drug economy (QBX + ox_inventory)'
version '1.7.0'

shared_scripts {
    '@ox_lib/init.lua',
    'shared/utils.lua',
    'shared/bridge.lua',
    'config/config.lua',
    'config/drugs.lua',
}

client_scripts {
    'client/main.lua',
    'client/harvest.lua',
    'client/process.lua',
    'client/sell.lua',
    'client/progress.lua',
    'client/effects.lua',
    'client/boost.lua',
}

server_scripts {
    'server/main.lua',
    'server/harvest.lua',
    'server/process.lua',
    'server/progress.lua',
    'server/sell.lua',
    'server/effects.lua',
    'server/boost.lua',
}

dependencies {
    'ox_lib',
    'ox_target',
    'ox_inventory',
    'qbx_core',
}