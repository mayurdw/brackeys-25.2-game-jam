extends Area2D

@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D
@onready var timer: Timer = $Timer
@onready var marker: Marker2D = $Marker2D
@onready var missile: PackedScene = preload("res://scenes/gameplay/missiles.tscn")

@export var target_direction: Node2D

func _ready() -> void:
	sprite_2d.frame = randi_range(0, 3)
	timer.wait_time = randi_range(2, 8)
	timer.start()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	look_at(target_direction.position)
	rotation -= PI / 2


func _on_timer_timeout() -> void:
	var new_missile = missile.instantiate()
	new_missile.direction = Vector2.from_angle(rotation + PI / 2)
	new_missile.position = marker.global_position
	
	get_parent().add_child(new_missile)


func _on_body_entered(body: Node2D) -> void:
	SignalHub.player_hit.emit()
