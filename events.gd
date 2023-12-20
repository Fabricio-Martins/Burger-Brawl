extends Node

var hit_particles = preload("res://Scenes/Scenario/Enviroment/hit_particles.tscn")

signal room_entered(room)
var current_level: int
var final_level: int
var hamburger_state: int = 0

func create_hit(position: Vector2) -> void:
	var hit = hit_particles.instantiate()
	hit.global_position = position
	get_tree().root.add_child(hit)
