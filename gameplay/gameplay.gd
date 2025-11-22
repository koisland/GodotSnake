class_name Gameplay extends Node2D

# Access as unique name, so don't break references if moved around
@onready var head: Head = %Head
@onready var bounds: Bounds = %Bounds
@onready var spawner: Spawner = $Spawner


var time_between_moves: float = 1000.0
var time_since_last_move: float = 0.0
var speed: float = 10000.0
var dt_speed: float = 500.0
var move_dir: Vector2 = Vector2.RIGHT
# Godot allows mixed types but lose auto-completion
var snake_parts: Array[SnakePart] = []


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	head.food_eaten.connect(_on_food_eaten)
	head.collided_with_tail.connect(_on_tail_collided)
	spawner.tail_added.connect(_on_tail_added)
	# First food.
	spawner.spawn_food()
	
	snake_parts.push_back(head)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	# (x, y)
	# y goes positively in down direction
	# Remember to map WASD via Project > Project Settings > Input Map > ui_*
	if Input.is_action_pressed("ui_up"):
		move_dir = Vector2.UP
	elif Input.is_action_pressed("ui_down"):
		move_dir = Vector2.DOWN
	elif Input.is_action_pressed("ui_left"):
		move_dir = Vector2.LEFT
	elif Input.is_action_pressed("ui_right"):
		move_dir = Vector2.RIGHT

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
	for i in range(1, snake_parts.size(), 1):
		snake_parts[i].move_to(snake_parts[i-1].last_position)

func _on_food_eaten():
	# spawn food.
	spawner.call_deferred("spawn_food")
	# add tail
	spawner.call_deferred("spawn_tail", snake_parts[snake_parts.size() - 1].last_position)
	# increase speed
	speed += dt_speed
	# keep score

func _on_tail_added(tail: Tail):
	snake_parts.push_back(tail)

func _on_tail_collided():
	print("Game over man")
