extends Area2D

@export var drop_distance: float = 300.0  # Final Y position on screen
@export var drop_duration: float = 0.7

var player: Node2D = null
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	player = get_tree().get_first_node_in_group("Player")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass


func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		_trigger_drop()

func _trigger_drop() -> void:
	print("tiggered")
	$CollisionShape2D.set_deferred("disabled", true)
	
	var target_y = global_position.y + drop_distance
	var tween = create_tween()
	# Drop down
	tween.tween_property(self, "global_position:y", target_y, drop_duration)\
		.set_trans(Tween.TRANS_QUAD)\
		.set_ease(Tween.EASE_IN)
	
