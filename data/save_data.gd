class_name SaveData extends Resource

@export var high_score: int = 0

const SAVE_PATH: String = "user://save_data.tres"

func save() -> void:
	# Save this class w/high_score var to SAVE_PATH
	ResourceSaver.save(self, SAVE_PATH)

# Can call without init class
static func load_or_create() -> SaveData:
	var res: SaveData
	if FileAccess.file_exists(SAVE_PATH):
		res = load(SAVE_PATH) as SaveData
	else:
		res = SaveData.new()
	return res
