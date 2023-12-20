extends Button

func _on_pressed():
	SelectSfx.play()
	get_tree().change_scene_to_file("res://Scenes/Interface/start_screen.tscn")
