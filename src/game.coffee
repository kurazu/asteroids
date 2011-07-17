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
		shape.bind @addShape.bind(this), @removeShape.bind(this) for shape in @shapes
		undefined
	addShape: (shape) ->
		@shapes.push shape
	removeShape: (shape) ->
		@shapes = (s for s in @shapes when shape != s)
	move: (timediff) ->
		for shape in @shapes
			shape.move timediff
			@fixPostion shape
	fixPostion: (shape) ->
		pos = shape.model.position
		is_bullet = shape instanceof asteroids.controller.Bullet
		if pos.x < -Game.FIX_POSITION_MARGIN
			return @removeShape shape if is_bullet
			pos.x = 500 + Game.FIX_POSITION_MARGIN
		else if pos.x > 500 + Game.FIX_POSITION_MARGIN
			return @removeShape shape if is_bullet
			pos.x = -Game.FIX_POSITION_MARGIN
		if pos.y < -Game.FIX_POSITION_MARGIN
			return @removeShape shape if is_bullet
			pos.y = 500 + Game.FIX_POSITION_MARGIN
		else if pos.y > 500 + Game.FIX_POSITION_MARGIN
			return @removeShape shape if is_bullet
			pos.y = Game.FIX_POSITION_MARGIN
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
Game.FIX_POSITION_MARGIN = 20
		
asteroids.controller.Game = Game
