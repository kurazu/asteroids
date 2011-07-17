@asteroids = {} if not @asteroids
asteroids = @asteroids
asteroids.keyboard = {} if not asteroids.keyboard

keycodeListener = (value) ->
	(e) ->
		keycode = e.keyCode
		keyname = INVERSE_KEYCODES[keycode]
		if keyname
			@status[keyname] = value
			e.preventDefault()
			e.stopPropagation()
		undefined

class Keyboard
	constructor: () ->
		# key_name -> [listener1, listener2, ...]
		@listeners = {}
		# key_name -> boolean
		@status = {}
	bind: () ->
		window.addEventListener 'keydown', @onKeyDown.bind(this), true
		window.addEventListener 'keyup', @onKeyUp.bind(this), true
	addListener: (keyname, listener) ->
		throw new Error "Unrecognized key name #{keyname}" if not KEYCODES.hasOwnProperty keyname
		@listeners[keyname] = [] if not @listeners[keyname]
		@listeners[keyname].push listener
	onKeyDown: keycodeListener true
	onKeyUp: keycodeListener false
	runKeyListeners: (keyname, args) ->
		if @listeners[keyname]
			listener.apply null, args for listener in @listeners[keyname]
		undefined
	runListeners: (args...) ->
		for own keyname of KEYCODES
			@runKeyListeners keyname, args if @status[keyname]
		undefined

KEYCODES =
	UP: 38
	DOWN: 40
	LEFT: 37
	RIGHT: 39
	FIRE: 32
INVERSE_KEYCODES = {}
INVERSE_KEYCODES[v] = k for own k, v of KEYCODES

Keyboard[name] = name for own name of KEYCODES

asteroids.keyboard.Keyboard = Keyboard
