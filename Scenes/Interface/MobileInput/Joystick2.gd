class_name MyVirtualJoystick
extends TouchScreenButton

enum HAlign {LEFT, RIGHT}
enum VAlign {TOP, BOTTOM}

@export var action_right: String = "ui_right"
@export var action_left:  String = "ui_left"
@export var action_up:    String = "ui_up"
@export var action_down:  String = "ui_down"
@export var hanchor: HAlign
@export var vanchor: VAlign

@onready var _base: TouchScreenButton = self
@onready var _point: Sprite2D = $JoystickPoint

var _radius: Vector2
var _input_vector: Vector2 = Vector2.ZERO
var _active: bool = false
var _touch_id: int = -1
var _pos_offset: Vector2

func _ready() -> void:
	if OS.has_feature("mobile"):
		set_visible(true)
		set_process(true)
		
	_radius.x = _base.shape.radius * _base.scale.x
	_radius.y = _base.shape.radius * _base.scale.y
	_point.visible = true

	_get_anchored_position_offset()	
	_on_vierport_size_changed()
	
	get_tree().root.size_changed.connect(_on_vierport_size_changed)

func _get_anchored_position_offset():
	var original_size: Vector2 = Vector2(
		ProjectSettings.get("display/window/size/viewport_width"),
		ProjectSettings.get("display/window/size/viewport_height"))
	
	_pos_offset = get_global_position()
	if hanchor == HAlign.RIGHT:
		_pos_offset.x -= original_size.x
	if vanchor == VAlign.BOTTOM:
		_pos_offset.y -= original_size.y


func _on_vierport_size_changed():
	var new_pos: Vector2 = _pos_offset
	if hanchor == HAlign.RIGHT:
		new_pos.x += get_viewport_rect().size.x
	if vanchor == VAlign.BOTTOM:
		new_pos.y += get_viewport_rect().size.y
	
	set_global_position(new_pos)


func _inside_joystick(pos: Vector2) -> bool:
	return pos.distance_to(_radius + _base.global_position) <= _radius.x
	
	
func _calculate_move_vector(event_position) -> Vector2:
	var texture_center = _base.global_position + _radius
	return (event_position - texture_center).normalized()

var last_direction: Vector2 = Vector2.ZERO

func _get_stick_movement(event: InputEvent) -> void:
	_input_vector = _calculate_move_vector(event.position)
	_active = true
	_point.global_position = event.position
	_point.visible = true
	_generate_input_events()

	last_direction = _input_vector

	if not _inside_joystick(event.position):
		_point.global_position = _input_vector * _radius + _radius + _base.global_position

func _input(event: InputEvent) -> void:
	if event is InputEventScreenTouch and _inside_joystick(event.position) and _touch_id == -1:
		_touch_id = event.index                
		_get_stick_movement(event)

	if (event is InputEventScreenTouch and _touch_id != -1) or event is InputEventScreenDrag:
		if event.index != _touch_id:
			return
		_get_stick_movement(event)

	if event is InputEventScreenTouch:
		if event.index != _touch_id:
			return
			
		if not event.pressed:
			_active = false
			_input_vector = last_direction
			_point.visible = false
			_touch_id = -1    
			_generate_input_events()


func _new_input(_action: String, strength: float) -> void:
	var ev: InputEventAction = InputEventAction.new()
	ev.action = _action
	ev.strength = strength
	ev.pressed = true
	Input.parse_input_event(ev)	

func _generate_input_events() -> void:
	var strength: float = 0
		
	strength = _input_vector.x if _input_vector.x >= 0 else 0.0
	_new_input(action_right, strength)

	strength = -_input_vector.x if _input_vector.x < 0 else 0.0
	_new_input(action_left, strength)

	strength = -_input_vector.y if _input_vector.y < 0 else 0.0
	_new_input(action_up, strength)

	strength = _input_vector.y if _input_vector.y >= 0 else 0.0
	_new_input(action_down, strength)

# external access method
func get_input_vector() -> Vector2:
	return _input_vector
	
var direction: Vector2 = Vector2.ZERO

@onready var _character: Node2D = get_tree().current_scene.get_node("Player")
@onready var weapon: Node2D
@onready var weapon_animation: AnimationPlayer
@onready var weapon_hitbox: Area2D 

func _physics_process(_delta):
	if OS.has_feature("mobile"):
		direction = self.get_input_vector().normalized()
		
		if direction.x > 0:
			_character.get_node("AnimatedSprite2D").flip_h = false
			_character.get_node("Weapon/Node2D/Sprite2D").scale.y = 1
		else:
			_character.get_node("AnimatedSprite2D").flip_h = true
			_character.get_node("Weapon/Node2D/Sprite2D").scale.y = -1

		weapon = _character.get_node("Weapon")
		weapon_animation = _character.get_node("Weapon/WeaponAnimationPlayer")
		weapon_hitbox = _character.get_node("Weapon/Node2D/Sprite2D/Hitbox")
			
		weapon.rotation = direction.angle()
		weapon_hitbox.knockback_direction = direction

		print(direction.angle())

func _on_touch_button_attack_pressed():
	direction = self.get_input_vector().normalized()
	
	if not weapon_animation.is_playing() and direction.x > 0:
		weapon_animation.play("attack_right")
	elif not weapon_animation.is_playing() and direction.x < 0:
		weapon_animation.play("attack_left")
