class_name Gameplay extends Node2D

const game_over_scene: PackedScene = preload("res://menus/game_over.tscn")
const pause_scene: PackedScene = preload("res://menus/pause_menu.tscn")

# Access as unique name, so don't break references if moved around
@onready var head: Head = %Head
@onready var bounds: Bounds = %Bounds
@onready var spawner: Spawner = $Spawner
@onready var body: Body = %Body
@onready var hud: HUD = $HUD

var time_between_moves: float = 1000.0
var time_since_last_move: float = 0.0
var speed: float = 5000.0
var dt_speed: float = 500.0
var move_dir: Vector2 = Vector2.RIGHT
# Useful if need to provide different scoring for items.
var score: int:
	get:
		return score
	set(value):
		score = value
		hud.update_score(value)
var game_over_menu: GameOverMenu
var pause_menu: PauseMenu

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# Attach signals
	head.food_eaten.connect(_on_food_eaten)
	head.collided_with_tail.connect(_on_tail_collided)
	spawner.tail_added.connect(_on_tail_added)
	# Force snake to move instead of waiting one full tick.
	time_since_last_move = time_between_moves
	# First food.
	spawner.spawn_food()
	# Add head of snake
	body.snake_parts.push_back(head)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	var new_dir: Vector2 = Vector2.ZERO
	# (x, y)
	# y goes positively in down direction
	# Remember to map WASD via Project > Project Settings > Input Map > ui_*
	if Input.is_action_pressed("ui_up"):
		new_dir = Vector2.UP # (0, -1)
	elif Input.is_action_pressed("ui_down"):
		new_dir = Vector2.DOWN # (0, 1)
	elif Input.is_action_pressed("ui_left"):
		new_dir = Vector2.LEFT # (1, 0)
	elif Input.is_action_pressed("ui_right"):
		new_dir = Vector2.RIGHT # (-1, 0)

	# Don't allow moving backward
	# 2nd condition so if no button pressed, resume previous direction.
	if new_dir + move_dir != Vector2.ZERO and new_dir != Vector2.ZERO:
		move_dir = new_dir
		
	if Input.is_action_just_pressed("ui_cancel"):
		pause_game()
		
# Snake is Area2d (phyx obj) so update in physics_process_loop
func _physics_process(delta: float) -> void:
	# So as time passes (delta), time_since_last move increases based on set speed
	# and results in snake updating.
	# Higher speed forces a faster update -> more difficult
	time_since_last_move += delta * speed
	if time_since_last_move >= time_between_moves:
		update_snake()
		# If you didn't remove this, above condition always met and would trigger multiple updates?
		time_since_last_move = 0

func update_snake():
	var new_position: Vector2 = head.position + move_dir * Global.GRID_SIZE
	new_position = bounds.wrap_vector(new_position)
	head.move_to(new_position)
	
	# Iterate thru each part after head
	# Move to last position of previous part.
	for i in range(1, body.snake_parts.size(), 1):
		body.snake_parts[i].move_to(body.snake_parts[i-1].last_position)

func _on_food_eaten():
	# spawn food.
	spawner.call_deferred("spawn_food")
	# add tail
	spawner.call_deferred("spawn_tail", body.snake_parts[body.snake_parts.size() - 1].last_position)
	# increase speed
	speed += dt_speed
	# keep score
	score += 1

func _on_tail_added(tail: Tail):
	body.snake_parts.push_back(tail)

func _on_tail_collided():
	if not game_over_menu:
		game_over_menu = game_over_scene.instantiate() as GameOverMenu
		add_child(game_over_menu)
		game_over_menu.set_score(score)

func _notification(what: int) -> void:
	if what == NOTIFICATION_WM_WINDOW_FOCUS_OUT:
		pause_game()

func pause_game():
	if not pause_menu:
		pause_menu = pause_scene.instantiate() as PauseMenu
		add_child(pause_menu)
