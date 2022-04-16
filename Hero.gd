extends KinematicBody2D

onready var animation: = $AnimationPlayer
onready var animationTree: = $AnimationTree
onready var animationState: AnimationNodeStateMachinePlayback = animationTree.get("parameters/playback")
onready var swordHitbox: = $SwordHitboxPivot/SwordHitbox
onready var hero: = $Sprite
onready var stats: = $Stats

enum {
	MOVE,
	ATTACK
}

const speed : = 120

var state : = MOVE
var velocity: = Vector2()
var attacked_by: = []
var is_dead = false
	
signal health_changed(value)	
	
func _ready():
	stats.connect("no_health", self, "_on_no_health")
	
func get_input():
	velocity = Vector2()
	
	if Input.is_key_pressed(KEY_D):
			velocity.x += 1
	if Input.is_key_pressed(KEY_A):
			velocity.x -= 1
	if Input.is_key_pressed(KEY_S):
			velocity.y += 1
	if Input.is_key_pressed(KEY_W):
			velocity.y -= 1
			
	if (velocity != Vector2()):
		velocity = velocity.normalized()

func _physics_process(_delta: float):
	if (!is_dead):
		match state:
			MOVE:
				move_state()
			ATTACK:
				attack_state()
	
func attack_state():
	velocity = Vector2.ZERO
	animationState.travel("Attack")
	
func attack_animation_finished():
	state = MOVE
	
func move_state():
	get_input()
	
	if (velocity != Vector2()):
		swordHitbox.hitboxOriginPosition = global_position
	
	if (velocity.x != 0):
		animationTree.set("parameters/Idle/blend_position", velocity)
		animationTree.set("parameters/Walk/blend_position", velocity)
		animationTree.set("parameters/Attack/blend_position", velocity)
		
		animationState.travel("Walk")
	elif (velocity.y != 0):
		animationState.travel("Walk")
	else:
		animationState.travel("Idle")
		
	velocity = move_and_slide(velocity * speed)
	
	if Input.is_action_just_pressed("attack"):
		state = ATTACK
	
func _on_no_health():
	is_dead = true
	animationState.travel("Death")
	set_deferred("monitorable", false)
	
func _on_attacked(damage: int):
	if (!is_dead):
		stats.health -= damage
		emit_signal("health_changed", stats.health)

func _on_Hurtbox_area_entered(area: Area2D):
	area.connect("attack", self, "_on_attacked", [area.damage])
	area.start_attacking()
	
func _on_Hurtbox_area_exited(area: Area2D):
	area.disconnect("attack", self, "_on_attacked")
	area.stop_attacking()

