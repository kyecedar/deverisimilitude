extends Node
class_name Game


enum MOUSE_MODE {
	RELEASED,
	PLAYER,
	CUTSCENE,
}


static var paused : bool = false
static var mouse_mode : MOUSE_MODE = MOUSE_MODE.PLAYER


static func test():
	pass


static func set_mouse_mode(mode: MOUSE_MODE) -> void:
	match mode:
		MOUSE_MODE.RELEASED:
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		MOUSE_MODE.PLAYER:
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
		MOUSE_MODE.CUTSCENE:
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

static func set_window_focus(focused: bool) -> void:
	if focused:
		pass

func _ready() -> void:
	unpause()

func _unhandled_input(event: InputEvent):
	if Input.is_action_just_pressed("pause"):
		if game.paused:
			unpause()
		else:
			pause()

func _notification(what: int) -> void:
	match what:
		NOTIFICATION_APPLICATION_FOCUS_IN:
			print("focus")
		NOTIFICATION_APPLICATION_FOCUS_OUT:
			print("unfocus")
			pause()


func pause() -> void:
	game.paused = true
	set_mouse_mode(MOUSE_MODE.RELEASED)

func unpause() -> void:
	game.paused = false
	set_mouse_mode(mouse_mode)
