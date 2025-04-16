SHELL = /bin/bash

server:
	@bunx vite

server-host:
	@bunx vite --host

game-build:
	godot3 --help
	#godot3 --export "HTML5" ../assets/game.html