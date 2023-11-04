extends Node2D

var coin_scene = preload("res://Scenes/Scenario/Collectable/coin.tscn")
var spawn_interval = 1
var spawn_area = Rect2(Vector2(100, 100), Vector2(400, 400))

@export var _character: Character

func _ready():
	$Timer.wait_time = spawn_interval
	$Timer.start()
	
	var characters = get_tree().get_nodes_in_group("Character")
	
	if characters.size() > 0:
		_character = characters[0]
	else:
		print("Nenhum elemento no grupo 'Character' encontrado.")
	
func _process(delta):
	if Input.is_action_pressed("open_pause"):
		get_tree().set_pause(true)  
		var pause_scene = preload("res://Scenes/Interface/pause_screen.tscn")
		var pause_instance = pause_scene.instantiate()  
		add_child(pause_instance)  

func _on_timer_timeout():
	var random_x = randf_range(spawn_area.position.x, spawn_area.position.x + spawn_area.size.x)
	var random_y = randf_range(spawn_area.position.y, spawn_area.position.y + spawn_area.size.y)
	
	var coin_instance = coin_scene.instantiate()
	coin_instance.global_position = Vector2(random_x, random_y)
	add_child(coin_instance)
	
	$Timer.start()


func _on_touch_screen_button_2_pressed() -> void:
	_character.manual_dash_enabled = true
