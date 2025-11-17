class_name Spawner extends Node2D

# signals
# export vars
@export var bounds: Bounds
# instantiating packed scenes
var food_scene: PackedScene = preload("uid://cmq75dsob6cji")

func spawn_food():
	# Where do we spawn? (position)
	var spawn_point: Vector2 = Vector2.ZERO
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
	pass
