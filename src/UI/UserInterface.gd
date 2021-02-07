extends Control

onready var scene_tree: SceneTree = get_tree()
onready var pause_overlay: ColorRect = $PauseOveray
onready var score_label: Label = $Label
onready var sound = $AudioStreamPlayer

var paused: = false setget set_paused

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("pause"):
		self.paused = not self.paused
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		sound.play()

func set_paused(value: bool) -> void:
	paused = value
	scene_tree.paused = value
	pause_overlay.visible = value
	$AnimationPlayer.current_animation = "SlideIn"

func _ready() -> void:
	Stats.connect("cassette_found", self, "update_interface")
	Stats.connect("all_cassettes_collected", self, "end_level")
	update_interface()


func update_interface() -> void:
	score_label.text = "%s Found" % Stats.cassettes_collected
	
func end_level() -> void:
	get_tree().change_scene("res://src/Screens/LevelSelect.tscn")
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	
