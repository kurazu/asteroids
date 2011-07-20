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
		new Vector cos * @x - sin * @y, sin * @x + cos * @y
	distance: (other) ->
		dx = other.x - @x
		dy = other.y - @y
		Math.sqrt dx * dx + dy * dy
	toString: () ->
		"<Vector #{@x},#{@y}>"
	copy: () ->
		new Vector @x, @y
Vector.identity = () ->
	new Vector 1, 0

line_tester = (point1, point2, orientation) ->
	x1 = point1.x
	y1 = point1.y
	x2 = point2.x
	y2 = point2.y
	xo = orientation.x
	yo = orientation.y
	xdiff = x1 - x2
	if xdiff == 0
		if xo > x1
			(point) ->
				point.x >= x1
		else
			(point) ->
				point.x <= x1
	else
		a = (y1 - y2) / xdiff
		b = y1 - a * x1
		if a * xo + b < yo
			(point) ->
				a * point.x + b <= point.y
		else
			(point) ->
				a * point.x + b >= point.y

class Triangle
	constructor: (@a, @b, @c) ->
		@line_a = line_tester @a, @b, @c
		@line_b = line_tester @b, @c, @a
		@line_c = line_tester @c, @a, @b
	hasPoint: (point) ->
		@line_a(point) and @line_b(point) and @line_c(point)

@vector2d =
	Vector: Vector
	Triangle: Triangle
