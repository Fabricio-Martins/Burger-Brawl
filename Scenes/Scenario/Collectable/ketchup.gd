extends Area2D

@export var _character: Character

func _ready():
	var characters = get_tree().get_nodes_in_group("Character")
	
	if characters.size() > 0:
		_character = characters[0]
	else:
		print("Nenhum elemento no grupo 'Character' encontrado.")
		
func _process(delta):
	pass
	
func _on_body_entered(body):
	if _character:
		_character._damage *= 2
		#$ketchupPowerup.play()
		queue_free()
