getAngle = () ->
	Math.atan @y / @x
getLength = () ->
	Math.sqrt @x * @x + @y * @y
angleDescriptor = get: getAngle
lengthDescriptor = get: getLength
class Vector
	constructor: (@x=0, @y=0) ->
		Object.defineProperty this, 'angle', angleDescriptor
		Object.defineProperty this, 'length', lengthDescriptor
	add: (other) ->
		@x += other.x
		@y += other.y
		this
	added: (other) ->
		new Vector @x + other.x, @y + other.y
	substract: (other) ->
		@x -= other.x
		@y -= other.y
		this
	substracted: (other) ->
		new Vector @x - other.x, @y - other.y
	scale: (factor) ->
		@x *= factor
		@y *= factor
		this
	scaled: (factor) ->
		new Vector @x * factor, @y * factor
Vector.identity = () ->
	new Vector 1, 0

global = exports || window
global.vector2d =
	Vector: Vector