class_name Spawner extends Node2D

# signals
# When emit signal, add tail so know to return ref to tail
signal tail_added(tail: Tail)
# export vars
@export var bounds: Bounds
# instantiating packed scenes. Ctrl + drag
var food_scene: PackedScene = preload("uid://cmq75dsob6cji")
var tail_scene: PackedScene = preload("uid://hqol4cjsy268")


func spawn_food():
	# Where do we spawn? (position)
	var spawn_point: Vector2 = Vector2.ZERO
	# TODO: Create a lazy set of possible points and instead of randomly creating
	# positions, pull from the bag of possible points.
	# TODO: Intersect snake parts with above to avoid spawning food on self
	# Spawn within x range - 1 grid to avoid being at edge of screen.
	spawn_point.x = randf_range(bounds.x_min + Global.GRID_SIZE, bounds.x_max - Global.GRID_SIZE)
	spawn_point.y = randf_range(bounds.y_min + Global.GRID_SIZE, bounds.y_max - Global.GRID_SIZE)
	# Make so spawn on grid pt.
	spawn_point.x = floorf(spawn_point.x / Global.GRID_SIZE) * Global.GRID_SIZE
	spawn_point.y = floorf(spawn_point.y / Global.GRID_SIZE) * Global.GRID_SIZE
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
	
