extends Control

@onready var bgm_vol_box = $MarginContainer/VBoxContainer/BGMVolBox
@onready var sfx_vol_box = $MarginContainer/VBoxContainer/SFXVolBox
@onready var bgm_vol = $MarginContainer/VBoxContainer/BGMVolBox/BGMVol
@onready var sfx_vol = $MarginContainer/VBoxContainer/SFXVolBox/SFXVol
var bgm_bus = AudioServer.get_bus_index("BGM")
var sfx_bus = AudioServer.get_bus_index("SFX")
#@onready var button_pop = $ButtonPop

# Called when the node enters the scene tree for the first time.
func _ready():
	var bgm_bus_volume = db_to_linear(AudioServer.get_bus_volume_db(bgm_bus))
	bgm_vol_box.text = "Music Volume: " + str(bgm_bus_volume * 100) + "%"
	bgm_vol.value = bgm_bus_volume
	var sfx_bus_volume = db_to_linear(AudioServer.get_bus_volume_db(sfx_bus))
	sfx_vol_box.text = "SFX Volume: " + str(sfx_bus_volume * 100) + "%"
	sfx_vol.value = sfx_bus_volume


#func pop():
	#button_pop.play()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass


func _on_play_pressed():
	#pop()
	get_tree().change_scene_to_file("res://scenes/sandbox.tscn")



func _on_back_pressed():
	#pop()
	get_tree().change_scene_to_file("res://scenes/menu.tscn")


#func _on_tree_entered():
	#$"/root/BgMusicManager".change_song("res://assets/Breakfast (Pause Menu) - Friday Night Funkin' OST 192k.mp3")


func _on_bgm_vol_value_changed(value):
	bgm_vol_box.text = "Music Volume: " + str(bgm_vol.value * 100) + "%"
	AudioServer.set_bus_volume_db(bgm_bus, linear_to_db(value))


func _on_sfx_vol_value_changed(value):
	#sfx_vol_box.text = "SFX Volume: " + str(sfx_vol.value * 100) + "%"
	sfx_vol_box.text = "The game doesn't have SFX at the moment..."
	AudioServer.set_bus_volume_db(sfx_bus, linear_to_db(value))
	


#func _on_sfx_vol_drag_ended(value_changed):
	#pop()


func _on_tree_entered():
	pass # Replace with function body.
