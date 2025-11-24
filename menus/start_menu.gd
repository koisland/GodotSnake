class_name StartMenu extends CanvasLayer

@onready var start: Button = %StartButton
@onready var quit: Button = %QuitButton
@onready var score: Label = %ScoreLabel

const gameplay_scene: PackedScene = preload("res://gameplay/gameplay.tscn")

func _ready() -> void:
	# TODO: Set high score
	var high_score: int = 0
	score.text = "High Score: " + str(high_score)


func _on_start_button_pressed() -> void:
	# Change scene to packed to replace with new gameplayscene
	# Works well for small to medium games.
	# If bigger, need more complex scene loader to handle background loading
	# and passing data between scenes.
	get_tree().change_scene_to_packed(gameplay_scene)


func _on_quit_button_pressed() -> void:
	get_tree().quit()
