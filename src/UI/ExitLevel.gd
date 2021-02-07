tool
extends TextureButton

export(String, FILE) var next_scene_path: = ""


func _on_ExitLevel_button_down() -> void:
	$Sprite.frame = 1

func _on_ExitLevel_button_up() -> void:
	$Sprite.frame = 0
	Stats.cassettes_collected = 0
	get_tree().paused = false
	get_tree().change_scene(next_scene_path)

func _get_configuration_warning() -> String:
	return "The property Next Level can't be empty" if next_scene_path == "" else ""
