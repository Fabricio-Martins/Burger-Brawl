extends Node2D

func _ready():
	pass

func _process(delta):
	if Input.is_action_pressed("open_pause"):
		get_tree().set_pause(true)  
		var pause_scene = preload("res://pause_screen.tscn")
		var pause_instance = pause_scene.instantiate()  
		add_child(pause_instance)  
