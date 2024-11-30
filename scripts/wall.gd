class_name Wall extends StaticBody2D

@onready var animation_player = $AnimationPlayer
@onready var sprite_2d = $Sprite2D
@onready var label = $Label

var hp:int = 100

var has_mouse:bool = false

# Called when the node enters the scene tree for the first time.
func _ready():
	print("wall placed!")
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	$Label.text = str(hp)
	if hp <= 0:
		destroyed()
	pass
	
func destroyed():
	print("wall destroyed!")
	queue_free()
	
func hit():
	hp -= 10
	
func remaining_hp_proportion():
	return float(hp)/100.0
	
