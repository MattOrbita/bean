extends CanvasLayer


var game_manager


func _ready() -> void:
	get_game_manager()
	connect_buttons()


func get_game_manager():
	var level_node = $"/root".get_child(0)
	game_manager = level_node.get_node("Game Manager")


# connects all buttons such that pressing ANY of them calls _on_button_pressed, AND
# initializes selected_tower to whichever button is already pressed in the beginning
func connect_buttons():
	for button in $Control/HBoxContainer.get_children():
		if button is Button:
			button.pressed.connect(_on_button_pressed.bind(button))
			
			# initializes selected_tower to whichever button is already pressed at the start
			if button.button_pressed:
				_on_button_pressed(button)


# updates what tower is to be placed when the player tries to place a tower,
# depending on which tower is selected in the UI
func _on_button_pressed(button: Button):
	game_manager.update_selected_tower(button)
