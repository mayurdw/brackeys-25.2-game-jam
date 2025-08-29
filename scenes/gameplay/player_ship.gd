extends CharacterBody2D

var fuel_depleted : bool = false

var ship_resource: BasicShip
@export var camera_zoom_curve: Curve

@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D
@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var camera_2d: Camera2D = $Camera2D

var wheel_base: float
var slip_speed: float
var steer_direction: float

var steering_angle: float = 30.0
var max_speed_reverse: float = 250
var traction_fast: float = 2.5
var traction_slow: float = 10

var acceleration: Vector2 = Vector2.ZERO

func _on_player_hit() -> void:
	if ship_resource.health_points > 0:
		ship_resource.health_points = ship_resource.health_points - 1
		SignalHub.current_hp.emit(ship_resource.health_points)
	else:
		# TODO: Game Over
		print("You are dead")

func _ready() -> void:
	ship_resource = GameTracker.current_ship
	collision_shape_2d.shape = ship_resource.ship_collider
	sprite_2d.texture = ship_resource.ship_asset
	wheel_base = sprite_2d.texture.get_height()
	slip_speed = ship_resource.max_speed / 2.0
	SignalHub.connect("player_hit", _on_player_hit)

func _physics_process(delta):
	if !fuel_depleted and ship_resource.fuel_tank <= 0.0:
		SignalHub.current_fuel.emit(0.0)
		fuel_depleted = true

	acceleration = Vector2.ZERO
	var turn = Input.get_axis("move_left", "move_right")
	steer_direction = turn * deg_to_rad(steering_angle)
	if not fuel_depleted and Input.is_action_pressed("move_up"):
		acceleration = transform.x * ship_resource.engine_power
	if not fuel_depleted and Input.is_action_pressed("move_down"):
		acceleration = (transform.x * ship_resource.max_speed * -1.0) if not velocity.is_zero_approx() else Vector2.ZERO

	if acceleration == Vector2.ZERO and velocity.length() < 50:
		velocity = Vector2.ZERO
		_on_no_velocity()
	else:
		_on_velocity(delta)
	var drag_force = velocity * velocity.length() * delta * ship_resource.friction * -1.0
	var rear_wheel = position - transform.x * wheel_base / 2.0
	var front_wheel = position + transform.x * wheel_base / 2.0
	rear_wheel += velocity * delta
	front_wheel += velocity.rotated(steer_direction) * delta
	var new_heading = rear_wheel.direction_to(front_wheel)
	var traction = traction_slow
	if velocity.length() > slip_speed:
		traction = traction_fast
	
	var d = new_heading.dot(velocity.normalized())
	if d > 0:
		velocity = lerp(velocity, new_heading * min(velocity.length(), ship_resource.max_speed), traction * delta)
	if d < 0:
		velocity = -new_heading * min(velocity.length(), max_speed_reverse)
	rotation = new_heading.angle()

	velocity += acceleration * delta
	move_and_slide()

func _on_velocity(delta: float) -> void:
	var sample: float = camera_zoom_curve.sample(velocity.length_squared() / \
			(ship_resource.max_speed * ship_resource.max_speed))
	var zoom = lerpf(camera_2d.zoom.x, sample, 0.1)
	
	camera_2d.zoom = Vector2(zoom, zoom)
	ship_resource.fuel_tank = ship_resource.fuel_tank - ship_resource.fuel_depletion_rate * delta
	SignalHub.current_fuel.emit(ship_resource.fuel_tank)

func _on_no_velocity() -> void:
	camera_2d.zoom = Vector2.ONE
