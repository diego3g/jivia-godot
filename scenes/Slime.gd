extends KinematicBody2D

const DeathEffect : = preload("res://effects/SlimeDeathEffect.tscn")

onready var stats: = $Stats
onready var playerDetectionZone: = $PlayerDetectionZone
onready var animationTree: = $AnimationTree
onready var animationState: AnimationNodeStateMachinePlayback = animationTree.get("parameters/playback")

export var ACCELERATION = 300
export var MAX_SPEED = 50
export var FRICTION = 200

enum {
	IDLE,
	WANDER,
	CHASE
}

var velocity = Vector2.ZERO
var knockback = Vector2.ZERO
var state = IDLE

func _physics_process(delta):
	knockback = knockback.move_toward(Vector2.ZERO, FRICTION * delta)
	knockback = move_and_slide(knockback)
	
	velocity = move_and_slide(velocity)
	
	match state:
		IDLE:
			velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)
			seek_player()
		WANDER:
			pass;
		CHASE:
			if playerDetectionZone.can_see_player():
				var chaseDirection = global_position.direction_to(playerDetectionZone.player.global_position)
				
				animationTree.set("parameters/Chase/blend_position", chaseDirection)
				animationTree.set("parameters/Idle/blend_position", chaseDirection)
				
				velocity = velocity.move_toward(chaseDirection * MAX_SPEED, ACCELERATION * delta)
			else:
				state = IDLE
			
func seek_player():
	if playerDetectionZone.can_see_player():
		animationState.travel("Chase")
		state = CHASE
	else:
		animationState.travel("Idle")
	
func _on_Hurtbox_area_entered(area):
	var knockbackDiretion = area.hitboxOriginPosition.direction_to(global_position)
	knockback = knockbackDiretion * 100
	
	stats.health -= area.damage

func _on_Stats_no_health():
	queue_free()
	
	var deathEffect = DeathEffect.instance()
	
	get_parent().add_child(deathEffect)
	
	deathEffect.global_position = global_position
