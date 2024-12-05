extends Node
var rng = RandomNumberGenerator.new()
var standby: bool #inbetween end of prev wave and start of next wave
var wave_number: int #current wave number
var enemy_number: int #amount of enemies to be spawned this wave
var max_enemy: int #max enemies allowed on the screen
var enemies_left: int #enemies left to spawn
var default_node_count: int #keeps track of default starting number of children nodes
var current_node_count: int #current num of children nodes
var spawn_points: Array

@export var basic_enemy_scene: PackedScene
@export var bird_enemy_scene: PackedScene
@export var player: Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	wave_number = 0
	enemy_number = 3
	max_enemy = 10
	standby = true
	default_node_count = get_child_count()
	current_node_count = get_child_count()
	_get_spawn_points()
	$standbyTimer.start()
	
	
func _get_spawn_points() -> void:
	spawn_points.append($spawn_points/spawn_point1)
	spawn_points.append($spawn_points/spawn_point2)
	spawn_points.append($spawn_points/spawn_point3)
	spawn_points.append($spawn_points/spawn_point4)
	spawn_points.append($spawn_points/spawn_point5)
	spawn_points.append($spawn_points/spawn_point6)
	spawn_points.append($spawn_points/spawn_point7)
	spawn_points.append($spawn_points/spawn_point8)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if (!standby):
		current_node_count = get_child_count()
		if (enemies_left <= 0 and (current_node_count-default_node_count) <= 0):
			standby = true
			print("all enemies dead")
			$standbyTimer.start()
		while ((current_node_count-default_node_count) < max_enemy and enemies_left > 0):
			_generate_enemy()

func get_player() -> Node2D:
	return player

func _generate_enemy() -> void:
	enemies_left -= 1
	var new_enemy
	var enemy_type = 0
	if wave_number >= 4:
		enemy_type = rng.randf_range(0, 1)
	var spawn_point = spawn_points[rng.randf_range(0, 7)]
	if enemy_type == 1:
		new_enemy = bird_enemy_scene.instantiate()
		new_enemy.global_position = spawn_point.global_position
		add_child(new_enemy)
	else:
		new_enemy = basic_enemy_scene.instantiate()
		new_enemy.global_position = spawn_point.global_position
		add_child(new_enemy)
	
	

func get_wave() -> int:
	return wave_number

func _on_standby_timer_timeout() -> void:
	print("standby over")
	_new_wave()
	
	
func _new_wave():
	wave_number+=1
	print("new wave:" + str(wave_number))
	if enemy_number < 200 :
		if (wave_number >= 10):
			enemy_number += rng.randf_range(0, 10)
		else:
			enemy_number += wave_number
	if (max_enemy < 40 and wave_number % 5 == 0):
		max_enemy += 5
	enemies_left = enemy_number
	standby = false
	
