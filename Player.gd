extends KinematicBody2D

const UP = Vector2(0, -1)
export var GRAVITY = 9.8
export var MAX_SPEED = 200
export var JUMP_HEIGHT = -275
export var ACCELERATION = 50
export var FALL_MULTIPLIER = 2.0
export var LOW_JUMP_MULIPLIER = 2.0
export var JUMP_REMEMBER_TIME = 0.1
export var FALL_REMEMBER_TIME = 0.1

var motion = Vector2()
var mostRecentLeft = false
var fJumpPressedRemember = 0.0
var fLastGroundedRemember = 0.0

func _physics_process(delta):	
	if motion.y == 0:
		motion.y += GRAVITY * FALL_MULTIPLIER

	var shouldIdle = true
	
	if Input.is_action_just_pressed("ui_left"):
		mostRecentLeft = true
	elif Input.is_action_just_pressed("ui_right"):
		mostRecentLeft = false
	
	if Input.is_action_pressed("ui_right") and (not mostRecentLeft or not Input.is_action_pressed("ui_left")):
		motion.x = min(motion.x+ACCELERATION, MAX_SPEED)
		if is_on_floor():
			$Sprite.play("run")
		$Sprite.flip_h = false
		shouldIdle = false
	elif Input.is_action_pressed("ui_left") and (mostRecentLeft or not Input.is_action_pressed("ui_right")):
		motion.x = max(motion.x-ACCELERATION, -MAX_SPEED)
		if is_on_floor():
			$Sprite.play("run")
		$Sprite.flip_h = true
		shouldIdle = false
	if shouldIdle:
		motion.x = 0
		if is_on_floor():
			$Sprite.play("idle")
	
	fJumpPressedRemember -= delta
	fLastGroundedRemember -= delta
	if Input.is_action_just_pressed("ui_up"):
		fJumpPressedRemember = JUMP_REMEMBER_TIME
		
	if is_on_floor():
		fLastGroundedRemember = FALL_REMEMBER_TIME
	else:
		if motion.y < 0 and !Input.is_action_pressed("ui_up"):
			motion.y += GRAVITY * LOW_JUMP_MULIPLIER
		elif motion.y <0:
			motion.y += GRAVITY
		elif motion.y > 0:
			$Sprite.play("fall")
			motion.y += GRAVITY * FALL_MULTIPLIER
			
	if fJumpPressedRemember > 0 && fLastGroundedRemember > 0:
		fJumpPressedRemember = 0.0
		fLastGroundedRemember = 0.0
		$Sprite.play("jump")
		motion.y = JUMP_HEIGHT
	
	motion = move_and_slide(motion, UP)
		
	