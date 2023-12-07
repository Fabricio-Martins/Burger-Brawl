extends Node2D

var ketchup_scene = preload("res://Scenes/Scenario/Collectable/ketchup.tscn")
var mustard_scene = preload("res://Scenes/Scenario/Collectable/mustard.tscn")
var mayonnaise_scene = preload("res://Scenes/Scenario/Collectable/mayonnaise.tscn")

@onready var _camera: Camera2D

var spawn_ketchup_interval = 12
var spawn_mustard_interval = 20
var spawn_mayonnaise_interval = 32

var max_items = 12
var current_items = 0

var spawn_area
var heart_size = 16
@export var _character: Character

@onready var cameras = get_tree().get_nodes_in_group("Camera")

var _is_full_screen = false

func _ready():
	if cameras.size() > 0:
		_camera = cameras[0]
	else:
		print("Nenhum elemento no grupo 'Camera' encontrado.")
		
	var screen_size = get_viewport_rect().size
	
	spawn_area = Rect2(Vector2(0, 0), screen_size)
	
	$KetchupTimer.wait_time = spawn_ketchup_interval
	$KetchupTimer.start()
	
	$MustardTimer.wait_time = spawn_mustard_interval
	$MustardTimer.start()
	
	$MayonnaiseTimer.wait_time = spawn_mayonnaise_interval
	$MayonnaiseTimer.start()
	
	var characters = get_tree().get_nodes_in_group("Character")
	
	if characters.size() > 0:
		_character = characters[0]
		_character.double_damage.connect(_set_power_up_double_damage)
		_character.double_speed.connect(_set_power_up_more_speed)
		_character.less_damage.connect(_set_power_up_less_damage)
	else:
		print("Nenhum elemento no grupo 'Character' encontrado.")
		
	if OS.has_feature("mobile"):
		$CanvasLayer.ButtonFullscreen.visible = false
		
	_is_full_screen = (DisplayServer.window_get_mode() == DisplayServer.WINDOW_MODE_FULLSCREEN)
	
func _process(delta):
	if Input.is_action_pressed("open_pause"):
		get_tree().set_pause(true)  
		var pause_scene = preload("res://Scenes/Interface/pause_screen.tscn")
		var pause_instance = pause_scene.instantiate()  
		add_child(pause_instance)  

func _on_ketchup_timer_timeout():
	if current_items < max_items:
		var random_x
		var random_y

		while (random_x == null or random_y == null or random_x <= 52 or random_y >= 150 or random_y <= 40 or random_x >= 285):
			random_x = randf_range(spawn_area.position.x, spawn_area.position.x + spawn_area.size.x)
			random_y = randf_range(spawn_area.position.y, spawn_area.position.y + spawn_area.size.y)
		
		var ketchup_instance = ketchup_scene.instantiate()
		ketchup_instance.global_position = Vector2(random_x, random_y)
		add_child(ketchup_instance)
		
		$KetchupTimer.start()

		current_items += 1

func _on_mustard_timer_timeout():
	if current_items < max_items:
		var random_x
		var random_y
		
		while (random_x == null or random_y == null or random_x <= 52 or random_y >= 150 or random_y <= 40 or random_x >= 285):
			random_x = randf_range(spawn_area.position.x, spawn_area.position.x + spawn_area.size.x)
			random_y = randf_range(spawn_area.position.y, spawn_area.position.y + spawn_area.size.y)
		
		var mustard_instance = mustard_scene.instantiate()
		mustard_instance.global_position = Vector2(random_x, random_y)
		add_child(mustard_instance)
		
		$MustardTimer.start()
		
		current_items += 1
	
func _on_mayonnaise_timer_timeout():
	if current_items < max_items:
		var random_x
		var random_y
		
		while (random_x == null or random_y == null or random_x <= 52 or random_y >= 150 or random_y <= 40 or random_x >= 285):
			random_x = randf_range(spawn_area.position.x, spawn_area.position.x + spawn_area.size.x)
			random_y = randf_range(spawn_area.position.y, spawn_area.position.y + spawn_area.size.y)
		
		var mayonnaise_instance = mayonnaise_scene.instantiate()
		mayonnaise_instance.global_position = Vector2(random_x, random_y)
		add_child(mayonnaise_instance)
		
		$MayonnaiseTimer.start()
		
		current_items += 1
	
func _on_touch_screen_button_2_pressed() -> void:
	_character.manual_dash_enabled = true

func _on_player_life_changed(lives: int) -> void:
	$CanvasLayer/BackgroundPanel/Heart.set_size(Vector2(lives * heart_size, 0))
	if lives <= 0:
		$CanvasLayer/BackgroundPanel/Heart.visible = false

func _on_player_died() -> void:
	get_tree().set_pause(true)
	var game_over = preload("res://Scenes/Interface/game_over_screen.tscn")
	var game_over_instance = game_over.instantiate()  
	add_child(game_over_instance)  
	
func _set_power_up_double_damage():
	$CanvasLayer/powerup_double_damage.visible = not($CanvasLayer/powerup_double_damage.visible)
	
func _set_power_up_more_speed():
	$CanvasLayer/powerup_double_speed.visible = not($CanvasLayer/powerup_double_speed.visible)

func _set_power_up_less_damage():
	$CanvasLayer/powerup_less_damage.visible = not($CanvasLayer/powerup_less_damage.visible)

func _on_pressed() -> void:
	_toggle_fullscreen()

func _toggle_fullscreen() -> void:
	_is_full_screen = not _is_full_screen
	if _is_full_screen:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
