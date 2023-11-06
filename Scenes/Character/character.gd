class_name Character
extends CharacterBody2D

var enemy_inattack_range = false
var enemy_attack_colldown = true 
var player_alive = true

@export_category("Variables")
@export var _move_speed: float = 150

@export var _acceleration: float = 0.2
@export var _friction: float = 0.2
@export var _health: float = 3
@export var _damage: float = 10
@export var coins: float
@export var dash_is_allowed: bool = true
@export var is_dashing: bool = false
var dash_duration: float = 0.3
var dash_speed: float = 300  
var _is_being_damaged: bool = false
var mouse_direction: Vector2 = Vector2.ZERO

@onready var weapon: Node2D = get_node("Weapon")
@onready var weapon_animation: AnimationPlayer = get_node("Weapon/WeaponAnimationPlayer")
@onready var weapon_hitbox: Area2D = get_node("Weapon/Node2D/Sprite2D/Hitbox")

@export var manual_dash_enabled = false

signal life_changed
signal died

func _ready() -> void:
	emit_signal('life_changed', _health)
	
func _physics_process(delta: float) -> void:
	mouse_direction = (get_global_mouse_position() - global_position).normalized()
	
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
		
		$AnimationPlayer.play("dash")
		velocity = dash_direction * dash_speed


func _input(event):
	if (event.is_action_pressed("dash") or manual_dash_enabled) and dash_is_allowed:
		start_dash()
		manual_dash_enabled = false
	
func _move() -> void:
	var _direction: Vector2 = Vector2(
		Input.get_axis("move_left", "move_right"),
		Input.get_axis("move_up", "move_down")
	)
		
	if _direction != Vector2.ZERO:
		velocity.x = lerp(velocity.x, _direction.normalized().x * _move_speed, _acceleration)
		velocity.y = lerp(velocity.y, _direction.normalized().y * _move_speed, _acceleration)
		return
	
	if not _is_being_damaged:
		velocity.x = lerp(velocity.x, _direction.normalized().x * _move_speed, _friction)
		velocity.y = lerp(velocity.y, _direction.normalized().y * _move_speed, _friction)

func take_damage(damage: int, knockback_force: int, knockback_direction: Vector2) -> void:
	_health -= 1
	emit_signal('life_changed', _health)
	
	velocity += knockback_direction * knockback_force
	
	$AnimationPlayer.play("hurt")
	_is_being_damaged = true
	await get_tree().create_timer(0.2).timeout
	
	if _health <= 0:
		$AnimationPlayer.play("dead")
		emit_signal("died")
	_is_being_damaged = false


func _on_touch_button_attack_pressed() -> void:
	mouse_direction = (get_global_mouse_position() - global_position).normalized()
	
	if not weapon_animation.is_playing() and mouse_direction.x > 0:
		weapon_animation.play("attack_right")
	elif not weapon_animation.is_playing() and mouse_direction.x < 0:
		weapon_animation.play("attack_left")

func has_died():
	queue_free()


func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "dead":
		emit_signal("died")
