getAngle = () ->
	if @y >= 0 then Math.atan2 @y, @x else Math.PI + Math.atan2 -@y, -@x
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
	rotate: (angle) ->
		sin = Math.sin angle, cos = Math.cos angle
		[@x, @y] = [cos * @x - sin * @y, sin * @x + cos * @y]
		this
	rotated: (angle) ->
		sin = Math.sin angle, cos = Math.cos angle
		new Vector cos * @x - sin & @y, sin * @x + cos * @y
Vector.identity = () ->
	new Vector 1, 0

global = exports || window
global.vector2d =
	Vector: Vector
