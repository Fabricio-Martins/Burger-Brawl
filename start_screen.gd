extends Control


func _ready():
	pass 


func _process(delta):
	pass

func _on_quitBtn_pressed():
	get_tree().quit()

func _on_control_btn_pressed():
	get_tree().change_scene_to_file("res://control_screen.tscn")

func _on_control_btn_play():
	get_tree().change_scene_to_file("res://world.tscn")	
