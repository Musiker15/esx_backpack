fx_version 'adamant'
games { 'gta5' }

author 'Musiker15 - MSK Scripts'
name 'MSK Backpack'
description 'MSK Backpack Plugin for Chezza Inventory'
version '2.5'

shared_scripts {
	'@es_extended/locale.lua',
	'locales/*.lua',
	'config.lua'
}

client_scripts {
	'client.lua'
}

server_scripts {
	'@mysql-async/lib/MySQL.lua',
	'server.lua'
}

dependencies {
	'es_extended'
}