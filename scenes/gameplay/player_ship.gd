extends CharacterBody2D

var fuel_depleted : bool = false

var ship_resource: BasicShip
@export var camera_zoom_curve: Curve

@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D
@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var camera_2d: Camera2D = $Camera2D

var steering_angle: float = 30.0
var wheel_base = 70
var engine_power = 900
var drag = -0.06
var braking = -450
var max_speed_reverse = 250
var slip_speed = 400
var traction_fast = 2.5
var traction_slow = 10

var acceleration = Vector2.ZERO
var steer_direction

func _physics_process(delta):
	acceleration = Vector2.ZERO
	get_input()
	apply_friction(delta)
	calculate_steering(delta)
	velocity += acceleration * delta
	move_and_slide()
	
func apply_friction(delta):
	if acceleration == Vector2.ZERO and velocity.length() < 50:
		velocity = Vector2.ZERO
	var drag_force = velocity * velocity.length() * drag * delta

func get_input():
	var turn = Input.get_axis("move_left", "move_right")
	steer_direction = turn * deg_to_rad(steering_angle)
	if Input.is_action_pressed("move_up"):
		acceleration = transform.x * engine_power
	if Input.is_action_pressed("move_down"):
		acceleration = transform.x * braking
	
func calculate_steering(delta):
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
		velocity = lerp(velocity, new_heading * velocity.length(), traction * delta)
	if d < 0:
		velocity = -new_heading * min(velocity.length(), max_speed_reverse)
	rotation = new_heading.angle()

#
#
#func _ready() -> void:
	#ship_resource = GameTracker.current_ship
	#collision_shape_2d.shape = ship_resource.ship_collider
	#sprite_2d.texture = ship_resource.ship_asset
	#SignalHub.connect("player_hit", _on_player_hit)
	#SignalHub.current_fuel.emit(ship_resource.fuel_tank)
	#SignalHub.current_hp.emit(ship_resource.health_points)
#
#func _physics_process(delta: float) -> void:
	#if !fuel_depleted and ship_resource.fuel_tank <= 0.0:
		#SignalHub.current_fuel.emit(0.0)
		#fuel_depleted = true
#
	#_handle_input(delta)
	#if not velocity.is_zero_approx():
		#_on_velocity(delta)
	#else:
		#_on_no_velocity()
	#move_and_slide()
#
#
#func _on_player_hit() -> void:
	#if ship_resource.health_points > 0:
		#ship_resource.health_points = ship_resource.health_points - 1
		#SignalHub.current_hp.emit(ship_resource.health_points)
	#else:
		## TODO: Game Over
		#print("You are dead")
#
#func _handle_input(delta: float) -> void:
	#var input : Vector2
	#
	#if fuel_depleted:
		#input = Vector2.ZERO
	#else:
		#input = Vector2(
			#Input.get_action_strength("move_right") - Input.get_action_strength("move_left"), 
			#Input.get_action_strength("move_down") - Input.get_action_strength("move_up")).normalized()
	#
#
	#var weight_x: float = \
		#1.0 - exp(-(ship_resource.accelaration if input.x else ship_resource.friction) * delta)
	#var weight_y: float = \
		#1.0 - exp(-(ship_resource.accelaration if input.y else ship_resource.friction) * delta)
	#
	#velocity.x = lerp(velocity.x, input.x * ship_resource.max_speed, weight_x)
	#velocity.y = lerp(velocity.y, input.y * ship_resource.max_speed, weight_y)
	#
	#if input:
		#rotation = lerp_angle(rotation, PI/ 2 + input.angle(), 0.25)
#
#func _on_velocity(delta: float) -> void:
	#var sample: float = camera_zoom_curve.sample(velocity.length_squared() / \
			#(ship_resource.max_speed * ship_resource.max_speed))
	#var zoom = lerpf(camera_2d.zoom.x, sample, 0.1)
	#
	#camera_2d.zoom = Vector2(zoom, zoom)
	#ship_resource.fuel_tank = ship_resource.fuel_tank - ship_resource.fuel_depletion_rate * delta
	#SignalHub.current_fuel.emit(ship_resource.fuel_tank)
#
#func _on_no_velocity() -> void:
	#camera_2d.zoom = Vector2.ONE
