extends AudioStreamPlayer2D

export(Array, AudioStream) var sfx : Array


func _input(event: InputEvent) -> void:
	if event.is_action("down"):
		play()


func play(from_position: float = 0.0) -> void:
	stream = sfx[min(int(randf() * sfx.size()), sfx.size() - 1)]
	.play(from_position)
