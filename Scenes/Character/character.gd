class_name Character
extends CharacterBody2D

var enemy_inattack_range = false
var enemy_attack_colldown = true 
var player_alive = true

@export_category("Variables")
@export var _move_speed: float = 150

@export var _acceleration: float = 0.2
@export var _friction: float = 0.2
@export var _health: float = 10
@export var _damage: float = 10
@export var coins: float
@export var dash_is_allowed: bool = true
@export var is_dashing: bool = false
var dash_duration: float = 0.3
var dash_speed: float = 300  

@onready var weapon: Node2D = get_node("Weapon")
@onready var weapon_animation: AnimationPlayer = get_node("Weapon/WeaponAnimationPlayer")
@onready var weapon_hitbox: Area2D = get_node("Weapon/Node2D/Sprite2D/Hitbox")


func _physics_process(delta: float) -> void:
	var mouse_direction: Vector2 = (get_global_mouse_position() - global_position).normalized()
	
	if is_dashing:
		dash_duration -= delta
		
		if dash_duration <= 0:
			is_dashing = false
			velocity = Vector2.ZERO
	else:
		_move()
	
	
	if mouse_direction.x > 0:
		$Sprite2D.flip_h = false
		$Weapon/Node2D/Sprite2D.scale.y = 1
	else:
		$Sprite2D.flip_h = true
		$Weapon/Node2D/Sprite2D.scale.y = -1
		
	weapon.rotation = mouse_direction.angle()
	weapon_hitbox.knockback_direction = mouse_direction
	
	if Input.is_action_just_pressed("ui_attack") and not weapon_animation.is_playing() and mouse_direction.x > 0:
		weapon_animation.play("attack_right")
	elif Input.is_action_just_pressed("ui_attack") and not weapon_animation.is_playing() and mouse_direction.x < 0:
		weapon_animation.play("attack_left")
		
	move_and_slide()
	
func start_dash():
	if not is_dashing:
		is_dashing = true
		dash_duration = 0.3
		var dash_direction: Vector2 = Vector2(
			Input.get_action_strength("move_right") - Input.get_action_strength("move_left"),
			Input.get_action_strength("move_down") - Input.get_action_strength("move_up")
		).normalized()
		
		velocity = dash_direction * dash_speed


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
