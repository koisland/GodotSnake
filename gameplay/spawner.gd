class_name Spawner extends Node2D

# signals
# When emit signal, add tail so know to return ref to tail
signal tail_added(tail: Tail)
# export vars
@export var bounds: Bounds
@onready var body: Body = %Body

# instantiating packed scenes. Ctrl + drag
var food_scene: PackedScene = preload("uid://cmq75dsob6cji")
var tail_scene: PackedScene = preload("uid://hqol4cjsy268")


func spawn_food():
	# Where do we spawn? (position)
	# Intersect snake parts with possible points in grid
	# to avoid spawning food on self
	var set_snake_pos = Set.new()
	for part in body.snake_parts:
		set_snake_pos.add(part.last_position)
	var spawn_point: Vector2 = (
		bounds.pos_grid
		.difference(set_snake_pos)
		.elements()
		.pick_random()
	)
	
	if spawn_point == null:
		# TODO: No valid spawn point.
		pass
	
	# What do we spawn? (instantiating)
	var food = food_scene.instantiate()
	food.position = spawn_point
	# Who owns this object? (parenting)
	# In more complex games, this is potentially unsafe as we may change where
	# spawner goes later in dev
	get_parent().add_child(food)

func spawn_tail(pos: Vector2):
	var tail : Tail = tail_scene.instantiate()
	tail.position = pos
	get_parent().add_child(tail)
	# Emit signal and return reference.
	tail_added.emit(tail)
	
