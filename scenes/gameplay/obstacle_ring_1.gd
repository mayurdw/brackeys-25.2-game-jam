extends Area2D

func _on_body_entered(body: Node2D) -> void:
	print("Obstacle Ring, Body Entered = " + str(body))


func _on_body_exited(body: Node2D) -> void:
	print("Obstacle Ring, Body Exited = " + str(body))
