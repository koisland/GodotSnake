class_name HUD extends CanvasLayer

@onready var score: Label = %Score
@onready var high_score: Label = %HighScore

# TODO: Try to dynamically add animated sprites. Use new hearts.tscn.
@onready var hearts: Array[AnimatedSprite2D] = [%H1, %H2, %H3]

var current_heart_idx: int

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	high_score.text = "High Score: " + str(Global.save_data.high_score)
	current_heart_idx = len(hearts)

func update_score(n: int) -> void:
	score.text = "Score: " + str(n)

func update_hearts(lives: int) -> void:
	var adj_lives = lives - 1
	for i in range(hearts.size() - 1, -1, -1):
		if i == adj_lives:
			break
		var heart = hearts[i]
		# Set to empty heart frame.
		heart.set_frame_and_progress(1, heart.frame_progress)
