class_name Tail extends SnakePart

# So we create new scenes for separate game entities with attached logic?

@export var textures: Array[Texture]
@onready var sprite_2d: Sprite2D = $Sprite2D


func _ready() -> void:
	sprite_2d.texture = textures.pick_random()
