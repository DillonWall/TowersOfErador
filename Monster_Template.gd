extends KinematicBody2D

const UP = Vector2(0, -1)
export var GRAVITY = 9.8
export var MAX_SPEED = 200
export var JUMP_HEIGHT = -275
export var ACCELERATION = 50
export var FALL_MULTIPLIER = 2.0

var _motion = Vector2()
var _isMovingLeft = true
var _isWalking = true
var _shouldJump = false

func set_moving_left(b):
	_isMovingLeft = b
	
func set_moving_forward(b):
	_isWalking = b
	
func jump():
	_shouldJump = true

func _physics_process(delta):
	if _motion.y == 0:
		_motion.y += GRAVITY * FALL_MULTIPLIER

	var shouldIdle = true
	
	if !_isMovingLeft and _isWalking:
		_motion.x = min(_motion.x + ACCELERATION, MAX_SPEED)
		if is_on_floor():
			$Sprite.play("run")
		$Sprite.flip_h = true
		shouldIdle = false
	elif _isMovingLeft and _isWalking:
		_motion.x = max(_motion.x - ACCELERATION, -MAX_SPEED)
		if is_on_floor():
			$Sprite.play("run")
		$Sprite.flip_h = false
		shouldIdle = false
	if shouldIdle:
		_motion.x = 0
		if is_on_floor():
			$Sprite.play("idle")
	
	if !is_on_floor():
		if _motion.y < 0:
			_motion.y += GRAVITY
		elif _motion.y > 0:
			$Sprite.play("fall")
			_motion.y += GRAVITY * FALL_MULTIPLIER
			
	if _shouldJump:
		$Sprite.play("jump")
		_motion.y = JUMP_HEIGHT	
	
	_motion = move_and_slide(_motion, UP)