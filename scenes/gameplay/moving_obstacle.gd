extends Node2D

@onready var speed: int = randi_range(200, 400)
@onready var direction: Vector2 = Vector2(randf_range(-1.0, 1.0), randf_range(-1.0, 1.0))

func _process(delta: float) -> void:
	if get_child_count():
		position += (delta * speed * direction)
	else:
		call_deferred("queue_free")
