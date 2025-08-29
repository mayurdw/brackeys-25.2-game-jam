extends Resource

class_name Stat

enum Type {
	SPEED,
	ACCELERATION,
	FRICTION,
	HEALTH,
	FUEL,
	FUEL_DEPLETION
}

static func get_update_stat(ship: BasicShip, stat: Stat.Type, diff_value: float) -> BasicShip:
	match stat:
		Type.SPEED:
			ship.max_speed = ship.max_speed + diff_value
		Type.ACCELERATION:
			ship.accelaration = ship.accelaration + diff_value
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
		Type.ACCELERATION:
			return "Accelaration"
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
		Type.ACCELERATION:
			return 150.0
		Type.FRICTION:
			return 20.0
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
		Type.ACCELERATION:
			return 30.0
		Type.FRICTION:
			return 1.0
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
		Type.ACCELERATION:
			return ship.accelaration
		Type.FRICTION:
			return ship.friction
		Type.HEALTH:
			return ship.health_points
		Type.FUEL:
			return ship.fuel_tank
		Type.FUEL_DEPLETION:
			return ship.fuel_depletion_rate
	return 0.0
