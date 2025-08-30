extends Area2D

@export var speed: float = 300.0
@export var direction: Vector2

func _ready() -> void:
	rotation = direction.angle() - PI / 2

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	position += direction.normalized() * speed * delta


func _on_body_entered(body: Node2D) -> void:
	SignalHub.player_hit.emit()
