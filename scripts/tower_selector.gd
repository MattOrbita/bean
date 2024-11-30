extends CanvasLayer


var selected_tower : PackedScene
var game_manager

var shooter_tower : PackedScene = preload("res://scenes/towers/air_control_tower.tscn")
var food_tower : PackedScene = preload("res://scenes/towers/feeding_tower.tscn")


func _ready() -> void:
	get_game_manager()
	connect_buttons()


func get_game_manager():
	var level_node = $"/root".get_child(0)
	game_manager = level_node.get_node("Game Manager")


# connects all buttons such that pressing ANY of them calls _on_button_pressed, AND
# initializes selected_tower to whichever button is already pressed in the beginning
func connect_buttons():
	for button in $Control/HBoxContainer/Towers.get_children():
		if button is Button:
			button.pressed.connect(_on_button_pressed.bind(button))
			
			# initializes selected_tower to whichever button is already pressed at the start
			if button.button_pressed:
				_on_button_pressed(button)


# toggles visibility of UI
func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("open_tower_selector"):
		visible = !visible


# updates what tower is to be placed when the player tries to place a tower,
# depending on which tower is selected in the UI
func _on_button_pressed(button: Button):
	var button_text = button.text
	
	if button_text == "Shooter Tower":
		selected_tower = shooter_tower
	elif button_text == "Food Tower":
		selected_tower = food_tower
	else:
		print("Button text not accounted for")
	
	game_manager.update_selected_tower(selected_tower)
