@asteroids = {} if not @asteroids
asteroids = @asteroids
asteroids.controller = {} if not asteroids.controller

getTime = () ->
	new Date().getTime()

class Game
	constructor: () ->
		@view = new asteroids.view.Space()
		@frames = 0
		@prevtime = @time = getTime()
		@shapes = []
	run: () ->
		console.log 'run'
		@determineFrameMethod()
		@view.init()
		@gameInit()
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
	gameInit: () ->
		@shapes.push new asteroids.controller.Rocket()
		@shapes.push new asteroids.controller.Asteroid() for i in [0..5]
	move: (timediff) ->
		shape.move timediff for shape in @shapes
	onFrame: () ->
		time = getTime()
		timediff = time - @prevtime
		@frames++
		if time - @time > 1000
			#console.log "FPS #{@frames}"
			@time = time
			@frames = 0
		@move timediff
		@prevtime = time
		@view.draw @shapes
		@requestFrame()
		
asteroids.controller.Game = Game
