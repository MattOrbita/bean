extends CharacterBody2D


var explosion_sprite : Sprite2D
var damager_collider : CircleShape2D

var min_damage = 50
var max_damage = 150

var min_damage_distance = 149
var max_damage_distance

# To modify node according to current damage radius
var damage_radius_lerp = 0.0
var damage_radius_lerp_step = 0.1

var min_edge_distance = 472
var max_edge_distance = 653

var min_edge_damage = 150
var max_edge_damage = 200

var min_damage_radius = 404.06
var max_damage_radius = 585.25

var min_explosion_sprite_scale = Vector2(4.02, 4.02)
var max_explosion_sprite_scale = Vector2(5.84, 5.84)

var enemies_in_range = []

@onready var animation_player = $AnimationPlayer

# TODO figure out better way to get these references
@onready var player = $"../Player"


func _ready() -> void:
	explosion_sprite = $"Explosion Sprite"
	damager_collider = $"Enemy Damager/CollisionShape2D".shape
	
	explosion_sprite.scale = min_explosion_sprite_scale
	damager_collider.radius = min_damage_radius
	
	max_damage_distance = min_edge_distance
	max_damage = max_edge_damage


func _on_enemy_detector_body_entered(body: Node2D) -> void:
	if body not in enemies_in_range:
		enemies_in_range.append(body)
	
	animation_player.play("explode")
	
	for enemy in enemies_in_range:
		var distance = (position - enemy.position).length()
		var lerp = (distance - min_damage_distance) / (max_damage_distance - min_damage_distance)
		lerp = clamp(lerp, 0, 1)
		
		var damage = max_damage - (max_damage - min_damage) * lerp
		enemy.take_damage(damage)


func _on_enemy_damager_body_entered(body: Node2D) -> void:
	enemies_in_range.append(body)


func _on_enemy_damager_body_exited(body: Node2D) -> void:
	enemies_in_range.erase(body)


func _on_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event.is_action_pressed('action') and player.get_pointing_to() == self:
		damage_radius_lerp += damage_radius_lerp_step
		if damage_radius_lerp > 1:
			damage_radius_lerp = 1
		
		explosion_sprite.scale = min_explosion_sprite_scale + (max_explosion_sprite_scale - min_explosion_sprite_scale) * damage_radius_lerp
		damager_collider.radius = min_damage_radius + (max_damage_radius - min_damage_radius) * damage_radius_lerp
		
		max_damage_distance = min_edge_distance + (max_edge_distance - min_edge_distance) * damage_radius_lerp
		max_damage = min_edge_damage + (max_edge_damage - min_edge_damage) * damage_radius_lerp
