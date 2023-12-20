class_name Cheese
extends CharacterBody2D

@onready var _character: Character

@export var _health: float = 5

var pos_enemy
var pos_player

var _speed: float = 150
var _motion: Vector2
var _is_being_damaged = false

@onready var hit_particles = $HitParticles
@onready var animation_tree = $AnimationTree
@onready var state_machine = animation_tree.get("parameters/playback")
@onready var player: CharacterBody2D = get_tree().current_scene.get_node("Player")
@onready var characters = get_tree().get_nodes_in_group("Character")
@onready var hitbox: Area2D = get_node("Hitbox")

func _ready():
	if characters.size() > 0:
		_character = characters[0]
	else:
		print("Nenhum elemento no grupo 'Character' encontrado.")

func _physics_process(_delta: float) -> void:
	if is_instance_valid(player):
		pos_player = _character.get_global_position()
		pos_enemy = get_global_position()
		
		var img = $GhostEffect.texture.get_image()
		if pos_player.x < pos_enemy.x:
			$Sprite2D.flip_h = true
			img.flip_x()
			$GhostEffect.texture = ImageTexture.create_from_image(img)
		else:
			$Sprite2D.flip_h = false
			img.flip_x()
			$GhostEffect.texture = ImageTexture.create_from_image(img)
				
		_motion = (pos_player - pos_enemy).normalized()
		
		update_animation_parameters(_motion)
		
		if not _is_being_damaged:
			velocity = _motion * _speed
		
		#look_at(pos_player)
		hitbox.knockback_direction = velocity.normalized()
		move_and_slide()
	
func take_damage(_damage: int, knockback_force: int, knockback_direction: Vector2) -> void:
	print(_character._damage)
	_health -= _character._damage
	
	velocity += knockback_direction * knockback_force
	
	Events.emit_signal("enemy_hit")
	
	hit_particles.rotation = get_angle_to(_character.position) + PI
	velocity += knockback_direction * knockback_force
	$HitParticles.emitting = true
	
	state_machine.travel("Hurt")
	_is_being_damaged = true
	await get_tree().create_timer(0.2).timeout
	
	if _health <= 0:
		queue_free()
	_is_being_damaged = false

func update_animation_parameters(move_input : Vector2):
	if(move_input != Vector2.ZERO):
		animation_tree.set("parameters/Walk/blend_position", move_input)
