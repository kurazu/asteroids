@asteroids = {} if not @asteroids

class Game
	constructor: () ->
	run: () ->
		console.log 'run'
		
asteroids.Game = Game
