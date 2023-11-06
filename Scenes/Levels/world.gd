extends Node2D

var coin_scene = preload("res://Scenes/Scenario/Collectable/coin.tscn")

var spawn_interval = 5
var spawn_area
var heart_size = 16
@export var _character: Character

func _ready():
	var screen_size = get_viewport_rect().size
	
	spawn_area = Rect2(Vector2(0, 0), screen_size)
	
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
	var random_x
	var random_y
	
	while (random_x == null or random_y == null or random_x <= 52 or random_y >= 150 or random_y <= 40 or random_x >= 285):
		random_x = randf_range(spawn_area.position.x, spawn_area.position.x + spawn_area.size.x)
		random_y = randf_range(spawn_area.position.y, spawn_area.position.y + spawn_area.size.y)
	
	var coin_instance = coin_scene.instantiate()
	print(random_x, " ", random_y)
	coin_instance.global_position = Vector2(random_x, random_y)
	add_child(coin_instance)
	
	$Timer.start()

func _on_touch_screen_button_2_pressed() -> void:
	_character.manual_dash_enabled = true

func _on_player_life_changed(lives: int) -> void:
	$CanvasLayer2/BackgroundPanel/Heart.set_size(Vector2(lives * heart_size, 0))
	if lives <= 0:
		$CanvasLayer2/BackgroundPanel/Heart.visible = false

func _on_player_died() -> void:
	get_tree().set_pause(true)
	var game_over = preload("res://Scenes/Interface/game_over_screen.tscn")
	var game_over_instance = game_over.instantiate()  
	add_child(game_over_instance)  
