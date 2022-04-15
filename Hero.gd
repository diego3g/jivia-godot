extends KinematicBody2D

onready var animation: AnimationPlayer = $AnimationPlayer
onready var animationTree: AnimationTree = $AnimationTree
onready var animationState: AnimationNodeStateMachinePlayback = animationTree.get("parameters/playback")
onready var swordHitbox: Area2D = $SwordHitboxPivot/SwordHitbox
onready var hero: Sprite = $Sprite

enum {
	MOVE,
	ATTACK
}

const speed : = 120
var state : = MOVE
var velocity = Vector2()
	
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
	

