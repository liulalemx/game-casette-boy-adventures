extends TextureButton

onready var sound = $AudioStreamPlayer

func _on_TextureButton_button_down() -> void:
	$Sprite.frame = 1
	sound.play()

func _on_TextureButton_button_up() -> void:
	$Sprite.frame = 0
	
	get_tree().quit()
