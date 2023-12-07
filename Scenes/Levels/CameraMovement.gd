extends Node2D

@onready var _screen_size: Vector2i = get_viewport_rect().size
@onready var _current_cell: Vector2i
var _camera_speed: float = 2
var _lefttop_most: Vector2i

signal cell_changed

func _ready():
	_current_cell = _get_cell($"../Player".global_position) # Pega a célula atual
	var rect_scene: Rect2 = _get_map_bounds($"../TileMapKitchen")#_get_map_bounds($"../TileMapKitchen")
	_lefttop_most = rect_scene.position

func _get_cell(pos: Vector2i) -> Vector2i:
	return (pos + -_lefttop_most)/_screen_size # Pega a posição atual e divide pelo tamanho da tela 

func _change_cell(cell: Vector2i) -> void:
	print("Cell info:", cell * Vector2i(320, 176))
	var tween = create_tween()
	var pos: Vector2 = cell * _screen_size + _screen_size/2 + _lefttop_most # A soma é para centralizar
	
	var distance: float = (_current_cell - cell).length()
	tween.tween_property($".", "global_position", pos, distance/_camera_speed)
	
#	var pos_int: Vector2i = $Player.global_position + Vector2(16,16)
#	$Player.global_position = (pos_int / 32) * 32
	
	_current_cell = cell
	print(_current_cell)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	var cell: Vector2i = _get_cell($"../Player".global_position)
	if _current_cell != cell:
		emit_signal("cell_changed")
		print("Current Cell:", cell)
		_change_cell(cell)
		
func _get_map_bounds(tilemap) -> Rect2:
	var cell_rect: Rect2 = tilemap.get_used_rect()
	var pixel_size: float = tilemap.cell_quadrant_size * tilemap.scale.x
	
	var pos := Vector2(pixel_size * cell_rect.position.x, pixel_size * cell_rect.position.y)
	var size:= Vector2(pixel_size * cell_rect.size.x, pixel_size * cell_rect.size.y)
	
	return Rect2(pos, size)	
	
