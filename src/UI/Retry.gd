tool
extends TextureButton

export(String, FILE) var next_scene_path: = ""

func _on_Retry_button_down() -> void:
	$Sprite.frame = 1
	
func _on_Retry_button_up() -> void:
	$Sprite.frame = 0
	Stats.cassettes_collected = 0
	get_tree().paused = false
	get_tree().reload_current_scene()
	

