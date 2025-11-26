
extends Node

# Keep constants in autoload
# Project > Project Settings > Globals > Autoload > Folder > Choose Node name.
const GRID_SIZE: int = 32 

var save_data: SaveData

func _ready() -> void:
	save_data = SaveData.load_or_create()
