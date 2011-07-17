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

class Shape
	constructor: () ->
		@vertices = (vertice.scaled @scale for vertice in @vertices)
		@drawer = asteroids.view.Drawer @vertices, @style
	bind: () ->
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
	constructor: () ->
		@model = new asteroids.model.Shape 250, 250, 0, 0, Math.PI / 4
		super()
		@keyboard = new asteroids.keyboard.Keyboard()
		@keyboard.addListener @keyboard.keycodes.UP, @onAccelerate.bind this
		@keyboard.addListener @keyboard.keycodes.DOWN, @onBrake.bind this
		@keyboard.addListener @keyboard.keycodes.LEFT, @onLeft.bind this
		@keyboard.addListener @keyboard.keycodes.RIGHT, @onRight.bind this
		@keyboard.addListener @keyboard.keycodes.FIRE, @onFire.bind this
	bind: () ->
		@keyboard.bind()
	onAccelerate: (time) ->
		console.log 'up'
	onBrake: (time) ->
		console.log 'down'
	onLeft: (time) ->
		console.log 'left'
	onRight: (time) ->
		console.log 'right'
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
	constructor: () ->
		@model = new asteroids.model.Shape rand(0, 500), rand(0, 500), 0, 0, rand(Math.PI / 8, Math.PI) * (if rand(0, 1) >= 0.5 then  1 else -1)
		@scale = rand 5, 30
		@vertices = randVertices 8
		super()

asteroids.controller.Rocket = Rocket
asteroids.controller.Asteroid = Asteroid
