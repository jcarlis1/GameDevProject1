extends Node2D

@export var enemy_scene: PackedScene
@export var spawn_margin: float = 100.0

var player: Node2D = null

func _ready() -> void:
	# Find the player in the scene
	player = get_tree().get_first_node_in_group("Player")

# Connect the Timer's "timeout()" signal to this function in the Inspector
func _on_timer_timeout() -> void:
	#if not enemy_scene or not player:
		#return
#
	## Calculate spawn position
	#var viewport_width = get_viewport_rect().size.x
	#var distance_offscreen = (viewport_width / 2.0) + spawn_margin
	#
	## Determine forward direction (based on rotation or velocity)
	#var forward_direction = Vector2.RIGHT.rotated(player.global_rotation)
	#var spawn_position = player.global_position + (forward_direction * distance_offscreen)
#
	## Instantiate and place in the world
	#var enemy = enemy_scene.instantiate() as Node2D
	#enemy.global_position = spawn_position
	#
	## Add the enemy as a child of the Main scene so it moves independently
	#get_tree().current_scene.add_child(enemy)
	
	if not is_instance_valid(player) or not enemy_scene:
		return

	# Determine forward direction using movement velocity
	var forward_direction: Vector2 = Vector2.RIGHT # Fallback default
	
	if player.get("velocity") != null and player.velocity.length() > 10.0:
		# Spawns ahead of where the player is currently walking
		forward_direction = player.velocity.normalized()
	else:
		# Fallback to rotation if standing still
		forward_direction = Vector2.RIGHT.rotated(player.global_rotation)

	# Calculate offscreen spawn position
	var viewport_width = get_viewport_rect().size.x
	var distance_offscreen = (viewport_width / 2.0) + spawn_margin
	var spawn_position = player.global_position + (forward_direction * distance_offscreen)

	var enemy = enemy_scene.instantiate() as Node2D
	enemy.global_position = spawn_position
	get_tree().current_scene.add_child(enemy)
