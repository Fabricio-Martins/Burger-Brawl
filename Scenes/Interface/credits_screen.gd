extends Control

var _is_full_screen = false

func _ready():
	_is_full_screen = (DisplayServer.window_get_mode() == DisplayServer.WINDOW_MODE_FULLSCREEN)

func _on_pressed() -> void:
	SelectSfx.play()
	_toggle_fullscreen()

func _toggle_fullscreen() -> void:
	_is_full_screen = not _is_full_screen
	if _is_full_screen:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
