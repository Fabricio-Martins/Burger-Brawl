extends CanvasLayer

func _ready():
	pass

func _process(delta):
	pass

func _on_resume_pressed():
	get_tree().set_pause(false)
	self.hide()

func _on_quit_pressed():
	get_tree().set_pause(false)
	get_tree().change_scene_to_file("res://start_screen.tscn")
