@icon("res://Assets/Characters/Chef/chef16.png")

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
@export var _damage_suffered: float = 1
@export var _damage: float = 1
@export var coins: float
@export var dash_is_allowed: bool = true
@export var is_dashing: bool = false
var dash_duration: float = 0.3
var dash_speed: float = 300  
var _is_being_damaged: bool = false
var direction: Vector2 = Vector2.ZERO
var _is_dead: bool = false

var double_damage_active: bool = false
var double_speed_active: bool = false
var less_damage_active: bool = false

@onready var animation_tree = $AnimationTree
@onready var state_machine = animation_tree.get("parameters/playback")

@onready var weapons: Node2D = get_node("Weapons")

var current_weapon: Node2D

signal double_damage
signal double_speed
signal less_damage

@export var manual_dash_enabled = false

signal life_changed
signal died

func _ready() -> void:
	emit_signal('life_changed', _health)
	current_weapon = weapons.get_child(0)
	
func _physics_process(delta: float) -> void:
	if OS.has_feature("mobile"):
		pass
	else:
		direction = (get_global_mouse_position() - global_position).normalized()
	
	if !_is_dead:
		if is_dashing:
			dash_duration -= delta
			
			if dash_duration <= 0:
				is_dashing = false
				velocity = Vector2.ZERO
		else:
			_move()
	
	
	if direction.x > 0:
		$AnimatedSprite2D.flip_h = false
	else:
		$AnimatedSprite2D.flip_h = true
	
	current_weapon.move(direction)
	if not current_weapon.is_busy():
		if Input.is_action_just_released("ui_change_weapon"):
			_switch_weapon()
	current_weapon.get_input()
	
	move_and_slide()
	#pick_new_state()
	
func _switch_weapon() -> void:
	var index: int = current_weapon.get_index()
	index -= 1
	if index < 0:
		index = weapons.get_child_count() - 1
	
	current_weapon.hide()
	current_weapon = weapons.get_child(index)
	current_weapon.show()
	
func start_dash():
	if not is_dashing:
		is_dashing = true
		dash_duration = 0.3
		var dash_direction: Vector2 = Vector2(
			Input.get_action_strength("move_right") - Input.get_action_strength("move_left"),
			Input.get_action_strength("move_down") - Input.get_action_strength("move_up")
		).normalized()
		
		$DashAudio.play()
		#state_machine.travel("Dash")
		$AnimationPlayer.play("dash")
		velocity = dash_direction * dash_speed
		
		#update_animation_parameters(velocity)

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
		
	#update_animation_parameters(velocity)

func take_damage(_damage_dealt: float, knockback_force: int, knockback_direction: Vector2) -> void:
	$DamageAudio.play()
	_health -= _damage_suffered
	
	print(_health)
	emit_signal('life_changed', _health)
	
	velocity += knockback_direction * knockback_force
	
	_is_being_damaged = true
	dash_is_allowed = false
	if _health > 0:
		$AnimationPlayer.play("hurt")
		#state_machine.travel("Hurt")
	else:
		$AnimationPlayer.play("dead")
		#Events.create_hit(get_global_position())
	await get_tree().create_timer(0.2).timeout
	_is_being_damaged = false
	await get_tree().create_timer(0.2).timeout
	dash_is_allowed = true

func heal() -> void:
	$GetPowerup.play()
	_health += 1
	emit_signal('life_changed', _health)

func has_died():
	emit_signal("died")
	queue_free()

func is_dead():
	_is_dead = true
	
func apply_powerup_more_speed():
	if not double_speed_active:
		emit_signal("double_speed")
		_move_speed = 220
		double_speed_active = true
		await get_tree().create_timer(8).timeout
		
		if(_move_speed == 220):
			emit_signal("double_speed")
			_move_speed = 150
			double_speed_active = false

func apply_powerup_double_damage():
	if not double_damage_active:
		emit_signal("double_damage")
		_damage = 2
		double_damage_active = true
		await get_tree().create_timer(8).timeout
		
		if(_damage == 2):
			emit_signal("double_damage")
			_damage = 1
			double_damage_active = false
			
func apply_powerup_less_damage():
	if not less_damage_active:
		emit_signal("less_damage")
		_damage_suffered = 0
		less_damage_active = true
		await get_tree().create_timer(2).timeout
		
		if(_damage_suffered == 0):
			emit_signal("less_damage")
			_damage_suffered = 1
			less_damage_active = false


# Funções em desuso
func pick_new_state():
	if(velocity != Vector2.ZERO):
		pass
		#state_machine.travel("Walk")
	else:
		state_machine.travel("Idle")
		
func update_animation_parameters(move_input : Vector2):
	if(move_input != Vector2.ZERO):
		animation_tree.set("parameters/Idle/blend_position", move_input)
		animation_tree.set("parameters/Hurt/blend_position", move_input)
		animation_tree.set("parameters/Dash/blend_position", move_input)
