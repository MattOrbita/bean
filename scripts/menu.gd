extends Control


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass


func _on_play_pressed():
	get_tree().change_scene_to_file("res://scenes/sandbox.tscn")
	
	

func _on_options_pressed():
	#get_tree().change_scene_to_file("res://scenes/options_menu.tscn")
	$MarginContainer/VBoxContainer/Options.text = "Will be fixed later!"
	

func _on_tree_entered():
	BgMusicManager.change_song("res://Assets/Jazz Theme (192 kbps).mp3")


func _on_quit_pressed():
	get_tree().quit()
