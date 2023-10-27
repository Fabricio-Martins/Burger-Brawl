class_name Enemy
extends CharacterBody2D

@onready var _character: Character

@export var health: float = 10

var pos_enemy
var pos_player

var _speed: float = 100
var _motion: Vector2

func _ready():
	var characters = get_tree().get_nodes_in_group("Character")
	
	if characters.size() > 0:
		_character = characters[0]
	else:
		print("Nenhum elemento no grupo 'Character' encontrado.")

func _physics_process(_delta: float) -> void:
	if _character:
		pos_player = _character.get_global_position()
		pos_enemy = get_global_position()
		
		_motion = (pos_player - pos_enemy).normalized()
		velocity = _motion * _speed
	
		move_and_slide()

func enemy():
	pass
