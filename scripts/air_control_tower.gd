extends StaticBody2D


var target : Node2D
var can_shoot = true
var can_feed = true

var shoot_delay_step = 0.5
var max_shoot_delay = 5
var min_shoot_delay = 1

@onready var shoot_timer = $"Shoot Delay"
@onready var animation_player = $AnimationPlayer

var missile_prefab = preload("res://scenes/missile.tscn")

# TODO figure out how to properly initialize vars below
@onready var enemy_parent = $"../Enemies"
@onready var missile_parent = $"../Missiles"
@onready var player = $"../Player"


func _ready() -> void:
	shoot_timer.wait_time = max_shoot_delay


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
	if target != null:
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


func _on_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event.is_action_pressed('action') and player.get_pointing_to() == self:
		feed_minion()

func feed_minion():
	# if fed the maximum amount, then don't allow further feeding
	if shoot_timer.wait_time == min_shoot_delay:
		return
	
	# if feeding animation is still playing, also don't allow feeding just yet
	if !can_feed:
		return
	
	# play feeding animation
	animation_player.play("feed")
	can_feed = false
	
	# decrease the shoot delay, ensuring it doesn't dip below the minimum required delay
	shoot_timer.wait_time -= shoot_delay_step
	if shoot_timer.wait_time < min_shoot_delay:
		shoot_timer.wait_time = min_shoot_delay


func allow_feeding():
	can_feed = true
