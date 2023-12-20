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
@export var freeze_slow := 0.07
@export var freeze_time := 0.3
@export var _character: Character
@export var _exported_final_level: int = 6

@onready var cameras = get_tree().get_nodes_in_group("Camera")

var _is_full_screen = false
var y_position = 0


func _ready():
	Events.connect("enemy_hit", freeze_engine)
	Events.hamburger_state = 0
	Events.current_level = 1
	Events.final_level = _exported_final_level
	if cameras.size() > 0:
		_camera = cameras[0]
		print(_camera.global_position)
		_camera.custom_room_entered.connect(_change_room)
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
		$CanvasLayer/ButtonFullscreen.visible = false
		
	_is_full_screen = (DisplayServer.window_get_mode() == DisplayServer.WINDOW_MODE_FULLSCREEN)

func _change_room():
	Events.current_level += 1
	max_items = 12

func _process(_delta):
	$CanvasLayer/HamburgerPanel/HamburgerSprite.set_frame(Events.hamburger_state)
	if Input.is_action_pressed("open_pause"):
		$CanvasLayer/ButtonFullscreen.visible = false
		get_tree().set_pause(true)  
		var pause_scene = preload("res://Scenes/Interface/pause_screen.tscn")
		var pause_instance = pause_scene.instantiate()  
		add_child(pause_instance) 

	#if cameras.size() > 0:
	#	_camera = cameras[0]
	#	print(_camera.global_position)

func _on_ketchup_timer_timeout():
	if current_items < max_items:
		var random_x
		var random_y
		
		print("ketchup")
		
		while (random_x == null or random_y == null or random_x <= 52 or random_y >= 150 + _camera.global_position.y or random_y <= 40 + _camera.global_position.y or random_x >= 285):
			random_x = randf_range(spawn_area.position.x, spawn_area.position.x + spawn_area.size.x)
			random_y = randf_range(spawn_area.position.y + _camera.global_position.y, spawn_area.position.y + spawn_area.size.y + _camera.global_position.y)			
				
		var ketchup_instance = ketchup_scene.instantiate()
		ketchup_instance.global_position = Vector2(random_x, random_y)
		add_child(ketchup_instance)
		
		$KetchupTimer.start()

		current_items += 1

func _on_mustard_timer_timeout():
	if current_items < max_items:
		var random_x
		var random_y
		
		print("mostarda")
		
		if(Events.current_level > 1):
			while (random_x == null or random_y == null or random_x <= 52 or random_y >= 150 + _camera.global_position.y or random_y <= 40 + _camera.global_position.y or random_x >= 285):
				random_x = randf_range(spawn_area.position.x, spawn_area.position.x + spawn_area.size.x)
				random_y = randf_range(spawn_area.position.y + _camera.global_position.y, spawn_area.position.y + spawn_area.size.y + _camera.global_position.y)
		
			var mustard_instance = mustard_scene.instantiate()
			mustard_instance.global_position = Vector2(random_x, random_y)
			add_child(mustard_instance)
			
			$MustardTimer.start()
			
			current_items += 1
	
func _on_mayonnaise_timer_timeout():
	if current_items < max_items:
		var random_x
		var random_y
		
		print("maionese")
		
		if(Events.current_level > 2):
			while (random_x == null or random_y == null or random_x <= 52 or random_y >= 150 + _camera.global_position.y or random_y <= 40 + _camera.global_position.y or random_x >= 285):
				random_x = randf_range(spawn_area.position.x, spawn_area.position.x + spawn_area.size.x)
				random_y = randf_range(spawn_area.position.y + _camera.global_position.y, spawn_area.position.y + spawn_area.size.y + _camera.global_position.y)			
		
			var mayonnaise_instance = mayonnaise_scene.instantiate()
			mayonnaise_instance.global_position = Vector2(random_x, random_y)
			add_child(mayonnaise_instance)
			
			$MayonnaiseTimer.start()
			
			current_items += 1
	
func _on_touch_screen_button_2_pressed() -> void:
	_character.manual_dash_enabled = true

func _on_player_life_changed(lives: int) -> void:
	$CanvasLayer/BackgroundPanel/Heart.set_size(Vector2(lives * heart_size, 0))
	$CanvasLayer/BackgroundPanel.set_size(Vector2(lives * heart_size, 24))
	if lives <= 0:
		$CanvasLayer/BackgroundPanel/Heart.visible = false

func _on_player_died() -> void:
	get_tree().set_pause(true)
	var game_over = preload("res://Scenes/Interface/game_over_screen.tscn")
	var game_over_instance = game_over.instantiate()  
	add_child(game_over_instance)  
	
func _set_power_up_double_damage():
	$GetPowerup.play()
	$CanvasLayer/powerup_double_damage.visible = not($CanvasLayer/powerup_double_damage.visible)
	
func _set_power_up_more_speed():
	$GetPowerup.play()	
	$CanvasLayer/powerup_double_speed.visible = not($CanvasLayer/powerup_double_speed.visible)

func _set_power_up_less_damage():
	$GetPowerup.play()
	$CanvasLayer/powerup_less_damage.visible = not($CanvasLayer/powerup_less_damage.visible)

func _on_pressed() -> void:
	SelectSfx.play()
	_toggle_fullscreen()

func _toggle_fullscreen() -> void:
	_is_full_screen = not _is_full_screen
	if _is_full_screen:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)

func game_ended() -> void:
	await get_tree().create_timer(1).timeout
	get_tree().set_pause(true)
	var game_won = preload("res://Scenes/Interface/victory_screen.tscn")
	var game_won_instance = game_won.instantiate()  
	add_child(game_won_instance)  

func _on_button_mobile_menu_pressed():
	get_tree().set_pause(true)  
	var pause_scene = preload("res://Scenes/Interface/pause_screen.tscn")
	var pause_instance = pause_scene.instantiate()  
	add_child(pause_instance) 

func freeze_engine() -> void:
	Engine.time_scale = freeze_slow
	await get_tree().create_timer(freeze_time * freeze_slow).timeout
	Engine.time_scale = 1
