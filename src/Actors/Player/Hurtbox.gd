extends Area2D

onready var parent = get_parent()

func _on_Hurtbox_body_entered(body: Node) -> void:
	parent.state = parent.DEAD

func _on_Hurtbox_area_entered(area: Area2D) -> void:
	parent.state = parent.DEAD
