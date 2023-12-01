extends StaticBody2D

@onready var animation: AnimationPlayer = $AnimationPlayer

func open() -> void:
	animation.play("open")
