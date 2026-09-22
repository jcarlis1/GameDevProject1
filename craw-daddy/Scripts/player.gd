extends CharacterBody2D

@export var move_speed : float = 100
@export var game_current : float = 5000
@export var health : int = 3

@onready var sprite : Sprite2D = $Sprite
@onready var anim : AnimationPlayer = $AnimationPlayer

var move_input : float
var move_input2 : float

var damaged : bool = false

signal OnUpdateHealth (health : int)
signal OnUpdateScore (score : int)

func _physics_process(delta: float) -> void:
	move_input = Input.get_axis("move_left", "move_right")
	move_input2 = Input.get_axis("move_up", "move_down")
	
	velocity.x = move_input * move_speed
	velocity.y = move_input2 * move_speed
	if move_input == 0 or move_input == -1:
		velocity.x += -game_current * delta

	move_and_slide()

func _manage_animation():
	if damaged:
		anim.play("damage")
		await get_tree().create_timer(1.0).timeout
		damaged = false
	elif move_input != 0 or move_input2 != 0:
		anim.play("move")
	else:
		anim.play("idle")

func take_damage(amount : int):
	health -= amount
	damaged = true
	OnUpdateHealth.emit(health)
	if health <= 0:
		call_deferred("game_over")

func _process(delta):
	if velocity.x != 0:
		sprite.flip_h = velocity.x < 0
	_manage_animation()

func increase_score(amount : int):
	PlayerStats.score += amount
	OnUpdateScore.emit(PlayerStats.score)

func increase_health(amount : int):
	health += amount
	OnUpdateHealth.emit(health)
	
func game_over():
	get_tree().change_scene_to_file("res://Scenes/level_1.tscn")
