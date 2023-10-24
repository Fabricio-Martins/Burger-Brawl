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
	print(coin_label)

func _process(delta):
	pass

func _on_body_entered(body):
	if _character:
		if "coins" in _character:
			_character.coins += 1
			coin_label.text = str(_character.coins)
		queue_free()
