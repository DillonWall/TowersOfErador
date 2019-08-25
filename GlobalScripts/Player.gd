extends KinematicBody2D

const UP = Vector2(0, -1)
export var GRAVITY = 9.8
export var MAX_SPEED = 200
export var JUMP_HEIGHT = -275
export var ACCELERATION = 50
export var SWING_ACCELERATION = 10
export var FALL_MULTIPLIER = 2.0
export var LOW_JUMP_MULIPLIER = 2.0
export var JUMP_REMEMBER_TIME = 0.1
export var FALL_REMEMBER_TIME = 0.1
export var AIR_RESISTANCE = 0.98

var _motion = Vector2()
var _mostRecentLeft = false
var _fJumpPressedRemember = 0.0
var _fLastGroundedRemember = 0.0
var _grappled = false
var _swinging = false
var _attacking = false
var _grapple

var Stats_Class = load("res://GlobalScripts/Stats.gd")
#health, mana, attack_power, defense, magic_power, magic_defense, attack_speed, movement_speed
var _stats = Stats_Class.new(100, 100, 10, 2, 4, 4, 6.0, 1, true)

func update_stats():
	_stats.update()

func get_stats():
	return _stats

func set_grapple_obj(grapple):
	_grapple = grapple

func grapple_connected():
	_grappled = true

func attack(mouse_pos):
	if _attacking:
		return
	
	

func _physics_process(delta):
	if _motion.y == 0:
		_motion.y += GRAVITY * FALL_MULTIPLIER

	var shouldIdle = true
	
	if _swinging:
		shouldIdle = false
	
	if Input.is_action_just_pressed("ui_left"):
		_mostRecentLeft = true
	elif Input.is_action_just_pressed("ui_right"):
		_mostRecentLeft = false
	
	if Input.is_action_pressed("ui_right") and (not _mostRecentLeft or not Input.is_action_pressed("ui_left")):
		if _swinging:
			_motion.x += SWING_ACCELERATION
		else:
			_motion.x = min(_motion.x + ACCELERATION, MAX_SPEED)
			if is_on_floor():
				$Sprite.play("run")
			$Sprite.flip_h = false
			shouldIdle = false
	elif Input.is_action_pressed("ui_left") and (_mostRecentLeft or not Input.is_action_pressed("ui_right")):
		if _swinging:
			_motion.x -= SWING_ACCELERATION
		else:
			_motion.x = max(_motion.x - ACCELERATION, -MAX_SPEED)
			if is_on_floor():
				$Sprite.play("run")
			$Sprite.flip_h = true
			shouldIdle = false
	if shouldIdle:
		_motion.x = 0
		if is_on_floor():
			$Sprite.play("idle")
	
	_fJumpPressedRemember -= delta
	_fLastGroundedRemember -= delta
	if Input.is_action_just_pressed("ui_up"):
		_fJumpPressedRemember = JUMP_REMEMBER_TIME
	if is_on_floor():
		_fLastGroundedRemember = FALL_REMEMBER_TIME
	else:
		if _motion.y < 0 and !Input.is_action_pressed("ui_up") and not _swinging:
			_motion.y += GRAVITY * LOW_JUMP_MULIPLIER
		elif _motion.y < 0:
			_motion.y += GRAVITY
		elif _motion.y > 0:
			$Sprite.play("fall")
			if _grappled and not _swinging:
				_swinging = true
				_grapple.set_length(position)
			_motion.y += GRAVITY * FALL_MULTIPLIER
			
	if _fJumpPressedRemember > 0 and (_fLastGroundedRemember > 0 or _swinging):
		_fJumpPressedRemember = 0.0
		_fLastGroundedRemember = 0.0
		$Sprite.play("jump")
		_motion.y = JUMP_HEIGHT		
		if _swinging:
			disconnect_from_grapple()
		
	if _grappled and _swinging:
		if is_on_floor():
			disconnect_from_grapple()
		elif _grapple.get_rope_length_coeff(position) <= 1:
			_motion = _motion.project(_grapple.get_perpendicular())
			_motion *= AIR_RESISTANCE
	
	
	_motion = move_and_slide(_motion, UP)

func disconnect_from_grapple():
	_swinging = false
	_grappled = false
	_grapple.disconnect_grapple()

func set_grappled(grappled):
	_grappled = grappled