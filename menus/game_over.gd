class_name GameOverMenu extends CanvasLayer

@onready var score: Label = %ScoreLabel
@onready var high_score: Label = %HighScoreLabel
@onready var restart: Button = %RestartButton
@onready var quit: Button = %QuitButton

# Need to go to GameOver scene and set Inspector > Node > Process > Mode > Always (From Inherit)
# Otherwise, will also pause this scene when _notification called.

func set_score(n: int):
	score.text = "Final Score: " + str(n)
	# TODO: High score logic and saving.

func _on_restart_button_pressed() -> void:
	# For simple game, we can just reload current scene
	get_tree().reload_current_scene()


func _on_quit_button_pressed() -> void:
	# Won't work in web browser.
	get_tree().quit()

func _notification(what):
	match what:
		NOTIFICATION_ENTER_TREE:
			get_tree().paused = true
		NOTIFICATION_EXIT_TREE:
			get_tree().paused = false
