extends CharacterBody2D


@onready var player = $"../player"


func _on_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event.is_action_pressed("click"):
		player.set_target(self)
