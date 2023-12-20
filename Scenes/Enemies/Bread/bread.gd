class_name Bread
extends CharacterBody2D

@onready var _character: Character

@export var _health: float = 10

const bullet: PackedScene = preload("res://Scenes/Enemies/Bread/projectile.tscn")

var pos_enemy
var pos_player

var _speed: float = 30
var _is_being_damaged = false

@onready var hit_particles = $HitParticles
@onready var player: CharacterBody2D = get_tree().current_scene.get_node("Player")
@onready var characters = get_tree().get_nodes_in_group("Character")

func _ready():
	if characters.size() > 0:
		_character = characters[0]
	else:
		print("Nenhum elemento no grupo 'Character' encontrado.")

func _physics_process(_delta: float) -> void:
	if is_instance_valid(player):
		pos_player = _character.get_global_position()
		pos_enemy = get_global_position()

		var dir_to_player = (pos_player - pos_enemy).normalized()
		var target_position = pos_player - dir_to_player * 80
		var motion = (target_position - pos_enemy).normalized()

		$Sprite2D.flip_h = pos_enemy.x < pos_player.x

		if not _is_being_damaged:
			velocity = motion * _speed

		var next_position = pos_enemy + velocity * _delta

		if next_position.distance_to(target_position) < 5.0:
			velocity = -velocity  

		set_global_position(next_position)
		move_and_slide()

	
func take_damage(_damage: int, knockback_force: int, knockback_direction: Vector2) -> void:
	print(_character._damage)
	_health -= _character._damage
	
	velocity += knockback_direction * knockback_force
	
	Events.emit_signal("enemy_hit")
	
	hit_particles.rotation = get_angle_to(_character.position) + PI
	velocity += knockback_direction * knockback_force
	$HitParticles.emitting = true
	
	$AnimationPlayer.play("hurt")
	_is_being_damaged = true
	await get_tree().create_timer(0.2).timeout
	
	if _health <= 0:
		queue_free()
	_is_being_damaged = false

func shoot() -> void:
	var projectile: Area2D = bullet.instantiate()
	projectile.shooting_target(global_position, (_character.get_global_position() - global_position).normalized(), 150)
	get_tree().current_scene.add_child(projectile)


func _on_attack_delay_timeout() -> void:
	shoot()
