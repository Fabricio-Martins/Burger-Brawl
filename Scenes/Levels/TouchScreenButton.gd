extends TouchScreenButton


func _ready() -> void:
	modulate.a8 = 220
	
	if OS.has_feature("mobile"):
		visible = true
