extends CharacterBody2D

const SPEED: float = 300.0
const ACCELARATION: float = 50.0
const FRICTION: float = 10.0

@export var health_points: int = 10

func _ready() -> void:
	GameTracker.connect("player_hit", _on_player_hit)

func _on_player_hit() -> void:
	if health_points > 0:
		health_points = health_points - 1
		print("Decreasing HP to = " + str(health_points))
	else:
		print("You are dead")

func _physics_process(delta: float) -> void:
	var input : Vector2 = Vector2(
		Input.get_action_strength("move_right") - Input.get_action_strength("move_left"), 
		Input.get_action_strength("move_down") - Input.get_action_strength("move_up")).normalized()
	
	var weight_x: float = \
	1.0 - exp(-(ACCELARATION if input.x else FRICTION) * delta)
	var weight_y: float = \
	1.0 - exp(-(ACCELARATION if input.y else FRICTION) * delta)
	
	velocity.x = lerp(velocity.x, input.x * SPEED, weight_x)
	velocity.y = lerp(velocity.y, input.y * SPEED, weight_y)
	
	move_and_slide()
