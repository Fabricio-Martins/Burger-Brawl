extends Node2D

const SPAWN_ANIMATION: PackedScene = preload("res://Scenes/Scenario/Enviroment/spawn_animation.tscn")

const ENEMIES: Dictionary = {
	"TOMATO": preload("res://Scenes/Tomato/tomato.tscn")
}

@onready var tilemap: TileMap = $TileMapKitchen
@onready var entrance: Node2D = $Entrance
@onready var enemies_position: Node2D = $EnemyPositions
@onready var player_detector: Area2D = $PlayerDetector

var num_enemies: int

func _ready() -> void:
	num_enemies = enemies_position.get_child_count() # Adquire a quantia de inimigos.

func _on_enemy_killed():
	# Abre todas as portas quando não há mais inimigos na sala.
	num_enemies -= 1
	if num_enemies == 0:
		_open_doors()
	
func _open_doors() -> void:
	# Abre todas portas da sala.
	for door in tilemap.get_children():
		door.open()
		
func _close_entrance() -> void:
	# Fecha a entrada da sala colocando um tile pelo tilemap.
	for entry in entrance.get_children():
		tilemap.set_cell(0, tilemap.local_to_map(entry.position) + Vector2i.DOWN, 0, Vector2i(5,0))
		

func _spawn_enemies() -> void:
	for enemy_position in enemies_position.get_children():
		var enemy: CharacterBody2D = ENEMIES.TOMATO.instantiate()
		var __ = enemy.connect("tree_exited", _on_enemy_killed) # Envia sinal quando inimigo morre.
		enemy.position = enemy_position.position # Seta a posição inicial do inimigo.
		call_deferred("add_child", enemy)
		
		# Faz animação de spawn antes do inimigo surgir.
		var spawn_animation: AnimatedSprite2D = SPAWN_ANIMATION.instantiate()
		spawn_animation.position = enemy_position.position
		call_deferred("add_child", spawn_animation)
		
		
func _on_player_detector_body_entered(_body: CharacterBody2D) -> void:
	# Ao detectar o jogador, fecha as portas e spawna os inimigos.
	player_detector.queue_free()
	_close_entrance()
	_spawn_enemies()


func _on_player_camera_detector_body_entered(body: Node2D) -> void:
	Events.room_entered.emit(self)
	print("Collision triggered")
	print(body)
