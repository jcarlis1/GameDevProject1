extends CharacterBody2D

const speed = 80.0
var player: Node2D = null
var damage : int = 3
@onready var sprite : Sprite2D = $Sprite
@onready var hitbox : Area2D = $Hitbox
@onready var snake : AudioStreamPlayer = $AudioStreamPlayer

var base_hitbox_x: float = 0.0

func _ready() -> void:
	snake.play()
	player = get_tree().get_first_node_in_group("Player")
	base_hitbox_x = abs(hitbox.position.x)
	if is_instance_valid(player):
		global_position = player.global_position - Vector2(500, 0)
		

func _physics_process(_delta: float) -> void:
	if is_instance_valid(player):
		# Recalculates direction to player every frame, updating Y movement dynamically
		var move_direction = (player.global_position - global_position).normalized()
		velocity = move_direction * speed
	
	if velocity.x != 0:
		set_facing(velocity.x < 0)
	
	move_and_slide()

func _process(_delta):
	if velocity.x != 0:
		sprite.flip_h = velocity.x < 0

func set_facing(facing_left: bool) -> void:
	sprite.flip_h = facing_left
	
	# Flip the shapes' X positions to match the sprite orientation
	if facing_left:
		hitbox.position.x = -base_hitbox_x
	else:
		hitbox.position.x = base_hitbox_x
