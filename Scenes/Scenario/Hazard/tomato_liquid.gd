extends Area2D

@onready var _character: Character

func _ready():
	var characters = get_tree().get_nodes_in_group("Character")
	
	if characters.size() > 0:
		_character = characters[0]
	else:
		print("Nenhum elemento no grupo 'Character' encontrado.")


func _on_body_entered(body):
	if body.get_name() == "Player":
		if _character.is_dashing:
			_character.is_dashing = false
		_character.dash_is_allowed = false
		_character._move_speed -= 100


func _on_body_exited(body):
	if body.get_name() == "Player":
		_character.dash_is_allowed = true
		_character._move_speed += 100
