extends Position2D

onready var dustParticleLeft = $FallDustParticleLeft
onready var dustParticleRight = $FallDustParticleRight
onready var timer = $Timer

func _ready() -> void:
	dustParticleLeft.emitting = true
	dustParticleRight.emitting = true
	timer.start()

func _on_Timer_timeout() -> void:
	queue_free()
