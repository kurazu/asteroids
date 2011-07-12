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

asteroids.controller.Rocket = Rocket
