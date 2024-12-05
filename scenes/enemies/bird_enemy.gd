extends CharacterBody2D

const base_speed = 100
const base_damage = 20
const base_health = 50
var health = base_health
var targets = []
var attack_cooldown = true

@export var player: Node2D
@onready var nav_agent := $NavigationAgent2D as NavigationAgent2D

#flag showing this is an enemy to all towers/players
func enemy():
	pass

func _ready() -> void:
	pass

func _physics_process(_delta: float) -> void:
	move_and_slide()
	if !targets.is_empty() and attack_cooldown:
		attack()

func attack():
	attack_cooldown = false
	$AttackCooldown.start()
	for body in targets:
		body.take_damage(base_damage)

func take_damage(damage: int):
	health -= damage
	if health <= 0:
		death()

func death():
	pass


#makes a new path every .2 seconds
func _on_path_timer_timeout() -> void:
	var target = player.global_position
	var dir = (target - position).normalized()
	velocity = dir * base_speed

#keep track of what attackable targets are in range by storing them in an array
func _on_attack_area_body_entered(body: Node2D) -> void:
	if body != null:
		if body.has_method("player") or body.has_method("tower") or body.has_method("wall"):
			targets.append(body)

# removes any attackable targets from array when they leave the attack area
func _on_attack_area_body_shape_exited(body_rid: RID, body: Node2D, body_shape_index: int, local_shape_index: int) -> void:
	if body != null:
		if body.has_method("player") or body.has_method("tower") or body.has_method("wall"):
			targets.erase(body)

func _on_attack_cooldown_timeout() -> void:
	print("attack cd")
	attack_cooldown = true
