tool
extends TextureButton


export(String, FILE) var next_scene_path: = ""

onready var sound = $AudioStreamPlayer

func _on_TextureButton_button_down() -> void:
	$Sprite.frame = 1

func _on_TextureButton_button_up() -> void:
	$Sprite.frame = 0
	sound.play()
	get_parent().get_parent().get_node("Transition/AnimationPlayer").play("FadeOut")
	get_tree().change_scene(next_scene_path)

func _get_configuration_warning() -> String:
	return "The property Next Level can't be empty" if next_scene_path == "" else ""
