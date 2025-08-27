extends CharacterBody2D

var fuel_depleted : bool = false

@export var ship_resource: BasicShip
@export var camera_zoom_curve: Curve

@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D
@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var camera_2d: Camera2D = $Camera2D

func _ready() -> void:
	collision_shape_2d.shape = ship_resource.ship_collider
	sprite_2d.texture = ship_resource.ship_asset
	GameTracker.connect("player_hit", _on_player_hit)

func _physics_process(delta: float) -> void:
	if !fuel_depleted and ship_resource.fuel_tank <= 0.0:
		fuel_depleted = true

	_handle_input(delta)
	if not velocity.is_zero_approx():
		_on_velocity(delta)
	else:
		_on_no_velocity()
	move_and_slide()


func _on_player_hit() -> void:
	if ship_resource.health_points > 0:
		ship_resource.health_points = ship_resource.health_points - 1
		print("Decreasing HP to = " + str(ship_resource.health_points))
	else:
		print("You are dead")

func _handle_input(delta: float) -> void:
	var input : Vector2
	
	if fuel_depleted:
		input = Vector2.ZERO
	else:
		input = Vector2(
			Input.get_action_strength("move_right") - Input.get_action_strength("move_left"), 
			Input.get_action_strength("move_down") - Input.get_action_strength("move_up")).normalized()

	var weight_x: float = \
		1.0 - exp(-(ship_resource.accelaration if input.x else ship_resource.friction) * delta)
	var weight_y: float = \
		1.0 - exp(-(ship_resource.accelaration if input.y else ship_resource.friction) * delta)
	
	velocity.x = lerp(velocity.x, input.x * ship_resource.max_speed, weight_x)
	velocity.y = lerp(velocity.y, input.y * ship_resource.max_speed, weight_y)
	
	if input:
		rotation = lerp_angle(rotation, PI/ 2 + input.angle(), 0.25)

func _on_velocity(delta: float) -> void:
	var sample: float = camera_zoom_curve.sample(velocity.length_squared() / \
			(ship_resource.max_speed * ship_resource.max_speed))
	var zoom = lerpf(camera_2d.zoom.x, sample, 0.1)
	
	camera_2d.zoom = Vector2(zoom, zoom)
	ship_resource.fuel_tank = ship_resource.fuel_tank - ship_resource.fuel_depletion_rate * delta


func _on_no_velocity() -> void:
	camera_2d.zoom = Vector2.ONE
