@asteroids = {} if not @asteroids
asteroids = @asteroids
asteroids.keyboard = {} if not asteroids.keyboard

keycodeListener = (value) ->
	(e) ->
		keycode = e.keyCode
		if @keycodes.hasOwnProperty keycode
			@status[keycode] = value
			e.preventDefault()
			e.stopPropation()
		undefined

class Keyboard
	constructor: () ->
		@keycodes = Keyboard.keycodes
		@inverseKeycodes = Keyboard.inverseKeycodes
		@listeners = {}
		@status = {}
	bind: () ->
		window.addEventListener 'keydown', @onKeyDown.bind(this), true
	addListener: (keycode, listener) ->
		throw new Error "Unrecognized keycode #{keycode}" if not @inverseKeycodes.hasOwnProperty keycode
		@listeners[keycode] = [] if not @listeners[keycode]
		@listeners[keycode].push listener
	onKeyDown: keycodeListener true
	onKeyUp: keycodeListener false
	runKeyListeners: (keycode, args) ->
		if @listeners[keycode]
			listener.apply null, args for listener in @listeners[keycode]
		undefined
	runListeners: (args...) ->
		for own name, keycode of @keycodes
			@runKeyListeners keycode, args if @status[keycode]
		undefined
Keyboard.keycodes =
	UP: 38
	DOWN: 40
	LEFT: 37
	RIGTH: 39
	FIRE: 32
inverse = (o) ->
    r = {}
	for own k, v of o
		r[v] = k
	r
Keyboard.inverseKeycodes = inverse(keycodes)

asteroids.keyboard.Keyboard = Keyboard
