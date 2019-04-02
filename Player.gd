extends KinematicBody2D

const UP = Vector2(0, -1)
export var GRAVITY = 20
export var MAX_SPEED = 200
export var JUMP_HEIGHT = -550
export var ACCELERATION = 50

var motion = Vector2()
var mostRecentLeft = false

func _physics_process(delta):
	motion.y += GRAVITY
	
	var shouldIdle = true
	
	if Input.is_action_just_pressed("ui_left"):
		mostRecentLeft = true
	elif Input.is_action_just_pressed("ui_right"):
		mostRecentLeft = false
	
	if Input.is_action_pressed("ui_right") and (not mostRecentLeft or not Input.is_action_pressed("ui_left")):
		motion.x = min(motion.x+ACCELERATION, MAX_SPEED)
		$Sprite.play("run")
		$Sprite.flip_h = false
		shouldIdle = false
	elif Input.is_action_pressed("ui_left") and (mostRecentLeft or not Input.is_action_pressed("ui_right")):
		motion.x = max(motion.x-ACCELERATION, -MAX_SPEED)
		$Sprite.play("run")
		$Sprite.flip_h = true
		shouldIdle = false
	if shouldIdle:
		motion.x = 0
		$Sprite.play("idle")
	
	if is_on_floor():
		if Input.is_action_just_pressed("ui_up"):
			motion.y = JUMP_HEIGHT
	else:
		if motion.y < 0:
			$Sprite.play("jump")
		else:
			$Sprite.play("fall")
	
	motion = move_and_slide(motion, UP)
	pass