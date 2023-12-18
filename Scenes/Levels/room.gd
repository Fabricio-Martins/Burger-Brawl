extends Node2D

# Esse código possui partes baseadas em uma série de vídeos, cujo script pode ser encontrado em:
# https://github.com/MateuSai/Godot-Roguelike-Tutorial

const life_pickup: PackedScene = preload("res://Scenes/Scenario/Collectable/life_pickup.tscn")
const spawn_animation: PackedScene = preload("res://Scenes/Scenario/Enviroment/spawn_animation.tscn")

const ENEMIES: Dictionary = {
	"TOMATO": preload("res://Scenes/Enemies/Tomato/tomato.tscn"),
	"BREAD": preload("res://Scenes/Enemies/Bread/bread.tscn"),
	"MEAT": preload("res://Scenes/Enemies/Meat/meat.tscn")
}

@onready var world: Node2D = get_node("../..")

@onready var tilemap: TileMap = $TileMapKitchen
@onready var entrance: Node2D = $Entrance
@onready var enemies_position: Node2D = $EnemyPositions
@onready var player_detector: Area2D = $PlayerDetector

var num_enemies: int
@export var enemy_chosen: String

func _ready() -> void:
	num_enemies = enemies_position.get_child_count() # Adquire a quantia de inimigos.

func _on_enemy_killed(enemy):
	# Cai uma vida ao derrotar o inimigo
	var life: Area2D = life_pickup.instantiate()
	life.position = enemy.position
	call_deferred("add_child", life)
	
	# Abre todas as portas quando não há mais inimigos na sala.
	num_enemies -= 1
	if num_enemies == 0:
		if Events.current_level == Events.final_level:
			world.game_ended()
		else:
			_open_doors()
	
func _open_doors() -> void:
	# Abre todas portas da sala.
	for door in tilemap.get_children():
		if door.has_method("open"):
			door.open()
		
func _close_entrance() -> void:
	# Fecha a entrada da sala colocando um tile pelo tilemap.
	for entry in entrance.get_children():
		tilemap.set_cell(0, tilemap.local_to_map(entry.position) + Vector2i.DOWN, 0, Vector2i(5,0))
		

func _spawn_enemies() -> void:
	for enemy_position in enemies_position.get_children():
		var enemy: CharacterBody2D
		
		#enemy_chosen = ENEMIES.keys()[randi() % ENEMIES.size()]
		
		match(enemy_chosen):
			"TOMATO":
				enemy = ENEMIES.TOMATO.instantiate()
			"BREAD":
				enemy = ENEMIES.BREAD.instantiate()
			"MEAT":
				enemy = ENEMIES.MEAT.instantiate()
		
		
		var __ = enemy.connect("tree_exited", _on_enemy_killed.bind(enemy)) # Envia sinal quando inimigo morre.
		enemy.position = enemy_position.position # Seta a posição inicial do inimigo.
		call_deferred("add_child", enemy)
		
		# Faz animação de spawn antes do inimigo surgir.
		var spawn: AnimatedSprite2D = spawn_animation.instantiate()
		spawn.position = enemy_position.position
		call_deferred("add_child", spawn)
		
		
func _on_player_detector_body_entered(_body: CharacterBody2D) -> void:
	# Ao detectar o jogador, fecha as portas e spawna os inimigos.
	player_detector.queue_free()
	_close_entrance()
	_spawn_enemies()


func _on_player_camera_detector_body_entered(_body: Node2D) -> void:
	Events.room_entered.emit(self)
	print("Collision triggered")
