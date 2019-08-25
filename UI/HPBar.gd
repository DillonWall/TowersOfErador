extends Control

export var HEALTH_PER_SEGMENT = 10
export var WIDTH_BETWEEN_SPRITES = 8
export var SPRITE_START_MARGIN = 8

#var _hp_segments = []
var _num_segments = 0
var _max_health = 0
var _health = 0
var _playerRef

func _init():
	#print("Connecting signals")
	SignalManager.connect("player_max_health_changed", self, "on_max_health_changed")
	SignalManager.connect("player_health_changed", self, "on_health_changed")
	
func set_playerref_and_update_stats(player):
	_playerRef = player
	_playerRef.update_stats()

func on_max_health_changed(max_health):
	#print("Got 2")
	#if there is a little more health left over, that will create a new segment (ex: 102 max health with 10 per segment = 11 segments)
	while max_health/HEALTH_PER_SEGMENT > _num_segments:
		#create new segments until equal
		var new_seg = get_node("HPSegment").duplicate()
		new_seg.margin_left = _num_segments * WIDTH_BETWEEN_SPRITES + SPRITE_START_MARGIN
		#print("creating segment with margin: ", _num_segments * WIDTH_BETWEEN_SPRITES)
		#new_seg.get_child(0).visible = false
		#_hp_segments.append(new_seg)
		add_child(new_seg)
		_num_segments += 1
		
	while max_health/HEALTH_PER_SEGMENT <= _num_segments - 1:
		#delete segments until equal
		var current_seg = get_child(_num_segments) #_hp_segments[_num_segments-1]
		#current_seg.get_parent().remove_child(current_seg)
		current_seg.queue_free()
		#_hp_segments.pop_back()
		_num_segments -= 1
		
	_max_health = max_health

func on_health_changed(health):
	#print("Got 3")
	if health > _max_health:
		health = _max_health
		
	if health < 0:
		health = 0
		
	while ceil(_health/HEALTH_PER_SEGMENT) <= ceil(health/HEALTH_PER_SEGMENT):
		get_child(ceil(_health/HEALTH_PER_SEGMENT)).get_child(0).visible = true #_hp_segments[ceil(_health/HEALTH_PER_SEGMENT)].get_child(0).visible = true
		_health += HEALTH_PER_SEGMENT
		if _health > health:
			_health = health
			break
		
	while ceil(_health/HEALTH_PER_SEGMENT) > ceil(health/HEALTH_PER_SEGMENT):
		get_child(ceil(_health/HEALTH_PER_SEGMENT)).get_child(0).visible = false #_hp_segments[ceil(_health/HEALTH_PER_SEGMENT)].get_child(0).visible = true
		_health -= HEALTH_PER_SEGMENT
		if _health < 0:
			_health = 0
		
	_health = health