extends StaticBody2D

#@export_range(0, 0, 1, "or_greater") var padding: int = 0
#@export_range(1, 10, 1) var num_backgrounds : int = 4
@export_group("Level Offsets")
@export var left_offset: float = -618.0
@export var top_offset: float = -150.0
@export_range(1, 10, 1) var num_backgrounds: int = 4

@export_group("Per-Side Padding")
@export var padding_left: float = 0.0
@export var padding_right: float = 0.0
@export var padding_top: float = 0.0
@export var padding_bottom: float = 0.0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	get_window().size_changed.connect(resize)
	resize()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

func resize():
	var size := get_viewport_rect().size
	#for n in get_children():
		#remove_child(n)
		#n.queue_free()
	
	# Calculate exact wall positions
	var left_x = left_offset + padding_left
	var right_x = (left_offset + 300) + (size.x * num_backgrounds) - padding_right
	var top_y = top_offset + padding_top
	var bottom_y = size.y - padding_bottom
	#for bound in [
		#[Vector2(1, 0), -618 + padding],
		#[Vector2(-1, 0), -size.x * num_backgrounds + padding],
		#[Vector2(0, 1), -150 + padding],
		#[Vector2(0, -1), -size.y + padding],
	#]:
	var bounds = [
		[Vector2(1, 0), left_x],        # Left Wall
		[Vector2(-1, 0), -right_x],     # Right Wall
		[Vector2(0, 1), top_y],         # Top Wall
		[Vector2(0, -1), -bottom_y]     # Bottom Wall
	]

	for bound in bounds:
		var shape := WorldBoundaryShape2D.new()
		shape.normal = bound[0]
		shape.distance = bound[1]
		var collision_shape := CollisionShape2D.new()
		collision_shape.shape = shape
		add_child(collision_shape)
