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
			assert.equal vector.angle, Math.atan 3 / 2
	'vector length':
		topic: new vector2d.Vector 3, 4
		'has length 5': (vector) ->
			assert.equal vector.length, 5
	'scale':
		topic: () ->
			vector = new vector2d.Vector 3, 4
			scale = vector.scale 3
			[vector, scale]
		'is the same object': ([vector, scale]) ->
			assert.strictEqual vector, scale
		'has correct length': ([vector, scale]) ->
			assert.equal vector.x, 9
			assert.equal vector.y, 12
			assert.equal vector.length, 15
		'has correct angle': ([vector, scale]) ->
			assert.equal vector.angle, Math.atan 4 / 3
	'scaled':
		topic: () ->
			vector = new vector2d.Vector 3, 4
			scaled = vector.scaled 2
			[vector, scaled]
		'is not the same object': ([vector, scaled]) ->
			assert.notStrictEqual vector, scaled
		'has different props': ([vector, scaled]) ->
			assert.equal vector.x, 3
			assert.equal vector.y, 4
			assert.equal scaled.x, 6
			assert.equal scaled.y, 8
		'has correct length': ([vector, scaled]) ->
			assert.equal vector.length, 5
			assert.equal scaled.length, 10
		'has correct angle': ([vector, scaled]) ->
			assert.equal vector.angle, Math.atan 4 / 3
			assert.equal scaled.angle, Math.atan 4 / 3
	'add':
		topic: () ->
			vector = new vector2d.Vector 3, 4
			operand = new vector2d.Vector 2, 2
			add = vector.add(operand)
			[vector, add]
		'is the same object': ([vector, add]) ->
			assert.strictEqual vector, add
		'has correct props': ([vector, add]) ->
			assert.equal vector.x, 5
			assert.equal vector.y, 6
		'has correct length': ([vector, add]) ->
			assert.equal vector.length, Math.sqrt 5 * 5 + 6 * 6
		'has correct angle': ([vector, add]) ->
			assert.equal vector.angle, Math.atan 6 / 5
	'added':
		topic: () ->
			vector = new vector2d.Vector 3, 4
			operand = new vector2d.Vector 1, 2
			added = vector.added(operand)
			[vector, added]
		'is not the same object': ([vector, added]) ->
			assert.notStrictEqual vector, added
		'has correct props': ([vector, added]) ->
			assert.equal vector.x, 3
			assert.equal vector.y, 4
			assert.equal added.x, 4
			assert.equal added.y, 6
		'has correct length': ([vector, added]) ->
			assert.equal vector.length, 5
			assert.equal added.length, Math.sqrt 4 * 4 + 6 * 6
		'has correct angle': ([vector, added]) ->
			assert.equal vector.angle, Math.atan 4 / 3
			assert.equal added.angle, Math.atan 3 / 2
	'substract':
		topic: () ->
			vector = new vector2d.Vector 3, 4
			operand = new vector2d.Vector 1, 2
			substract = vector.substract operand
			[vector, substract]
		'is the same object': ([vector, substract]) ->
			assert.strictEqual vector, substract
		'has correct props': ([vector, substract]) ->
			assert.equal vector.x, 2
			assert.equal vector.y, 2
		'has correct length': ([vector, substract]) ->
			assert.equal vector.length, 2 * Math.sqrt 2
		'has correct angle': ([vector, substract]) ->
			assert.equal vector.angle, Math.PI / 4

suite.run()
