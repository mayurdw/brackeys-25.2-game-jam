extends Area2D


func _on_body_entered(body: Node2D) -> void:
	print("Body Entered = " + str(body))


func _on_body_exited(body: Node2D) -> void:
	print("Body Exited = " + str(body))
