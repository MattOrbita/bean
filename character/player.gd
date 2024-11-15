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

var current_target : Node2D


func set_target(node : Node2D):
	current_target = node
	
	#if current_target != null:
		#current_target.position



func _unhandled_input(_event: InputEvent) -> void:
	if Input.is_action_pressed("click"):
		if current_target != null:
			destination = current_target.position
		else:
			destination = get_global_mouse_position()
		moving = true
		current_target = null
		
func _physics_process(_delta: float) -> void:
	direction = Input.get_vector("ui_left","ui_right","ui_up","ui_down")
	if direction:
		moving = false
		
		direction.normalized()
		velocity = direction * speed
		set_walking(true)
		update_blend_position()
		move_and_slide()
	else:
		set_walking(false)
		if moving == true and position.distance_to(destination) > 10:
			movement = position.direction_to(destination)
			direction = movement * speed
			velocity = movement * speed
			set_walking(true)
			update_blend_position()
			move_and_slide()
			
		else:
			
			set_walking(false)
			moving = false
		

func _process(_delta: float) -> void:
	pass
func set_walking(value):
	animation_tree["parameters/conditions/Walk"] = value
	animation_tree["parameters/conditions/Idle"] = not value

func update_blend_position():
	animation_tree["parameters/Idle/blend_position"] = direction.normalized()
	animation_tree["parameters/Walk/blend_position"] = direction.normalized() 
	


#
#
#func _on_area_2d_body_exited(body: Node2D) -> void:
	#if body.name == "enermy":
		#stop = false
