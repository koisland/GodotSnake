class_name Bounds extends Node2D

# Instead of added some vars to bound the player, we do so with a Node2D named
# Bounds. Bounds will have two markers indicating the top and bottom portion
# of the screen.
@onready var upper_left: Marker2D = %UpperLeft
@onready var lower_right: Marker2D = %LowerRight

var x_min: float
var x_max: float
var y_min: float
var y_max: float
var pos_grid: Set = Set.new()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	x_min = upper_left.position.x
	x_max = lower_right.position.x
	y_min = upper_left.position.y
	# Hmm. Still difficult to wrap my head around
	y_max = lower_right.position.y
	
	# Store grid coordinates in set
	var fgrid_size = float(Global.GRID_SIZE)
	for x in range(x_min, x_max):
		for y in range(y_min, y_max):
			var x_norm = floorf(x / fgrid_size) * Global.GRID_SIZE
			var y_norm = floorf(y / fgrid_size) * Global.GRID_SIZE
			pos_grid.add(Vector2(x_norm, y_norm))


func wrap_vector(v: Vector2) -> Vector2:
	if v.x < x_min:
		return Vector2(x_max, v.y)
	elif v.x > x_max:
		return Vector2(x_min, v.y)
	elif v.y < y_min:
		return Vector2(v.x, y_max)
	elif v.y > y_max:
		return Vector2(v.x, y_min)
	return v

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass
