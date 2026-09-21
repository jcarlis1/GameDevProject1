extends CharacterBody2D

const speed = 80.0
var player: Node2D = null
var damage : int = 3

func _ready() -> void:
	player = get_tree().get_first_node_in_group("Player")
	
	if is_instance_valid(player):
		global_position = player.global_position - Vector2(500, 0)
		

func _physics_process(delta: float) -> void:
	if is_instance_valid(player):
		# Recalculates direction to player every frame, updating Y movement dynamically
		var move_direction = (player.global_position - global_position).normalized()
		velocity = move_direction * speed
	move_and_slide()
