fx_version 'cerulean'
game 'gta5'

author 'VGroup'
description 'Skrypt na ofce ktora wozi jedzenie'
version '1.0.0'
lua54 'yes'


client_scripts {
    'config.lua',
    '@ox_lib/init.lua',
	'client/*.lua'
} 

server_scripts {
    'config.lua',
    '@ox_lib/init.lua',
	'server/*.lua'
}