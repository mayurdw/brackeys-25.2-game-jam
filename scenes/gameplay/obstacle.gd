extends Area2D


func _on_body_entered(body: Node2D) -> void:
	GameTracker.obstacle_collided()


func _on_body_exited(body: Node2D) -> void:
	pass
