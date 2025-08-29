extends Control

@export var basic_ship: BasicShip

@onready var upgradable_stats: Array[StatUpgrade] = [
	preload("res://resources/gameplay_resources/stat_upgrades/acceleration_upgrade.tres"),
	preload("res://resources/gameplay_resources/stat_upgrades/friction_upgrade.tres"),
	preload("res://resources/gameplay_resources/stat_upgrades/fuel_depletion_upgrade.tres"),
	preload("res://resources/gameplay_resources/stat_upgrades/fuel_tank_upgrade.tres"),
	preload("res://resources/gameplay_resources/stat_upgrades/health_upgrade.tres"),
	preload("res://resources/gameplay_resources/stat_upgrades/speed_upgrade.tres")
]

@onready var speed: StatDisplay = %Speed
@onready var acceleration: StatDisplay = %Acceleration
@onready var friction: StatDisplay = %Friction
@onready var health: StatDisplay = %Health
@onready var fuel: StatDisplay = %Fuel
@onready var fuel_depl: StatDisplay = %"Fuel Depl"
@onready var title: Label = %Title
@onready var description: Label = %Description
@onready var cost: Label = %Cost
@onready var left: Button = %Left
@onready var buy: Button = %Buy
@onready var right: Button = %Right

var index: int = 0

func _sort_upgrades(upgrade_1: StatUpgrade, upgrade_2: StatUpgrade) -> bool:
	return upgrade_1.cost < upgrade_2.cost

func _display_values(upgrade: StatUpgrade, ship: BasicShip) -> void:
	var new_ship: BasicShip = BasicShip.new()
	new_ship.accelaration = ship.accelaration
	new_ship.friction = ship.friction
	new_ship.fuel_depletion_rate = ship.fuel_depletion_rate
	new_ship.friction = ship.friction
	new_ship.health_points = ship.health_points
	new_ship.max_speed = new_ship.max_speed
	
	new_ship = Stat.get_update_stat(new_ship, upgrade.stat, upgrade.diff_value)
	
	speed.update_value(new_ship.max_speed)
	acceleration.update_value(new_ship.accelaration)
	friction.update_value(new_ship.friction)
	health.update_value(new_ship.health_points)
	fuel.update_value(new_ship.fuel_tank)
	fuel_depl.update_value(new_ship.fuel_depletion_rate)
	title.text = upgrade.title
	description.text = upgrade.description
	cost.text = str(upgrade.cost)

func _ready() -> void:
	upgradable_stats.sort_custom(_sort_upgrades)
	left.disabled = true
	buy.disabled = GameTracker.score_accumulated <= upgradable_stats[index].cost
	_display_values(upgradable_stats[0], basic_ship)


func _on_left_pressed() -> void:
	index = index - 1
	if 0 >= index:
		index = 0
		left.disabled = true
	else:
		left.disabled = false
	right.disabled = false
	buy.disabled = GameTracker.score_accumulated <= upgradable_stats[index].cost
	_display_values(upgradable_stats[index], basic_ship)

func _on_buy_pressed() -> void:
	pass # Replace with function body.


func _on_right_pressed() -> void:
	index = index + 1
	if index >= upgradable_stats.size() - 1:
		index = upgradable_stats.size() - 1
		right.disabled = true
	else:
		right.disabled = false
	left.disabled = false
	buy.disabled = GameTracker.score_accumulated <= upgradable_stats[index].cost
	_display_values(upgradable_stats[index], basic_ship)
