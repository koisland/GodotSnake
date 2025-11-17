class_name Head extends SnakePart

signal food_eaten

func _on_area_entered(area: Area2D) -> void:
	if area.is_in_group("Food"):
		print("collided with ", area.name)
		# When collide, free physics object
		# Better to defer until after physics frame complete and before next one starts.
		food_eaten.emit()
		area.call_deferred("queue_free")
	else:
		pass
