class_name Enemy
extends CharacterBody2D

@onready var _character: Character

@export var health: float = 10

var pos_enemy
var pos_player

var _speed: float = 50
var _motion: Vector2
var _being_damaged = false

@onready var characters = get_tree().get_nodes_in_group("Character")

func _ready():
	if characters.size() > 0:
		_character = characters[0]
	else:
		print("Nenhum elemento no grupo 'Character' encontrado.")

func _physics_process(_delta: float) -> void:
	if _character:
		pos_player = _character.get_global_position()
		pos_enemy = get_global_position()
		
		if pos_player.x < pos_enemy.x:
			$Sprite2D.flip_h = false
		else:
			$Sprite2D.flip_h = true
			
		_motion = (pos_player - pos_enemy).normalized()
		
		if not _being_damaged:
			velocity = _motion * _speed
	
		move_and_slide()

	
func take_damage(damage: int, knockback_force: int, knockback_direction: Vector2) -> void:
	health -= 1
	
	velocity += knockback_direction * knockback_force
	
	$AnimationPlayer.play("hurt")
	_being_damaged = true
	await get_tree().create_timer(0.2).timeout
	
	if health <= 0:
		queue_free()
	_being_damaged = false
