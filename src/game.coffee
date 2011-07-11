@asteroids = {} if not @asteroids
asteroids = @asteroids
asteroids.controller = {} if not asteroids.controller

getTime = () ->
	new Date().getTime()

class Game
	constructor: () ->
		@view = new asteroids.view.Space()
		@frames = 0
		@time = getTime()
	run: () ->
		console.log 'run'
		@determineFrameMethod()
		@view.init()
		# start loop
		@requestFrame()
	determineFrameMethod: () ->
		onFrame = @onFrame.bind this
		if window.webkitRequestAnimationFrame
			console.log "Will use webkit animation frame"
			@requestFrame = () ->
				window.webkitRequestAnimationFrame onFrame
		else if window.mozRequestAnimationFrame
			console.log "Will use mozilla animation frame"
			@requestFrame = () ->
				window.mozRequestAnimationFrame onFrame
		else
			console.log "Will use setTimeout"
			@requestFrame = () ->
				window.setTimeout onFrame, 16
	onFrame: () ->
		time = getTime()
		@frames++
		if time - @time > 1000
			console.log "FPS #{@frames}"
			@time = time
			@frames = 0
		@requestFrame()
		
asteroids.controller.Game = Game
