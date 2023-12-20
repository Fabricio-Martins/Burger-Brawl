extends Control

var _is_full_screen = false

func _ready():
	_is_full_screen = (DisplayServer.window_get_mode() == DisplayServer.WINDOW_MODE_FULLSCREEN)


func _on_quitBtn_pressed():
	SelectSfx.play()
	get_tree().quit()

func _on_control_btn_pressed():
	SelectSfx.play()
	get_tree().change_scene_to_file("res://Scenes/Interface/control_screen.tscn")

func _on_control_btn_play():
	MenuTheme.stop()
	$JogarSFX.play()
	await get_tree().create_timer(0.5).timeout
	get_tree().change_scene_to_file("res://Scenes/Levels/world.tscn")

func _on_credits_btn_pressed():
	SelectSfx.play()
	get_tree().change_scene_to_file("res://Scenes/Interface/credits_screen.tscn")	
	
func _on_pressed() -> void:
	SelectSfx.play()
	_toggle_fullscreen()

func _toggle_fullscreen() -> void:
	_is_full_screen = not _is_full_screen
	if _is_full_screen:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
