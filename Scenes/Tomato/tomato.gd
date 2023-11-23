class_name Enemy
extends CharacterBody2D

@onready var _character: Character

@export var _health: float = 10

var pos_enemy
var pos_player

var _speed: float = 30
var _motion: Vector2
var _is_being_damaged = false

@onready var player: CharacterBody2D = get_tree().current_scene.get_node("Player")
@onready var characters = get_tree().get_nodes_in_group("Character")
@onready var hitbox: Area2D = get_node("Hitbox")

func _ready():
	if characters.size() > 0:
		_character = characters[0]
	else:
		print("Nenhum elemento no grupo 'Character' encontrado.")

func _physics_process(_delta: float) -> void:
	if is_instance_valid(player):
		pos_player = _character.get_global_position()
		pos_enemy = get_global_position()
		
		if pos_player.x < pos_enemy.x:
			$Sprite2D.flip_h = false
		else:
			$Sprite2D.flip_h = true
				
		_motion = (pos_player - pos_enemy).normalized()
			
		if not _is_being_damaged:
			velocity = _motion * _speed
		
		hitbox.knockback_direction = velocity.normalized()
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
