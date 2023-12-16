extends Hitbox

# Esse código possui partes baseadas em uma série de vídeos, cujo script pode ser encontrado em:
# https://github.com/MateuSai/Godot-Roguelike-Tutorial

var _direction: Vector2 = Vector2.ZERO
var _speed: int = 0

func shooting_target(initial_position: Vector2, dir: Vector2, speed: int) -> void:
	position = initial_position
	_direction = dir
	knockback_direction = dir
	_speed = speed

	rotation += dir.angle() + PI/2

func _physics_process(delta: float) -> void:
	position += _direction * _speed * delta

func _on_body_entered(body: Node2D) -> void:
	if body.has_method("take_damage"):
		body.take_damage(damage, knockback_force, knockback_direction)
	#queue_free()
