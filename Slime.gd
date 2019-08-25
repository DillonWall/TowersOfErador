extends KinematicBody2D

const UP = Vector2(0, -1)
export var GRAVITY = 9.8
export var MAX_SPEED = 50
export var JUMP_HEIGHT = -275
export var ACCELERATION = 8
export var FALL_MULTIPLIER = 2.0
export var ATTACK_RADIUS = 20

var _motion = Vector2()
var _isMovingLeft = false
var _isWalking = false
var _isAttacking = false
var _shouldJump = false
var _path : = PoolVector2Array() setget set_path
var _nav_2d
var _patrol_path
var _player

var Stats_Class = load("res://GlobalScripts/Stats.gd")
#health, mana, attack_power, defense, magic_power, magic_defense, attack_speed, movement_speed
var _stats = Stats_Class.new(100, 100, 17, 0, 0, 0, 6.0, 2, false)

func get_stats():
	return _stats

func init(nav_2d : Navigation2D, player, patrol_path : Line2D):
	_nav_2d = nav_2d
	_player = player
	_patrol_path = patrol_path
	$Sprite.connect("animation_finished", self, "animationFinished")

func set_moving_left(b):
	_isMovingLeft = b

func set_moving_forward(b):
	_isWalking = b

func jump():
	_shouldJump = true
	
func move_along_path(delta) -> void:
	if !_isWalking:
		return
	if _path.size() <= 0:
		_isWalking = false
		return
	
	var vec_to_next_point_x = _path[0].x - position.x
	#print(vec_to_next_point_x)
	var motion_x = abs(_motion.x * delta)
	#print(motion_x)
	
	if vec_to_next_point_x < 0:
		_isMovingLeft = true
	elif vec_to_next_point_x > 0:
		_isMovingLeft = false
	
	if motion_x > abs(vec_to_next_point_x):
		position.x = _path[0].x
		_path.remove(0)
	
func set_path(value : PoolVector2Array) -> void:
	_path = value
	if value.size() == 0:
		return
		
func animationFinished():
	if $Sprite.animation == "attack":
		_isAttacking = false
		if (position - _player.position).length() < ATTACK_RADIUS:
			_player.get_stats().take_physical_damage(get_stats().get_attack_power())
		
	$Sprite.frame = 0

func attack():
	if _isMovingLeft and position.x < _player.position.x:
		$Sprite.flip_h = false
	elif !_isMovingLeft and !(position.x < _player.position.x):
		$Sprite.flip_h = true
		
	$Sprite.play("attack")
	_isAttacking = true
	
func slime_ai():
	#if the player is near attack them
	if !_isAttacking:
		if (position - _player.position).length() < ATTACK_RADIUS:
			attack()
	#otherwise if not doing an action (walking) then choose to do an action
	if !_isWalking:
		#(choose an action)
		#if patrol is chosen, turn around and walk to the next point in the patrol point
		_isWalking = true
		var pointArr = _patrol_path.points
		if (pointArr[pointArr.size() - 1] - position).length() > (pointArr[0] - position).length():
			#going right, so reverse patrol line points array
			pointArr.invert()
		set_path(pointArr)

func _physics_process(delta):
	slime_ai()
	move_along_path(delta)
	
	if _motion.y == 0:
		_motion.y += GRAVITY * FALL_MULTIPLIER

	var shouldIdle = true

	if _isAttacking:
		return
		
	if !_isMovingLeft and _isWalking:
		_motion.x = min(_motion.x + ACCELERATION, MAX_SPEED * get_stats().get_movement_speed())
		if is_on_floor():
			$Sprite.play("run")
		$Sprite.flip_h = true
		shouldIdle = false
	elif _isMovingLeft and _isWalking:
		_motion.x = max(_motion.x - ACCELERATION, -MAX_SPEED * get_stats().get_movement_speed())
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