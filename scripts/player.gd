extends CharacterBody2D

var targets = []
var attack_cooldown = true
var player_alive = true
var move_speed = 500
var hp:int = 1000
@onready var label = $Label
@onready var regen_timer = $RegenTimer #Stuff like this are temporary features to show and test how things work
signal health_changed(new_health) #we're getting fancy with godot features up in here. fun learning experience

#shows enemies that this is a player
func player():
	pass

func _process(delta: float) -> void:
	$Label.text = str(hp)
	var direction = Input.get_vector('left', 'right', 'up', 'down')
	velocity = direction * move_speed
	move_and_slide() #leads to a fun unintended feature where "sitting" on the enemy makes you ride them
	
	#if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT) || Input.is_mouse_button_pressed(MOUSE_BUTTON_RIGHT):
		#$Label.text = "Placing(Left-Click)/Deleting(Right-Click) Walls!"
		
	#Camera following mouse stuff
	var mouse_offset = (get_viewport().get_mouse_position() - Vector2(get_viewport().size) / 2)
	$PlayerCamera.position = lerp(Vector2(), mouse_offset.normalized() * 200, mouse_offset.length() / 1000)
	#print($PlayerCamera.position)

func set_hp(amount:int):
	hp = amount

func resources():
	return hp


func _on_regen_timer_timeout():
	hp += 100
	health_changed.emit(hp)
	
func attack():
	attack_cooldown = false
	$AttackCooldown.start()
	
func take_damage(damage):
	hp -= damage
	#print(hp)

func _on_attack_area_body_entered(body: Node2D) -> void:
	if body.has_method("enemy"):
		targets.append(body)


func _on_attack_area_body_exited(body: Node2D) -> void:
	if body.has_method("enemy"):
		targets.erase(body)

func _on_attack_cooldown_timeout() -> void:
	attack_cooldown = true
	
func increase_hp(health:int):
	hp+=health
