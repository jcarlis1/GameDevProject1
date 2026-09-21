extends StaticBody2D

@export_range(0, 0, 1, "or_greater") var padding: int = 0
@export_range(1, 10, 1) var num_backgrounds : int = 4

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	get_window().size_changed.connect(resize)
	resize()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func resize():
	var size := get_viewport_rect().size
	for n in get_children():
		remove_child(n)
		n.queue_free()
	
	for bound in [
		[Vector2(1, 0), -618 + padding],
		[Vector2(-1, 0), -size.x * num_backgrounds + padding],
		[Vector2(0, 1), -150 + padding],
		[Vector2(0, -1), -size.y + padding],
	]:
		var shape := WorldBoundaryShape2D.new()
		shape.normal = bound[0]
		shape.distance = bound[1]
		var collision_shape := CollisionShape2D.new()
		collision_shape.shape = shape
		add_child(collision_shape)
