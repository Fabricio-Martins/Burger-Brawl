extends Node2D

@onready var _screen_size: Vector2i = get_viewport_rect().size
var _current_cell: Vector2i
var _camera_speed: float = 2

func _ready():
	_current_cell = _get_cell($"../Player".global_position)


func _get_cell(pos: Vector2i) -> Vector2i:
	return pos/_screen_size


func _change_cell(cell: Vector2i) -> void:
	var tween = create_tween()
	var pos: Vector2 = cell * _screen_size + _screen_size/2
	
	var distance: float = (_current_cell - cell).length()
	tween.tween_property($".", "global_position", pos, distance/_camera_speed)
	
#	var pos_int: Vector2i = $Player.global_position + Vector2(16,16)
#	$Player.global_position = (pos_int / 32) * 32
	
	_current_cell = cell


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	var cell: Vector2i = _get_cell($"../Player".global_position)
	if _current_cell != cell:
		_change_cell(cell)
