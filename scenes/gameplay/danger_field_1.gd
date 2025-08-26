extends Area2D


func _on_area_entered(area: Area2D) -> void:
	print("Area Exited = " + str(area))
	GameTracker.add_obstacle_encountered()


func _on_area_exited(area: Area2D) -> void:
	print("Area Exited = " + str(area))
