extends StaticBody2D

var food_restored_per_cycle = 50
var current_food_amount = 0
var restore_food_continuously = false

var cooldown = 5
var cooldown_timer = 0

@onready var sprite_with_food = $"Sprite W Food"
@onready var sprite_without_food = $"Sprite No Food"

var game_manager
var player : Node2D = null


func _ready():
	get_game_manager()
	
	sprite_with_food.visible = false
	sprite_without_food.visible = true


func get_game_manager():
	var level_node = $"/root".get_child(0)
	game_manager = level_node.get_node("Game Manager")


func _process(delta: float) -> void:
	find_player()
	perform_countdown(delta)


func find_player():
	if player != null:
		return
	
	if game_manager.player != null:
		player = game_manager.player


func perform_countdown(delta):
	cooldown_timer += delta

	if cooldown_timer >= cooldown:
		if restore_food_continuously:
			current_food_amount += food_restored_per_cycle
		else:
			current_food_amount = food_restored_per_cycle
		
		print("New food amount = " + str(current_food_amount)) # TODO DELETE

		sprite_with_food.visible = true
		sprite_without_food.visible = false

		cooldown_timer = 0


func _on_pick_up_trigger_body_entered(body:Node2D) -> void:
	if player == null or body != player:
		return
	
	print("Replenished " + str(current_food_amount) + " food") # TODO DELETE

	current_food_amount = 0
	cooldown_timer = 0

	sprite_with_food.visible = false
	sprite_without_food.visible = true
