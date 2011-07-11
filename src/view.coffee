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

Space.DEFAULT_WIDTH = 500
Space.DEFAULT_HEIGHT = 500

asteroids.view.Space = Space
