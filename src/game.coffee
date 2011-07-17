@asteroids = {} if not @asteroids
asteroids = @asteroids
asteroids.controller = {} if not asteroids.controller

getTime = () ->
	new Date().getTime()
              
is_bullet = (shape) ->
	shape instanceof asteroids.controller.Bullet

is_asteroid = (shape) ->
	shape instanceof asteroids.controller.Asteroid

is_rocket = (shape) ->
	shape instanceof asteroids.controller.Rocket

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
			@fixPosition shape
		# collision detection
		for i in [0...@shapes.length]
			shape1 = @shapes[i]
			for j in [i...@shapes.length]
				shape2 = @shapes[j]
				if shape1.model.position.distance(shape2.model.position) < shape1.model.bb_radius + shape2.model.bb_radius
					@onCollision shape1, shape2
		@shapes = (shape for shape in @shapes when not shape.delete)
	onCollision: (shape1, shape2) ->
		if (is_bullet(shape1) and is_asteroid(shape2)) or (is_asteroid(shape1) and is_bullet(shape2))
			shape1.delete = true
			shape2.delete = true
	fixPosition: (shape) ->
		pos = shape.model.position
		bullet = is_bullet(shape)
		if pos.x < -Game.FIX_POSITION_MARGIN
			return @removeShape shape if bullet
			pos.x = 500 + Game.FIX_POSITION_MARGIN
		else if pos.x > 500 + Game.FIX_POSITION_MARGIN
			return @removeShape shape if bullet
			pos.x = -Game.FIX_POSITION_MARGIN
		if pos.y < -Game.FIX_POSITION_MARGIN
			return @removeShape shape if bullet
			pos.y = 500 + Game.FIX_POSITION_MARGIN
		else if pos.y > 500 + Game.FIX_POSITION_MARGIN
			return @removeShape shape if bullet
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
