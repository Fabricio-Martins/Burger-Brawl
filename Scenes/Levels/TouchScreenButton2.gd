extends TouchScreenButton


func _ready() -> void:
	modulate.a8 = 200 
	
	if OS.has_feature("mobile"):
		visible = true

func _process(delta: float) -> void:
	pass
