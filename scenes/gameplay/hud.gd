extends Control

@onready var danger_meter: ProgressBar = $"MarginContainer/Danger Meter/Danger Meter"
@onready var hp: ProgressBar = $"MarginContainer/Player Stats/HP"
@onready var fuel: ProgressBar = $"MarginContainer/Player Stats/Fuel"
@onready var credits_diff: Label = $"MarginContainer/Danger Meter/HBoxContainer/Credits Diff"
@onready var credits_value: Label = $"MarginContainer/Danger Meter/HBoxContainer/Credits Value"

func _ready() -> void:
	SignalHub.connect("score_updated", _score_updated)
	SignalHub.connect("current_score", _current_score)
	SignalHub.connect("current_hp", _current_hp)
	SignalHub.connect("current_fuel", _current_fuel)
	SignalHub.connect("current_danger_level", _danger_level)
	SignalHub.current_score.emit(GameTracker.score_accumulated)
	hp.max_value = GameTracker.current_ship.health_points
	fuel.max_value = GameTracker.current_ship.fuel_tank

func _danger_level(current_danger: float) -> void:
	danger_meter.value = current_danger

func _current_hp(current_hp: int) -> void:
	hp.value = current_hp

func _current_fuel(current_fuel: float) -> void:
	fuel.value = current_fuel

func _score_updated(score_diff: int) -> void:
	credits_diff.text = str(score_diff)

func _current_score(current_score: int) -> void:
	credits_value.text = "x " + str(current_score)
