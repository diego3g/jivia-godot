extends Area2D

onready var attackTimer: = $AttackTimer

var hitboxOriginPosition : = Vector2.ZERO
export(int) var damage = 20
export(float) var attack_speed = 1.6

var is_attacking: bool = false

signal attack

func start_attacking():
	is_attacking = true
	
	if (attackTimer.is_stopped()):
		emit_signal("attack")
		attackTimer.start(attack_speed)
		
func stop_attacking():
	is_attacking = false

func _on_AttackTimer_timeout():
	if (is_attacking):
		emit_signal("attack")
	else:
		attackTimer.stop()
