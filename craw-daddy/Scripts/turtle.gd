extends Area2D

@onready var anim : AnimationPlayer = $AnimationPlayer
@export var trigger_distance: float = 130.0

var player: Node2D = null

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	player = get_tree().get_first_node_in_group("Player")
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if not is_instance_valid(player):
		return
		
	# Calculate distance in pixels to player every frame
	var dist_to_player: float = global_position.distance_to(player.global_position)

	if dist_to_player <= trigger_distance:
		# Only trigger play() if not already playing to prevent restarting every frame
		if anim.current_animation != "attack":
			anim.play("attack")
	else:
		if anim.current_animation != "waiting":
			anim.play("waiting")
	

func _on_body_entered(body: Node2D) -> void:
	if not body.is_in_group("Player"):
		return
	body.take_damage(1)
