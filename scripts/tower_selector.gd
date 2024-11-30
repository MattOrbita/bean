extends CanvasLayer


func _ready() -> void:
	connect_buttons()


# connects all buttons such that pressing ANY of them calls _on_button_pressed
func connect_buttons():
	for button in $Control/HBoxContainer/Towers.get_children():
		if button is Button:
			button.pressed.connect(_on_button_pressed.bind(button))


# toggles visibility of UI
func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("open_tower_selector"):
		visible = !visible


func _on_button_pressed(button: Button):
	print(button.text)
