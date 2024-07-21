fx_version "bodacious"
games {"gta5"}
lua54 'yes'
description 'VS_FIBJOB'

version '1.2.0'

server_scripts {
	'@mysql-async/lib/MySQL.lua',
	'@es_extended/locale.lua',
	'config.lua',
	'server/main.lua',

}

client_scripts {
	'@es_extended/locale.lua',
	'config.lua',
	'client/main.lua',
}

dependencies {
	'es_extended',
}


shared_script '@ox_lib/init.lua'
shared_script '@es_extended/imports.lua'








