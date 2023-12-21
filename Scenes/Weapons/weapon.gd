@icon("res://Assets/Weapons/WoodenSpoon.png")

extends Node2D
class_name Weapon

@onready var animation_player: AnimationPlayer = get_node("WeaponAnimationPlayer")
@onready var hitbox: Area2D = get_node("Node2D/Texture/Hitbox")

var direction: Vector2 = Vector2.ZERO

@onready var _character: Character
@onready var player: CharacterBody2D = get_tree().current_scene.get_node("Player")
@onready var characters = get_tree().get_nodes_in_group("Character")
var pos_player

func _ready():
	if characters.size() > 0:
		_character = characters[0]
	else:
		print("Nenhum elemento no grupo 'Character' encontrado.")

func _physics_process(_delta: float) -> void:
	if is_instance_valid(player):
		pos_player = _character.get_global_position()
		
func get_input() -> void:
	if not (OS.has_feature("mobile")):
		if Input.is_action_just_pressed("ui_attack") and not animation_player.is_playing():
			$AttackAudio.play()
			animation_player.play("attack")

func move(mouse_direction: Vector2) -> void:
	rotation = mouse_direction.angle()
	hitbox.knockback_direction = mouse_direction
	
	if mouse_direction.x > 0:
		scale.y = 1
	else:
		scale.y = -1

func is_busy() -> bool:
	if animation_player.is_playing():
		return true
	return false
