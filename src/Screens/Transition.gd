extends ColorRect

onready var player = $AnimationPlayer

func motion() -> void:
	player.play("FadeIn")
