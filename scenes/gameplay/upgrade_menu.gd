extends Control

@onready var upgradable_stats: Array[StatUpgrade] = [
	preload("res://resources/gameplay_resources/stat_upgrades/engine_power_upgrade.tres"),
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
@onready var purchased: Label = %Purchased

var index: int = 0

func _sort_upgrades(upgrade_1: StatUpgrade, upgrade_2: StatUpgrade) -> bool:
	return upgrade_1.cost < upgrade_2.cost

func _display_values(upgrade: StatUpgrade, ship: BasicShip) -> void:
	var new_ship: BasicShip = BasicShip.new()
	var is_purchased: bool = GameTracker.upgrades_bought.find(upgrade.id) >= 0
	
	new_ship.engine_power = ship.engine_power
	new_ship.friction = ship.friction
	new_ship.fuel_depletion_rate = ship.fuel_depletion_rate
	new_ship.friction = ship.friction
	new_ship.health_points = ship.health_points
	new_ship.max_speed = new_ship.max_speed
	if not is_purchased:
		new_ship = Stat.get_update_stat(new_ship, upgrade.stat, upgrade.diff_value)
	
	speed.update_value(new_ship.max_speed)
	acceleration.update_value(new_ship.engine_power)
	friction.update_value(new_ship.friction)
	health.update_value(new_ship.health_points)
	fuel.update_value(new_ship.fuel_tank)
	fuel_depl.update_value(new_ship.fuel_depletion_rate)
	title.text = upgrade.title
	description.text = upgrade.description
	cost.text = str(upgrade.cost)
	purchased.visible = is_purchased
	buy.disabled = GameTracker.score_accumulated <= upgrade.cost or is_purchased


func _remove_purchased(upgrade: StatUpgrade) -> bool:
	for i in GameTracker.upgrades_bought:
		if i == upgrade.id:
			return false
	return true

func _ready() -> void:
	upgradable_stats.sort_custom(_sort_upgrades)
	left.disabled = true
	_display_values(upgradable_stats[0], GameTracker.current_ship)


func _on_left_pressed() -> void:
	index = index - 1
	if 0 >= index:
		index = 0
		left.disabled = true
	else:
		left.disabled = false
	right.disabled = false
	buy.disabled = GameTracker.score_accumulated <= upgradable_stats[index].cost
	_display_values(upgradable_stats[index], GameTracker.current_ship)

func _on_buy_pressed() -> void:
	var upgrade: StatUpgrade = upgradable_stats[index]
	
	SignalHub.upgrade_bought.emit()
	GameTracker.upgrades_bought.append(upgrade.id)
	GameTracker.score_accumulated -= upgrade.cost
	Stat.get_update_stat(GameTracker.current_ship, upgrade.stat, upgrade.diff_value)
	_display_values(upgrade, GameTracker.current_ship)

func _on_right_pressed() -> void:
	index = index + 1
	if index >= upgradable_stats.size() - 1:
		index = upgradable_stats.size() - 1
		right.disabled = true
	else:
		right.disabled = false
	left.disabled = false
	buy.disabled = GameTracker.score_accumulated <= upgradable_stats[index].cost
	_display_values(upgradable_stats[index], GameTracker.current_ship)
