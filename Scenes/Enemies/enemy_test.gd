class_name Enemy_Test
extends CharacterBody2D

@onready var _character: Character

@export var _health: float = 10

var pos_enemy
var pos_player

var _speed: float = 30
var _motion: Vector2
var _is_being_damaged = false

@onready var navigation_agent: NavigationAgent2D = get_node("NavigationAgent2D")
@onready var player: CharacterBody2D = get_tree().current_scene.get_node("Player")
@onready var characters = get_tree().get_nodes_in_group("Character")
@onready var hitbox: Area2D = get_node("Hitbox")

const ATTACK_RANGE: float = 100  
var can_attack: bool = true

const MAX_DISTANCE_TO_PLAYER: int = 80
const MIN_DISTANCE_TO_PLAYER: int = 40

func _ready():
	if characters.size() > 0:
		_character = characters[0]
	else:
		print("Nenhum elemento no grupo 'Character' encontrado.")

func _physics_process(_delta: float) -> void:
	if is_instance_valid(player):
		pos_player = _character.get_global_position()
		pos_enemy = get_global_position()
		navigation_agent.target_position = _character.get_global_position()

		var dir_to_player = (pos_player - pos_enemy).normalized()
		var target_position = pos_player - dir_to_player * 80
		var motion = (target_position - pos_enemy).normalized()

		$Sprite2D.flip_h = pos_enemy.x < pos_player.x

		if not _is_being_damaged:
			velocity = motion * _speed

		var next_position = pos_enemy + velocity * _delta

		if next_position.distance_to(target_position) < 5.0:
			velocity = -velocity  

		set_global_position(next_position)
		move_and_slide()

func take_damage(damage: int, knockback_force: int, knockback_direction: Vector2) -> void:
	print(_character._damage)
	_health -= _character._damage
	
	velocity += knockback_direction * knockback_force
	
	$AnimationPlayer.play("hurt")
	_is_being_damaged = true
	await get_tree().create_timer(0.2).timeout
	
	if _health <= 0:
		queue_free()
	_is_being_damaged = false
