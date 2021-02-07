extends Area2D

var motion = Vector2.ZERO

onready var animation = $AnimationPlayer
onready var sound = $AudioStreamPlayer

func _on_CasetteCollectables_body_entered(body: Node) -> void:
	body.cassette_found()
	animation.play("Fade")
	sound.play()
	
func die() -> void:
	queue_free()
	
