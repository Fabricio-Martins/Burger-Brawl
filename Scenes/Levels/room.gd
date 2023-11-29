extends Node

const SPAWN_ANIMATION: PackedScene = preload("res://Scenes/Scenario/Enviroment/spawn_animation.tscn")

const ENEMIES: Dictionary = {
	"TOMATO": preload("res://Scenes/Tomato/tomato.tscn")
}

@onready var tilemap: TileMap = $TileMapKitchen
@onready var entrance: Node2D = $Entrance
@onready var doors: Node2D = $Doors
@onready var enemies_position: Node2D = $EnemyPositions
@onready var player_detector: Area2D = $PlayerDetector

var num_enemies: int

func _ready() -> void:
	num_enemies = enemies_position.get_child_count()

func _on_enemy_killed():
	num_enemies -= 1
	if num_enemies == 0:
		_open_doors()
	
func _open_doors() -> void:
	for door in doors.get_children():
		door.queue_free()
		
func _close_entrance() -> void:
	for entry in entrance.get_children():
		tilemap.set_cell(0, tilemap.local_to_map(entry.position) + Vector2i.DOWN, 0, Vector2i(5,0))
		

func _spawn_enemies() -> void:
	for enemy_position in enemies_position.get_children():
		var enemy: CharacterBody2D = ENEMIES.TOMATO.instantiate()
		var __ = enemy.connect("tree_exited", _on_enemy_killed)
		enemy.position = enemy_position.position
		call_deferred("add_child", enemy)
		
		var spawn_animation: AnimatedSprite2D = SPAWN_ANIMATION.instantiate()
		spawn_animation.position = enemy_position.position
		call_deferred("add_child", spawn_animation)
		
		
func _on_player_detector_body_entered(_body: CharacterBody2D) -> void:
	player_detector.queue_free()
	_close_entrance()
	_spawn_enemies()
