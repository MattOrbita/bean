extends CharacterBody2D


@onready var player: CharacterBody2D = $"../player"

var in_zone = false
var attack = false


func _physics_process(delta: float) -> void:
	player.set_attack(attack)
	player.set_zone(in_zone)
	
func _on_area_2d_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event.is_action_pressed("click"):
		attack = true
		print(attack)
	

func _on_area_2d_area_entered(area: Area2D) -> void:
	in_zone = true
	print(in_zone)

func _on_area_2d_area_exited(area: Area2D) -> void:
	in_zone = false
	attack = false

	
