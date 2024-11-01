extends Area2D


var enemies = []


func _on_body_entered(body: Node2D) -> void:
	enemies.append(body)
	body.make_slow()


func _on_body_exited(body: Node2D) -> void:
	body.make_fast()
	enemies.erase(body)
