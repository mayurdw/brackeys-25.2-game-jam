extends Area2D

@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D

var sprites: Array[Resource] = [
	preload("res://resources/gameplay_sprites/obstacle_1.tres"),
	preload("res://resources/gameplay_sprites/obstacle_2.tres"),
	preload("res://resources/gameplay_sprites/obstacle_3.tres"),
	preload("res://resources/gameplay_sprites/obstacle_4.tres")
]

func _ready() -> void:
	var individual_scale = randf_range(0.5, 1.5)
	
	sprite_2d.texture = sprites.pick_random()
	rotation_degrees = randi_range(0, 360)
	scale = Vector2(individual_scale, individual_scale)
	collision_shape_2d.scale = scale
	
	call_deferred("_connect_area_signal")

func _connect_area_signal() -> void:
	connect("area_entered", _on_area_entered)

func _on_body_entered(body: Node2D) -> void:
	GameTracker.obstacle_collided()
	_destroy()


func _on_body_exited(body: Node2D) -> void:
	pass

func _on_area_entered(area: Area2D) -> void:
	_destroy()

func _destroy() -> void:
	# Destruction Animation
	collision_shape_2d.disabled = true
	call_deferred("queue_free")
