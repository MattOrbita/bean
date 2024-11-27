extends CharacterBody2D

var move_speed = 500
@onready var label = $Label


func _process(delta: float) -> void:
	$Label.text = ""
	var direction = Input.get_vector('left', 'right', 'up', 'down')
	velocity = direction * move_speed
	move_and_slide()
	
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT) || Input.is_mouse_button_pressed(MOUSE_BUTTON_RIGHT):
		$Label.text = "Placing(Left-Click)/Deleting(Right-Click) Walls!"
		
	#Camera following mouse stuff
	var mouse_offset = (get_viewport().get_mouse_position() - Vector2(get_viewport().size) / 2)
	$PlayerCamera.position = lerp(Vector2(), mouse_offset.normalized() * 200, mouse_offset.length() / 1000)
	#print($PlayerCamera.position)
