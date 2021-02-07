extends TextureButton

export(String, FILE) var next_scene_path: = ""

onready var soundHover = $Hover
onready var soundClick = $Click

func _on_ChangeSceneButton_button_down() -> void:
	$Sprite.frame = 2

func _on_ChangeSceneButton_button_up() -> void:
	$Sprite.frame = 0
	soundClick.play()
	get_tree().change_scene(next_scene_path)

func _on_ChangeSceneButton_mouse_entered() -> void:
		$Sprite.frame = 1
		soundHover.play()

func _get_configuration_warning() -> String:
	return "The property Next Level can't be empty" if next_scene_path == "" else ""


func _on_ChangeSceneButton_mouse_exited() -> void:
	$Sprite.frame = 2
