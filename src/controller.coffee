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

BULLET_VERTICES = [
	V -2, -2
	V 1, -2
	V 3, 0
	V 1, 2
	V -2, 2
]

with_scale = (func) ->
	(timediff) ->
		scale = timediff / 1000
		func.call this, scale

class Shape
	visual_trails: 1
	constructor: () ->
		@vertices = (vertex.scaled @scale for vertex in @vertices)
		@initBB()
		@drawer = asteroids.view.Drawer @vertices, @style, @visual_trails
	initBB: () ->
		@model.bb_radius = 0
		center = new vector2d.Vector 0, 0
		for vertex in @vertices
			len = center.distance vertex
			@model.bb_radius = len if len > @model.bb_radius
		undefined
	bind: (addShapeCallback, removeShapeCallback) ->
		@addShape = addShapeCallback.bind null
		@removeShape = removeShapeCallback.bind null
	draw: (ctx) ->
		@drawer ctx, @model
	move: (timediff) ->
		scale = timediff / 1000
		@model.rotationAngle += scale * @model.rotation
		@model.position.add @model.velocity_vector.scaled scale
	getPhysicalVertices: () ->
		(@model.position.added vertex.rotated(@model.getViewAngle()) for vertex in @vertices)

class Bullet extends Shape
	vertices: BULLET_VERTICES
	scale: 1.0
	style: 'blue'
	velocity: 400
	constructor: (x, y, angle) ->
		@model = new asteroids.model.Shape x, y, angle, @velocity, 0
		super()

class Rocket extends Shape
	visual_trails: 5
	vertices: ROCKET_VERTICES
	scale: 5.0
	style: 'green'
	max_velocity: 300
	acceleration: 200
	steering: Math.PI * 2
	shoot_timeout: 400
	constructor: () ->
		@model = new asteroids.model.Shape 250, 250, 0, 0, 0
		super()
		Keyboard = asteroids.keyboard.Keyboard
		@keyboard = new Keyboard()
		@keyboard.addListener Keyboard.UP, @onAccelerate.bind this
		#@keyboard.addListener Keyboard.DOWN, @onBrake.bind this
		@keyboard.addListener Keyboard.LEFT, @onLeft.bind this
		@keyboard.addListener Keyboard.RIGHT, @onRight.bind this
		@keyboard.addListener Keyboard.FIRE, @onFire.bind this
		@keyboard.bind()
		@can_shoot = true
	onAccelerate: with_scale (scale) ->
		force_vector = vector2d.Vector.identity().rotate(@model.angle).scale(scale * @acceleration)
		@model.velocity_vector.add force_vector
		length = @model.velocity_vector.length
		@model.velocity_vector.scale @max_velocity / length if length > @max_velocity
	onLeft: with_scale (scale) ->
		@model.angle += @steering * scale
	onRight: with_scale (scale) ->
		@model.angle -= @steering * scale
	onFire: (time) ->
		if @can_shoot
			position = @model.position.added vector2d.Vector.identity().scale(15.0).rotate(@model.angle) # draw before the rocket
			bullet = new Bullet position.x, position.y, @model.angle
			@addShape bullet
			@can_shoot = false
			setTimeout () =>
				@can_shoot = true
			, @shoot_timeout
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

# put asteroids at screen edges in the beginning
randAsteroidPosition = () ->
	edge = ~~rand(0, 4)
	position = rand(0, 500)
	switch edge
		when 0 then [0, position]
		when 1 then [500, position]
		when 2 then [position, 0]
		when 3 then [position, 500]
		else [0, 0]

class Asteroid extends Shape
	visual_trails: 7
	style: 'red'
	min_velocity: 10
	max_velocity: 50
	max_generation: 4
	constructor: (parent=null) ->
		if not parent
			@init()
		else
			@initFrom parent
		super()
	init: () ->
		@generation = 2
		[x, y] = randAsteroidPosition()
		@model = new asteroids.model.Shape x, y, rand(0, Math.PI * 2), rand(@min_velocity, @max_velocity), rand(Math.PI / 8, Math.PI) * (if rand(0, 1) >= 0.5 then  1 else -1)
		@scale = rand 10, 20
		@vertices = randVertices 8
	initFrom: (parent) ->
		@generation = parent.generation + 1
		@model = Object.create parent.model
		@model.position = Object.create parent.model.position
		@model.rotation = rand(Math.PI / 8, Math.PI) * (if rand(0, 1) >= 0.5 then  1 else -1) 
		@model.velocity_vector = Object.create parent.model.velocity_vector
		@scale = 0.75
		@vertices = parent.vertices
    
	# split into smaller asteroids
	split: () ->
		if @generation > @max_generation
			return # no more splitting
		for i in [0...@generation]
			split = new Asteroid this
			split.model.velocity_vector.rotate (i + 1) / @generation * Math.PI * 2 + Math.PI / 2
			@addShape split
		undefined

asteroids.controller.Rocket = Rocket
asteroids.controller.Asteroid = Asteroid
asteroids.controller.Bullet = Bullet
