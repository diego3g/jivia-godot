extends Node2D

export(int) var max_health : = 100
onready var health : = max_health setget set_health 

signal no_health

func set_health(value: int):
	health = value
	
	if (health <= 0):
		emit_signal("no_health")
