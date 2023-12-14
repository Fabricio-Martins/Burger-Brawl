extends Camera2D

signal custom_room_entered

func _ready() -> void:
	Events.room_entered.connect(func(room):
		emit_signal("custom_room_entered")
		global_position = room.global_position
	)
