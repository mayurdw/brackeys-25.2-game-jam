extends Node

const obstacle_basic_score: int = 100
var score_accumulated: int = 10000
var upgrades_bought: Array[int]

var current_ship: BasicShip = preload("res://resources/gameplay_resources/basic_ship.tres")

func add_obstacle_encountered() -> void:
	score_accumulated += obstacle_basic_score
	SignalHub.score_updated.emit(obstacle_basic_score)
	SignalHub.current_score.emit(score_accumulated)

func obstacle_collided() -> void:
	add_obstacle_encountered()
	SignalHub.player_hit.emit()
