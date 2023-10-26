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
@export var dash_is_allowed: bool = true
@export var is_dashing: bool = false
var dash_duration: float = 0.3
var dash_speed: float = 1000  

func start_dash():
	if not is_dashing:
		is_dashing = true
		dash_duration = 0.3
		var dash_direction: Vector2 = Vector2(
			Input.get_action_strength("move_right") - Input.get_action_strength("move_left"),
			Input.get_action_strength("move_down") - Input.get_action_strength("move_up")
		).normalized()
		
		velocity = dash_direction * dash_speed
		
func _physics_process(delta: float) -> void:
	if is_dashing:
		dash_duration -= delta
		
		if dash_duration <= 0:
			is_dashing = false
			velocity = Vector2.ZERO
	else:
		_move()
		
	move_and_slide()
	
func _input(event):
	if event.is_action_pressed("dash") and dash_is_allowed:
		start_dash()
	
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
