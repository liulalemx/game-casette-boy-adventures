extends Position2D

onready var dustParticle = $DustParticleJump
onready var timer = $Timer

func _ready() -> void:
	dustParticle.emitting = true
	timer.start()

func change_direction_right() -> void:
	dustParticle.process_material.direction.x = 45

func change_direction_left() -> void:
	dustParticle.process_material.direction.x = -45

func _on_Timer_timeout() -> void:
	queue_free()

