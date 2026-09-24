extends Area2D

@export var drop_distance: float = 200.0  # Final Y position on screen
@export var drop_duration: float = 0.6 # How long the move takes in seconds
@export var trigger_distance: float = 275.0

# Scooping settings
@export var scoop_angle: float = 90.0    # Degrees to rotate during the scoop arc
@export var scoop_duration: float = 0.4 # Speed of the scoop swing
@export var pause_before_retract: float = 0.3 # Brief pause before pulling up
@export var retract_duration: float = 0.8     # Speed of pulling back up

@onready var net : AudioStreamPlayer = $AudioStreamPlayer

var player: Node2D = null
var has_dropped: bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	player = get_tree().get_first_node_in_group("Player")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	# Ignore process if already dropped or if player is missing
	if has_dropped or not is_instance_valid(player):
		return
		
	var dist_to_player: float = global_position.distance_to(player.global_position)

	if dist_to_player <= trigger_distance:
		has_dropped = true # Lock to prevent repeated triggers
		start_drop_and_scoop()


func start_drop_and_scoop() -> void:
	var start_pos: Vector2 = global_position
	net.play()
	# set_parallel(false) ensures steps run sequentially (Drop -> Scoop -> Return)
	var tween = create_tween().set_parallel(false)
	
	# Step 1: Drop down into position
	var target_y = global_position.y + drop_distance
	tween.tween_property(self, "global_position:y", target_y, drop_duration)\
		.set_trans(Tween.TRANS_CUBIC)\
		.set_ease(Tween.EASE_OUT)
	
	# Step 2: Swift scoop rotation arc
	tween.tween_property(self, "rotation_degrees", scoop_angle, scoop_duration)\
		.set_trans(Tween.TRANS_QUAD)\
		.set_ease(Tween.EASE_IN)
		
	# Step 3: Return rotation back to normal (0 degrees)
	tween.tween_property(self, "rotation_degrees", 0.0, scoop_duration * 1.5)\
		.set_trans(Tween.TRANS_CUBIC)\
		.set_ease(Tween.EASE_OUT)

		# Step 4: Optional pause before retracting
	if pause_before_retract > 0.0:
		tween.tween_interval(pause_before_retract)

	# Step 5: Retract back up to original start position
	tween.tween_property(self, "global_position", start_pos, retract_duration)\
		.set_trans(Tween.TRANS_CUBIC)\
		.set_ease(Tween.EASE_IN_OUT)

	tween.tween_callback(func(): has_dropped = false)


func _on_body_entered(body: Node2D) -> void:
	if not body.is_in_group("Player"):
		return
	body.take_damage(3)
