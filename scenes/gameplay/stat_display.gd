extends HBoxContainer

class_name StatDisplay

@export var stat: Stat.Type

@onready var stat_name: Label = $"Stat Name"
@onready var progress_bar: ProgressBar = $ProgressBar
@onready var stat_value: Label = $"Stat Value"

func _ready() -> void:
	var value = Stat.get_stat_current_value(stat, GameTracker.current_ship)
	
	stat_name.text = Stat.get_stat_label(stat)
	progress_bar.max_value = Stat.get_max_value(stat)
	progress_bar.step = Stat.get_step_value(stat)
	update_value(value)

func update_value(value: float) -> void:
	progress_bar.value = value
	stat_value.text = str(int(value))
