vows = require 'vows'
assert = require 'assert'
vector2d = require('../src/vector2d').vector2d

suite = vows.describe '2D vectors tests'
suite.addBatch
	'vector construction with no params':
		topic: new vector2d.Vector()
		'has x and y': (vector) ->
			assert.equal vector.x, 0
			assert.equal vector.y, 0
		'has angle': (vector) ->
			assert.isNaN vector.angle
	'identity vector construction':
		topic: new vector2d.Vector.identity()
		'has x 1 and y 0': (vector) ->
			assert.equal vector.x, 1
			assert.equal vector.y, 0
		'has 0 angle': (vector) ->
			assert.equal vector.angle, 0
	'vector construction with params':
		topic: new vector2d.Vector 2, 3
		'has x 2 and y 3': (vector) ->
			assert.equal vector.x, 2
			assert.equal vector.y, 3
		'has angle': (vector) ->
			assert.equal vector.angle, 0.982793723247329

suite.run()
