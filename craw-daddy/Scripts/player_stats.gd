extends Node

var score : int = 0
var level_start_score: int = 0

# Call when the player dies or reloads the level
func reset_to_level_start() -> void:
	score = level_start_score

# Call when the player completes a level successfully
func save_level_checkpoint() -> void:
	level_start_score = score

# Call when starting a brand new game from the Main Menu
func reset_game() -> void:
	score = 0
	level_start_score = 0
