extends Node

var _number_of_obstacles_encountered: int = 0

signal player_hit

func add_obstacle_encountered() -> void:
	_number_of_obstacles_encountered = _number_of_obstacles_encountered + 1
	print("Number Of Obstacles Encountered = " + str(_number_of_obstacles_encountered))

func obstacle_collided() -> void:
	add_obstacle_encountered()
	player_hit.emit()
