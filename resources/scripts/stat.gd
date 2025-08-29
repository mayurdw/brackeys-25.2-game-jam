extends Resource

class_name Stat

enum Type {
	SPEED,
	ENGINE_POWER,
	FRICTION,
	HEALTH,
	FUEL,
	FUEL_DEPLETION
}

static func get_update_stat(ship: BasicShip, stat: Stat.Type, diff_value: float) -> BasicShip:
	match stat:
		Type.SPEED:
			ship.max_speed = ship.max_speed + diff_value
		Type.ENGINE_POWER:
			ship.engine_power = ship.engine_power + diff_value
		Type.HEALTH:
			ship.health_points = ship.health_points + diff_value
		Type.FUEL:
			ship.fuel_tank = ship.fuel_tank + diff_value
		Type.FRICTION:
			ship.friction = ship.friction - diff_value
		Type.FUEL_DEPLETION:
			ship.fuel_depletion_rate = ship.fuel_depletion_rate - diff_value
	return ship

static func get_stat_label(stat: Stat.Type) -> String:
	match stat:
		Type.SPEED:
			return "Speed"
		Type.ENGINE_POWER:
			return "Engine Power"
		Type.HEALTH:
			return "Health"
		Type.FUEL:
			return "Fuel Tank"
		Type.FRICTION:
			return "Gravity Drag"
		Type.FUEL_DEPLETION:
			return "Fuel Consumption"
	return ""

static func get_max_value(stat: Stat.Type) -> float:
	match stat:
		Type.SPEED:
			return 800.0
		Type.ENGINE_POWER:
			return 1000.0
		Type.FRICTION:
			return 2.0
		Type.HEALTH:
			return 50.0
		Type.FUEL:
			return 200.0
		Type.FUEL_DEPLETION:
			return 10.0
	return 0.0

static func get_step_value(stat: Stat.Type) -> float:
	match stat:
		Type.SPEED:
			return 100.0
		Type.ENGINE_POWER:
			return 100.0
		Type.FRICTION:
			return 0.01
		Type.HEALTH:
			return 1.0
		Type.FUEL:
			return 10.0
		Type.FUEL_DEPLETION:
			return 1.0
	return 0.0

static func get_stat_current_value(stat: Stat.Type, ship: BasicShip) -> float:
	match stat:
		Type.SPEED:
			return ship.max_speed
		Type.ENGINE_POWER:
			return ship.engine_power
		Type.FRICTION:
			return ship.friction
		Type.HEALTH:
			return ship.health_points
		Type.FUEL:
			return ship.fuel_tank
		Type.FUEL_DEPLETION:
			return ship.fuel_depletion_rate
	return 0.0
