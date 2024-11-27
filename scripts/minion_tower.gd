extends CharacterBody2D


var target : Node2D

var health = 10
var size = 1
var health_per_size_unit = 50

var move_speed = 200
var attack_proximity = 150
var can_attack : bool = true

@onready var minion_sprite = $Sprite
@onready var minion_collider = $CollisionShape2D

@onready var attack_timer : Timer = $AttackTimer
@onready var animation_player : AnimationPlayer = $AnimationPlayer

# TODO figure out how to properly initialize vars below
@onready var enemy_parent = $"../Enemies"
@onready var player = $"../Player"


func _ready() -> void:
	update_size()


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
	
	if direction.length() > attack_proximity: # TODO this'll be a problem the larger the minion is
		velocity = move_speed * direction.normalized()
		move_and_slide()
	elif can_attack:
		target.take_damage(10)
		can_attack = false
		
		animation_player.play('attack')
		attack_timer.start()


func _on_timer_timeout() -> void:
	can_attack = true


func feed_minion(amt):
	health += amt
	update_size()


func take_damage(amt):
	health -= amt
	if health <= 0:
		queue_free()
	
	update_size()


func update_size():
	var new_size = 1 + float(health) / health_per_size_unit
	
	minion_sprite.set_scale(Vector2(new_size, new_size))
	minion_collider.set_scale(Vector2(new_size, new_size))


func _on_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event.is_action_pressed('action') and player.get_pointing_to() == self:
		feed_minion(10)
