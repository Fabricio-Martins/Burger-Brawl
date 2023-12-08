extends Area2D

@onready var _character: Character

var damage = 1  
var damageInterval = 2.0  
var timer = 0.0  
var is_inside = false

signal life_changed

func _ready():
	var characters = get_tree().get_nodes_in_group("Character")

	if characters.size() > 0:
		_character = characters[0]
	else:
		print("Nenhum elemento no grupo 'Character' encontrado.")

func _process(delta):
	if is_inside:
		timer += delta
		print(timer)
		if timer >= damageInterval:
			apply_damage()
			timer = 0.0

func _on_body_entered(body):
	is_inside = true
	if body.get_name() == "Player":
		if _character.is_dashing:
			_character.is_dashing = false
		_character.dash_is_allowed = false

func _on_body_exited(body):
	is_inside = false
	timer = 0.0
	if body.get_name() == "Player":
		print("timer")
		_character.dash_is_allowed = true

func apply_damage():
	if _character._health > 0:
		_character.take_damage(1, 0, Vector2.ZERO)

