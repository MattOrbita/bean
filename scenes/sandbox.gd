extends Node2D
@onready var player = $Player
@onready var walls_and_towers = $"Tiles/Walls and Towers"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_player_health_changed(new_health):
	walls_and_towers.set_resources(new_health)


func _on_walls_and_towers_resources_changed(resources):
	player.set_hp(resources)


func _on_tree_entered():
	BgMusicManager.change_song("res://Assets/Jazz Theme (192 kbps).mp3")
