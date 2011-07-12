@asteroids = {} if not @asteroids
asteroids = @asteroids
asteroids.view = {} if not asteroids.view

class Space
	constructor: () ->
	init: () ->
		canvas = document.createElement 'canvas'
		canvas.width = Space.DEFAULT_WIDTH
		canvas.height = Space.DEFAULT_WIDTH
		document.body.insertBefore canvas, document.body.firstChild
		@canvas = canvas
		@ctx = canvas.getContext('2d')
	draw: (shapes) ->
		@ctx.save()
		@ctx.fillStyle = 'black'
		@ctx.fillRect 0, 0, Space.DEFAULT_WIDTH, Space.DEFAULT_HEIGHT
		@ctx.restore()
		shape.draw @ctx for shape in shapes
Space.DEFAULT_WIDTH = 500
Space.DEFAULT_HEIGHT = 500

Drawer = (vertices, strokeStyle='white') ->
	(ctx, model) ->
		position = model.position
		angle = model.getViewAngle()
		ctx.save()
		ctx.translate position.x, position.y
		ctx.rotate angle
		ctx.beginPath()
		ctx.strokeStyle = strokeStyle
		i = 0
		for vertice in vertices
			if not i++
				ctx.moveTo vertice.x, vertice.y
			else
				ctx.lineTo vertice.x, vertice.y
		ctx.closePath()
		ctx.stroke()
		ctx.restore()

asteroids.view.Space = Space
asteroids.view.Drawer = Drawer
