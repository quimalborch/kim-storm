fx_version 'bodacious'
game 'gta5'
developer 'kim111#2795'

client_scripts {
	'config.lua',
	'client/*.lua',
	'locale.lua',
    'Locales/*.lua'
}

server_scripts {
    '@mysql-async/lib/MySQL.lua',
	'server/*.lua',
	'config.lua',
	'locale.lua',
    'Locales/*.lua'
}