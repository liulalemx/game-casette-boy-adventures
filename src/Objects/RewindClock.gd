extends Node2D

onready var deathTimer = $Timer

func _ready() -> void:
	deathTimer.start()

func _on_Timer_timeout() -> void:
	queue_free()
