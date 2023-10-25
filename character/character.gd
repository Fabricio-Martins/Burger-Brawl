class_name Character
extends CharacterBody2D

var enemy_inattack_range = false
var enemy_attack_colldown = true 
var player_alive = true

@export_category("Variables")
@export var _move_speed: float = 600

@export var _acceleration: float = 0.2
@export var _friction: float = 0.2
@export var _health: float = 10
@export var _damage: float = 10
@export var coins: float

func _physics_process(delta: float) -> void:
	_move()
	move_and_slide()
	enemy_attack()
	
func _move() -> void:
	var _direction: Vector2 = Vector2(
		Input.get_axis("move_left", "move_right"),
		Input.get_axis("move_up", "move_down")
	)
		
	if _direction != Vector2.ZERO:
		velocity.x = lerp(velocity.x, _direction.normalized().x * _move_speed, _acceleration)
		velocity.y = lerp(velocity.y, _direction.normalized().y * _move_speed, _acceleration)
		return
	
	velocity.x = lerp(velocity.x, _direction.normalized().x * _move_speed, _friction)
	velocity.y = lerp(velocity.y, _direction.normalized().y * _move_speed, _friction)

func player():
	pass

func _on_player_hitbox_body_entered(body):
	if body.has_method("enemy"):
		enemy_inattack_range = true

func _on_player_hitbox_body_exited(body):
	if body.has_method("enemy"):
		enemy_inattack_range = false
		
func enemy_attack():
	if enemy_inattack_range:
		print("player took damage")
