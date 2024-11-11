extends StaticBody2D


var target : Node2D
var can_shoot = true

@onready var shoot_timer = $"Shoot Delay"
var missile_prefab = preload("res://scenes/missile.tscn")

# TODO figure out how to properly initialize vars below
@onready var enemy_parent = $"../Enemies"
@onready var missile_parent = $"../Missiles"


func _ready() -> void:
	pass


func _process(delta: float) -> void:
	target_nearest_enemy()
	face_target()
	shoot_target()


func target_nearest_enemy(): # TODO calling this every frame could prove overly performance intensive
	if enemy_parent.get_child_count() > 0:
		var enemies = enemy_parent.get_children()
		
		var new_target = enemies[0]
		var nearest_distance = (position - new_target.position).length()
		
		for i in range(1, len(enemies)):
			var distance = (position - enemies[i].position).length()
			
			if distance < nearest_distance:
				nearest_distance = distance
				new_target = enemies[i]
		
		target = new_target


func face_target():
	look_at(target.position)


func shoot_target():
	if can_shoot and target != null:
		can_shoot = false
		
		var missile : Node2D = missile_prefab.instantiate()
		missile_parent.add_child(missile)
		
		missile.global_position = global_position
		missile.target = target
		
		shoot_timer.start()


func _on_shoot_delay_timeout() -> void:
	can_shoot = true
