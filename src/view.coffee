@asteroids = {} if not @asteroids
asteroids = @asteroids
asteroids.view = {} if not asteroids.view

getTime = () -> +new Date
                      
class Space
	constructor: () ->
	init: () ->
		@fps = 0
		@frames = 0
		@prev_time = getTime()
		canvas = document.createElement 'canvas'
		canvas.width = Space.DEFAULT_WIDTH
		canvas.height = Space.DEFAULT_WIDTH
		document.body.insertBefore canvas, document.body.firstChild
		@canvas = canvas
		@ctx = canvas.getContext('2d')
	draw: (shapes) ->
		time = getTime()
		if time - @prev_time > 1000
			@fps = (time - @prev_time) / @frames
			@prev_time = time
			@frames = 0
		@frames++
		@ctx.save()
		@ctx.fillStyle = 'black'
		@ctx.fillRect 0, 0, Space.DEFAULT_WIDTH, Space.DEFAULT_HEIGHT
		@ctx.beginPath()
		@ctx.fillStyle = 'white'
		@ctx.font = 'bold 12px Verdana'
		@ctx.fillText "#{@fps.toFixed(1)} FPS", 2, 10
		@ctx.fill()
		@ctx.restore()
		shape.draw @ctx for shape in shapes
		for shape in shapes
			@ctx.save()
			@ctx.strokeStyle = 'yellow'
			vertices = shape.getPhysicalVertices()
			first = true
			@ctx.beginPath()
			for vertex in vertices
				if first
					@ctx.moveTo vertex.x, 500 - vertex.y
					first = false
				else
					@ctx.lineTo vertex.x, 500 - vertex.y
			@ctx.closePath()
			@ctx.stroke()
			@ctx.restore()
Space.DEFAULT_WIDTH = 500
Space.DEFAULT_HEIGHT = 500

Drawer = (vertices, strokeStyle='white', after=1) ->
	previous = []
	(ctx, model) ->
		previous.push
			x: model.position.x
			y: model.position.y
			angle: model.getViewAngle()
		previous.shift() if previous.length > after
		j = 0
		for pos in previous
			ctx.save()
			ctx.translate pos.x, 500 - pos.y
			ctx.rotate -pos.angle
			ctx.beginPath()
			ctx.strokeStyle = strokeStyle
			ctx.globalAlpha = (j + 1) / after
			ctx.arc 0, 0, model.bb_radius, 0, Math.PI * 2, false
			ctx.closePath()
			ctx.stroke()
			ctx.beginPath()
			i = 0
			for vertice in vertices
				if not i++
					ctx.moveTo vertice.x, -vertice.y
				else
					ctx.lineTo vertice.x, -vertice.y
			ctx.closePath()
			ctx.stroke()
			ctx.restore()
			j++

asteroids.view.Space = Space
asteroids.view.Drawer = Drawer
