extends CanvasLayer

@onready var health_container = $HealthContainer
var hearts : Array = []
@onready var score_text : Label = $ScoreText
@onready var player = get_parent()

const MAX_HEARTS: int = 3

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	hearts = health_container.get_children()
	
	if hearts.size() > MAX_HEARTS:
		hearts = hearts.slice(0, MAX_HEARTS)
	
	# Subscribe to the player's health and score signals
	player.OnUpdateHealth.connect(_update_hearts)
	player.OnUpdateScore.connect(_update_score)
	
	# Show the correct starting values on the first frame
	_update_hearts(player.health)
	_update_score(PlayerStats.score)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

func _update_hearts(health : int):
	#for i in range(len(hearts)):
		#hearts[i].visible = i < health
	var clamped_health = clampi(health, 0, MAX_HEARTS)
	for i in range(hearts.size()):
		hearts[i].visible = i < clamped_health

func _update_score(score : int):
	score_text.text = "Score: " + str(score)
