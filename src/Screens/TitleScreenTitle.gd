extends TextureRect

onready var animPlayer = $AnimationPlayer

func playLogo() -> void:
	animPlayer.play("Move")
