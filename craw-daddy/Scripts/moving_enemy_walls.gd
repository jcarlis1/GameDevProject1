extends CharacterBody2D

@export var speed: float = 150.0
@export var damage: int = 1
@export var textures: Array[Texture2D] = []

@onready var sprite: Sprite2D = $Sprite2D
@onready var collision_shape: CollisionShape2D = $Collision_Walls
@onready var hitbox_shape: CollisionShape2D = $Hitbox/Collision_Player

var player: Node2D = null
var original_direction: Vector2 = Vector2.ZERO
var move_direction: Vector2 = Vector2.ZERO
var has_entered_screen: bool = false
var is_diverting: bool = false

func _ready() -> void:
	player = get_tree().get_first_node_in_group("Player")
	if player:
		move_direction = (player.global_position - global_position).normalized()
		move_direction = original_direction
	# Pick random image and set wall-collision size dynamically
	if not textures.is_empty():
		sprite.texture = textures.pick_random()
		var texture_size = sprite.texture.get_size()
		
		var rect = RectangleShape2D.new()
		rect.size = sprite.texture.get_size()
		hitbox_shape.shape = rect
		
		var wall_rect = RectangleShape2D.new()
		wall_rect.size = texture_size * 0.7  
		collision_shape.shape = wall_rect

func _physics_process(_delta: float) -> void:
	#if move_direction != Vector2.ZERO:
		#velocity = move_direction * speed
		#move_and_slide()
	if original_direction == Vector2.ZERO:
		if not is_instance_valid(player):
			player = get_tree().get_first_node_in_group("Player")
		if is_instance_valid(player):
			original_direction = (player.global_position - global_position).normalized()
		else:
			return
		# Bounce in the opposite direction of the wall normal
		if is_on_wall():
			#if is_instance_valid(player):
				#if player.global_position.y < global_position.y:
					#move_direction = Vector2.UP
				#else:
					#move_direction = Vector2.DOWN
			#else:
				## Fallback if player is missing: pick UP or DOWN randomly
				#move_direction = Vector2.UP if randf() > 0.5 else Vector2.DOWN
			if not is_diverting:
				is_diverting = true
				var collision = get_last_slide_collision()
				if collision:
					var normal = collision.get_normal()
				
				# Hitting a vertical wall (left or right side)
					if abs(normal.x) > 0.5:
						if is_instance_valid(player) and player.global_position.y < global_position.y:
							move_direction = Vector2.UP
						else:
							move_direction = Vector2.DOWN
				# Hitting a horizontal wall (top or bottom side)
				else:
					if is_instance_valid(player) and player.global_position.x < global_position.x:
						move_direction = Vector2.LEFT
					else:
						move_direction = Vector2.RIGHT
		else:
		# Once the enemy moves past the wall edge, clear the flag and resume path
			if is_diverting:
				is_diverting = false
			move_direction = original_direction

	velocity = move_direction * speed
	move_and_slide()
# Triggered when a body enters the child Hitbox (Area2D)
func _on_hitbox_body_entered(body: Node2D) -> void:
	if not body.is_in_group("Player"):
		return
	
	body.take_damage(damage)
	queue_free()


func _on_visible_on_screen_enabler_2d_screen_entered() -> void:
	has_entered_screen = true


func _on_visible_on_screen_enabler_2d_screen_exited() -> void:
	if has_entered_screen:
		queue_free()
