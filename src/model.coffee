@asteroids = {} if not @asteroids
asteroids = @asteroids
asteroids.model = {} if not asteroids.model

class Shape
	constructor: (x, y, @angle=0, @velocity=0, @rotation=0) ->
		@position = new vector2d.Vector x, y
		@rotationAngle = 0
	getViewAngle: () ->
		@angle + @rotationAngle

asteroids.model.Shape = Shape
