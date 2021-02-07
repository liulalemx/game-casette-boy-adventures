extends Node

onready var cassettes_collected = 0 setget set_casette_number

signal all_cassettes_collected
signal cassette_found

func set_casette_number(value):
	cassettes_collected = value
	emit_signal("cassette_found")
	if cassettes_collected == 4:
		emit_signal("all_cassettes_collected")
		cassettes_collected = 0
