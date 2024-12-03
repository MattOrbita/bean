extends CharacterBody2D
var direction : Vector2 = Vector2.ZERO
var swing : bool = false
var speed = 300
@onready var animation_tree: AnimationTree = $AnimationTree
@onready var animation_mode = animation_tree.get("parameters/playback")
var destination : Vector2
var movement : Vector2
var moving = false
var stop = false
var attack = false

var current_target : Node2D

# new variables below
var hp:int = 1000
@onready var label = $Label
@onready var regen_timer = $RegenTimer #Stuff like this are temporary features to show and test how things work
signal health_changed(new_health) #we're getting fancy with godot features up in here. fun learning experience

func set_attack(value):
	if value:
		attack = true
	
	else:
		attack = false
		
func set_zone(value):
	if value:
		stop = true
	else:
		stop = false
	
	
		
	
#func set_target(node : Node2D):
	#current_target = node
	#
	##if current_target != null:
		##current_target.position

func _unhandled_input(_event: InputEvent) -> void:
	pass # click to move feature disabled to not interfere with tower placing
	#if Input.is_action_pressed("click"):
		#stop = false
		#moving = true
		#destination = get_global_mouse_position()
	
		
func _physics_process(_delta: float) -> void:
	direction = Input.get_vector("ui_left","ui_right","ui_up","ui_down")
	
	if direction:
		moving = false
		direction.normalized()
		velocity = direction * speed
		set_walking(true)
		update_blend_position()
		move_and_slide()
	elif moving == true and position.distance_to(destination) > 10:
		movement = position.direction_to(destination)
		movement.normalized()
		direction = movement * speed
		velocity = movement * speed
		set_walking(true)
		update_blend_position()
		move_and_slide()
	else:
		moving = false
		if attack and stop:
		
			get_attack(attack)
		else:
			set_walking(false)
			set_idle(true)
			
		

	


func _process(_delta: float) -> void:
	$Label.text = str(hp)

func set_walking(value):
	animation_tree["parameters/conditions/Walk"] = value
	animation_tree["parameters/conditions/Idle"] = not value
	animation_tree["parameters/conditions/Attack"] = not value

func set_idle(value):
	animation_tree["parameters/conditions/Walk"] = not value
	animation_tree["parameters/conditions/Idle"] = value
	animation_tree["parameters/conditions/Attack"] = not value
	
func get_attack(value):
	animation_tree["parameters/conditions/Walk"] = not value
	animation_tree["parameters/conditions/Idle"] = not value
	animation_tree["parameters/conditions/Attack"] = value
	
func update_blend_position():
	animation_tree["parameters/Idle/blend_position"] = direction.normalized()
	animation_tree["parameters/Walk/blend_position"] = direction.normalized() 
	animation_tree["parameters/Attack/blend_position"] = direction.normalized() 


# new functions below
func set_hp(amount:int):
	hp = amount


func resources():
	return hp


func _on_regen_timer_timeout() -> void:
	hp += 100
	health_changed.emit(hp)
