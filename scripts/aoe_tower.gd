extends CharacterBody2D


var min_damage = 50
var max_damage = 150

var min_distance = 149
var max_distance = 472

var enemies_in_range = []

@onready var animation_player = $AnimationPlayer


func _on_enemy_detector_body_entered(body: Node2D) -> void:
	if body not in enemies_in_range:
		enemies_in_range.append(body)
	
	animation_player.play("explode")
	
	for enemy in enemies_in_range:
		var distance = (position - enemy.position).length()
		var lerp = (distance - min_distance) / (max_distance - min_distance)
		lerp = clamp(lerp, 0, 1)
		
		var damage = max_damage - (max_damage - min_damage) * lerp
		enemy.take_damage(damage)


func _on_enemy_damager_body_entered(body: Node2D) -> void:
	enemies_in_range.append(body)


func _on_enemy_damager_body_exited(body: Node2D) -> void:
	enemies_in_range.erase(body)
