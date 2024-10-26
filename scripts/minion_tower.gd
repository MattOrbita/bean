extends CharacterBody2D


var target : Node2D

var move_speed = 200
var attack_proximity = 150
var can_attack : bool = true

@onready var attack_timer : Timer = $AttackTimer
@onready var animation_player : AnimationPlayer = $AnimationPlayer

@onready var enemy_parent = $"../Enemies"


func _process(delta: float) -> void:
	target_nearest_enemy()
	pursue_target()


func target_nearest_enemy():
	if target == null and enemy_parent.get_child_count() > 0:
		var enemies = enemy_parent.get_children()
		
		target = enemies[0]
		var nearest_distance = (position - target.position).length()
		
		for i in range(1, len(enemies)):
			var distance = (position - enemies[i].position).length()
			
			if distance < nearest_distance:
				nearest_distance = distance
				target = enemies[i]


func pursue_target():
	if target == null:
		return
	
	var direction = target.position - position
	
	if direction.length() > attack_proximity:
		velocity = move_speed * direction.normalized()
		move_and_slide()
	elif can_attack:
		target.take_damage(10)
		can_attack = false
		
		animation_player.play('attack')
		attack_timer.start()


func _on_timer_timeout() -> void:
	can_attack = true
