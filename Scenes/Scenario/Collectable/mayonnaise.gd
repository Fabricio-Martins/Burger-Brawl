extends Area2D

@export var _character: Character

var coin_label

func _ready():
	var characters = get_tree().get_nodes_in_group("Character")
	
	if characters.size() > 0:
		_character = characters[0]
	else:
		print("Nenhum elemento no grupo 'Character' encontrado.")
		
	coin_label = get_tree().get_nodes_in_group("CoinLabel")[0]

func _on_body_entered(_body):
	if _character:
		_character.apply_powerup_less_damage()
		queue_free()
