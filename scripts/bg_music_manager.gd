extends Node #This is a little fun thing from a personal project of mine! I'll reuse it here for us to have music

@onready var bgm = $BGM
#I could better manage the vars lol i put it here out of laziness
#var personal_best:int = 0
var game_is_over := false
var queued_song := ""
var song_queued := false
@onready var song_timer = $BGM/SongTimer #Am I getting needlessly complicated


# Called when the node enters the scene tree for the first time.
func _ready():
	#bgm.set_stream(load("res://Assets/Jazz Theme (192 kbps).mp3"))
	bgm.play()
	#current_song.play()

func change_song(song):
	if bgm == null: #check for null before use
		push_error("BGM node not found!")
		return
	var new_stream = load(song)
	if new_stream != bgm.stream:
		bgm.set_stream(new_stream)
		song_timer.set_wait_time(bgm.stream.get_length())
		song_timer.start()
		bgm.play()

		
		
func next_song(song):
	song_queued = true
	queued_song = song
		
func stop_song():
	bgm.stop()

#Below is personal game stuff 

#func start_game():
	#game_is_over = false
	#
#func game_over(type:int):
	#if not game_is_over:
		#game_is_over = true
		#change_song("res://assets/GTA V Wasted-Busted - Sound Effect (HD) 192k.mp3")
		#if type == 0:
			#next_song("res://assets/lose theme _ Splatoon soundtrack 192k.mp3")
		#else:
			#next_song("res://assets/Game Over - Friday Night Funkin' OST.mp3")
			


	
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(_delta):
	#print($BGM.is_playing())
	##if current_scene_name == "menu" or current_scene_name == "options_menu":
		##bgm.set_stream(load("res://assets/AQUARIUM CITY 192k.mp3"))
	##elif current_scene_name == "game":
		##bgm.set_stream(load("res://assets/Wii Play - Fishing Theme 192k.mp3"))
	 



func _on_song_timer_timeout():
	if song_queued:
		change_song(queued_song)
		song_queued = false
