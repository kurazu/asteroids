@asteroids = {} if not @asteroids
asteroids = @asteroids
asteroids.controller = {} if not asteroids.controller

V = (x, y) ->
	new vector2d.Vector x, y

ROCKET_VERTICES = [
	V 2, 0
	V -2, 2
	V -1, 0
	V -2, -2
]

with_scale = (func) ->
	(timediff) ->
		scale = timediff / 1000
		func.call this, scale

class Shape
	constructor: () ->
		@vertices = (vertice.scaled @scale for vertice in @vertices)
		@drawer = asteroids.view.Drawer @vertices, @style
	draw: (ctx) ->
		@drawer ctx, @model
	move: (timediff) ->
		scale = timediff / 1000
		@model.rotationAngle += scale * @model.rotation
		@model.position.add vector2d.Vector.identity().scale(scale * @model.velocity).rotate(@model.angle)

class Rocket extends Shape
	vertices: ROCKET_VERTICES
	scale: 5.0
	style: 'green'
	max_velocity: 500
	acceleration: 400
	deceleration: 600
	steering: Math.PI * 3
	constructor: () ->
		@model = new asteroids.model.Shape 250, 250, 0, 0, 0
		super()
		Keyboard = asteroids.keyboard.Keyboard
		@keyboard = new Keyboard()
		@keyboard.addListener Keyboard.UP, @onAccelerate.bind this
		@keyboard.addListener Keyboard.DOWN, @onBrake.bind this
		@keyboard.addListener Keyboard.LEFT, @onLeft.bind this
		@keyboard.addListener Keyboard.RIGHT, @onRight.bind this
		@keyboard.addListener Keyboard.FIRE, @onFire.bind this
		@keyboard.bind()
	onAccelerate: with_scale (scale) ->
		@model.velocity += @acceleration * scale
		@model.velocity = @max_velocity if @model.velocity > @max_velocity
	onBrake: with_scale (scale) ->
		@model.velocity -= @deceleration * scale
		@model.velocity = 0 if @model.velocity < 0
	onLeft: with_scale (scale) ->
		@model.angle += @steering * scale
	onRight: with_scale (scale) ->
		@model.angle -= @steering * scale
	onFire: (time) ->
		console.log 'fire'
	move: (timediff) ->
		@keyboard.runListeners timediff
		super timediff

rand = (from, to) ->
	Math.random() * (to - from) + from

randVertices = (number) ->
	degStep = Math.PI * 2 / number
	result = [vector2d.Vector.identity()]
	for i in [1..number]
		result.push vector2d.Vector.identity().scale(rand 0.2, 2).rotate(degStep * i)

	result

class Asteroid extends Shape
	style: 'red'
	max_velocity: 50,
	constructor: () ->
		@model = new asteroids.model.Shape rand(0, 500), rand(0, 500), rand(0.1, @max_velocity), rand(0.1, @max_velocity), rand(Math.PI / 8, Math.PI) * (if rand(0, 1) >= 0.5 then  1 else -1)
		@scale = rand 10, 20
		@vertices = randVertices 8
		super()

asteroids.controller.Rocket = Rocket
asteroids.controller.Asteroid = Asteroid
