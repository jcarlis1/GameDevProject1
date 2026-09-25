extends AnimatedSprite2D

@export var scene_to_load : PackedScene

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_run_animation()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

func _run_animation():
	play("dig")

func _on_animation_finished() -> void:
	await get_tree().create_timer(3.0).timeout
	get_tree().change_scene_to_packed.call_deferred(scene_to_load)
