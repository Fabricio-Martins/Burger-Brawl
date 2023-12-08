extends Control

var _is_full_screen = false

func _ready():
	pass 

func _process(delta):
	pass

func _on_quitBtn_pressed():
	get_tree().quit()

func _on_control_btn_pressed():
	get_tree().change_scene_to_file("res://Scenes/Interface/control_screen.tscn")

func _on_control_btn_play():
	get_tree().change_scene_to_file("res://Scenes/Levels/world.tscn")	

func _on_credits_btn_pressed():
	get_tree().change_scene_to_file("res://Scenes/Levels/credits_screen.tscn")	
