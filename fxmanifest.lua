-- Resource Metadata
fx_version 'cerulean'
games { 'rdr3' }

author 'GetParanoid'
description 'Warehouse Storage for RedEM'
version '1.0.0'

rdr3_warning 'I acknowledge that this is a prerelease build of RedM, and I am aware my resources *will* become incompatible once RedM ships.'

server_scripts {
    'wh_server.lua',
    '@mysql-async/lib/MySQL.lua',

}

client_scripts {
    'wh_client.lua',
    'polyzone-api.lua'
}
shared_script 'config.lua'
