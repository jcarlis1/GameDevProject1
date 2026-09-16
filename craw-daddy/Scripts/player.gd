extends CharacterBody2D

@export var move_speed : float = 100
@export var game_current : float = 5000

@onready var sprite : Sprite2D = $Sprite
@onready var anim : AnimationPlayer = $AnimationPlayer

var move_input : float
var move_input2 : float

func _physics_process(delta: float) -> void:
	move_input = Input.get_axis("move_left", "move_right")
	move_input2 = Input.get_axis("move_up", "move_down")
	
	velocity.x = move_input * move_speed
	velocity.y = move_input2 * move_speed
	if move_input == 0 or move_input == -1:
		velocity.x += -game_current * delta

	move_and_slide()

func _manage_animation():
	if move_input != 0 or move_input2 != 0:
		anim.play("move")
	else:
		anim.play("idle")


func _process(delta):
	_manage_animation()
