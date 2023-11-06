extends Area2D
class_name Hitbox

@export var damage: int = 1
@export var knockback_force: int = 200
var knockback_direction: Vector2 = Vector2.ZERO

func _init() -> void:
	connect("body_entered", Callable(self, "_on_body_entered"))
	
	
func _on_body_entered(body: Node2D) -> void:
	if body.has_method("take_damage"):
		body.take_damage(damage, knockback_force, knockback_direction)
		
