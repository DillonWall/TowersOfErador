extends Sprite

export var SHOOTING_SPEED = 500
export var RETRACTING_SPEED = 10
export var RETRACT_THRESHOLD = 10
export var MAX_ROPE_LENGTH = 150

var _firing = false
var _connected = false
var _velocity = Vector2()
var _anchor_speed = SHOOTING_SPEED #units per frame (if positive, it is being shot; if negative, it is being retracted
var _player
var _source = Vector2()
var _length = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.
	
func set_player_obj(player):
	_player = player
	
func get_perpendicular():
	return (_source - $Anchor.position).rotated(-PI/2)
	
func set_length(player_pos):
	_length = (player_pos - $Anchor.position).length()
	#print((player_pos - $Anchor.position).length())
	
func get_length():
	return _length

func get_anchor_pos():
	return $Anchor.position
	
func get_rope_length_coeff(player_pos):
	var rope_vec = $Anchor.position - player_pos
	if rope_vec.length() < 1:
		return 999
	return _length / rope_vec.length()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func update_grapple(delta, player_pos):	
	#move anchor/ check for collision if firing or retracting
	if _firing:
		if _anchor_speed > 0 and is_instance_valid($Anchor.move_and_collide( _velocity * delta )):
			_firing = false
			_connected = true
			#when it does hit, let the player know so movement can be changed accordingly
			_player.grapple_connected()
		elif _anchor_speed < 0:
			var rope_vec = $Anchor.position - player_pos
			if rope_vec.length() < RETRACT_THRESHOLD:
				set_retracted()
			else:
				$Anchor.position -= rope_vec * (RETRACTING_SPEED / rope_vec.length()) 
		
	if _firing or _connected:
		#update _source location
		
		if _connected and _length > 0:			
			var rope_vec = $Anchor.position - player_pos
			var length_coeff = get_rope_length_coeff(player_pos)
			
			#if the rope is longer than max length
			if length_coeff < 1:
				_player.position = $Anchor.position - (rope_vec * length_coeff)
		
		_source = player_pos
		
		#change length of rope/ move rope if firing or swinging
		$Rope.position = (player_pos + $Anchor.position) / 2
		$Rope.rotation = ($Anchor.position - player_pos).angle() + PI / 2
		$Rope/Sprite.region_rect.size.y = (player_pos - $Anchor.position).length()
	
	if (player_pos - $Anchor.position).length() > MAX_ROPE_LENGTH:
		disconnect_grapple()


# Returns true (ready) if the grapple is not firing/returning and isnt connected
func is_ready():
	return (!_firing and !_connected)

# Called every time a click is triggered, takes in the point clicked on
# Note: can make it so they can send a grapple request while retracting, it just queues until it comes in
func on_click(source, destination):
	#check if the grapple is ready
	#if !is_ready():
		#return
		
	#send out anchor and rope (set velocity)
	_source = source
	_velocity = (destination - source).normalized() * _anchor_speed
	
	#make anchor and rope sprites visible and set their location
	$Anchor.position = source
	$Anchor/Sprite.visible = true
	
	$Rope.position = source
	$Rope/Sprite.visible = true
	
	_firing = true
	
# Called when the player jumps or otherwise disconnects the the grapple
func disconnect_grapple():
	#make sure it isnt disconnected already
	if is_ready():
		return
	
	#set connected to false
	_connected = false
	
	#set firing to true, but speed to a negative value
	_firing = true
	_anchor_speed = -RETRACTING_SPEED
	
func set_retracted():
	#hide anchor and rope
	$Anchor/Sprite.visible = false
	$Rope/Sprite.visible = false
	
	#no longer firing (in reverse)
	_firing = false
	
	#set anchor speed back to normal
	_anchor_speed = SHOOTING_SPEED
	
	#reset length for next grapple
	_length = 0
