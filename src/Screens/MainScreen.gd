extends Control

export var music: AudioStream


func _ready() -> void:
	BackgroundMusic.crossfade_to(music)
	
func _physics_process(delta: float) -> void:
	if Input.is_action_just_pressed("Mute"):
		BackgroundMusic.mute()
	
