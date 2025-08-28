extends Area2D

const max_danger_level: float = 10.0

var danger_level: float = 10.0
var is_in_danger: bool = false

@onready var timer: Timer = $Timer

func _ready() -> void:
	timer.start()
	SignalHub.current_danger_level.emit(max_danger_level)
	is_in_danger = true

func _process(delta: float) -> void:
	if not is_in_danger:
		danger_level = danger_level - delta
		SignalHub.current_danger_level.emit(danger_level)

func _on_area_entered(_area: Area2D) -> void:
	timer.stop()
	is_in_danger = true
	danger_level = max_danger_level
	SignalHub.current_danger_level.emit(danger_level)
	GameTracker.add_obstacle_encountered()


func _on_area_exited(area: Area2D) -> void:
	timer.start()

func _on_timer_timeout() -> void:
	is_in_danger = false
