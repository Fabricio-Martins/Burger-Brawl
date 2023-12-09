extends CanvasLayer

func _on_reset_pressed() -> void:
	get_tree().set_pause(false)
	get_tree().change_scene_to_file("res://Scenes/Levels/world.tscn")
	queue_free()

func _on_menu_pressed() -> void:
	get_tree().set_pause(false)
	get_tree().change_scene_to_file("res://Scenes/Interface/start_screen.tscn")
	queue_free()
