extends Resource

class_name BasicShip

@export var max_speed: float = 300.0
@export var engine_power: float = 500.0
@export var friction: float = 1.0

@export var health_points: float = 10.0
@export var fuel_tank: float = 100.0
@export var fuel_depletion_rate: float = 5.0

@export var ship_asset: Resource
@export var ship_collider: Resource
