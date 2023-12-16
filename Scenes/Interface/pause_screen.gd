extends CanvasLayer

var _is_full_screen = false

@onready var _fs_button: Button
@onready var fullscreenButtons = get_tree().get_nodes_in_group("WorldButton")

func _ready():
	_is_full_screen = (DisplayServer.window_get_mode() == DisplayServer.WINDOW_MODE_FULLSCREEN)
	
	if OS.has_feature("mobile"):
		visible = false
		
	if fullscreenButtons.size() > 0:
		_fs_button = fullscreenButtons[0]
		
func _on_resume_pressed():
	_unpause()

func _on_quit_pressed():
	get_tree().set_pause(false)
	get_tree().change_scene_to_file("res://Scenes/Interface/start_screen.tscn")
	queue_free()
	MenuTheme.play()

func _toggle_fullscreen() -> void:
	_is_full_screen = not _is_full_screen
	if _is_full_screen:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)

func _unpause() -> void:
	_fs_button.visible = true	
	get_tree().set_pause(false)
	self.hide()
	queue_free()
