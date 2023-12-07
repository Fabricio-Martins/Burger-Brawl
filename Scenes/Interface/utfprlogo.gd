extends Control


func _ready():
	$AnimationPlayer.play("new_animation")
	await get_tree().create_timer(3).timeout
	get_tree().change_scene_to_file("res://Scenes/Interface/start_screen.tscn")	

func _process(delta):
	pass
