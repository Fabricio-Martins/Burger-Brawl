extends CanvasLayer

func _ready():
	pass

func _process(delta):
	pass

func _on_resume_pressed():
	get_tree().set_pause(false)
	self.hide()
	queue_free()

func _on_quit_pressed():
	get_tree().set_pause(false)
	get_tree().change_scene_to_file("res://Scenes/Interface/start_screen.tscn")
	queue_free()
