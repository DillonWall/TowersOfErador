extends Control

export var MANA_PER_SEGMENT = 10
export var WIDTH_BETWEEN_SPRITES = 8
export var SPRITE_START_MARGIN = 8

var _mp_segments = []
var _num_segments = 0
var _max_mana = 0
var _mana = 0
var _playerRef

func _init():
#	print("Connecting signals")
	SignalManager.connect("player_max_mana_changed", self, "on_max_mana_changed")
	SignalManager.connect("player_mana_changed", self, "on_mana_changed")
	
func set_playerref_and_update_stats(player):
	_playerRef = player
	_playerRef.update_stats()

func on_max_mana_changed(max_mana):
#	print("Got 2")
	#if there is a little more mana left over, that will create a new segment (ex: 102 max mana with 10 per segment = 11 segments)
	while max_mana/MANA_PER_SEGMENT > _num_segments:
		#create new segments until equal
		var new_seg = get_node("MPSegment").duplicate()
		new_seg.margin_left = _num_segments * WIDTH_BETWEEN_SPRITES + SPRITE_START_MARGIN
		#print("creating segment with margin: ", _num_segments * WIDTH_BETWEEN_SPRITES)
		#new_seg.get_child(0).visible = false
		_mp_segments.append(new_seg)
		add_child(new_seg)
		_num_segments += 1
		
	while max_mana/MANA_PER_SEGMENT <= _num_segments - 1:
		#delete segments until equal
		var current_seg = _mp_segments[_num_segments-1]
		#current_seg.get_parent().remove_child(current_seg)
		current_seg.queue_free()
		_mp_segments.pop_back()
		_num_segments -= 1
		
	_max_mana = max_mana

func on_mana_changed(mana):
#	print("Got 3")
	if mana > _max_mana:
		mana = _max_mana
		
	while ceil(_mana/MANA_PER_SEGMENT) < ceil(mana/MANA_PER_SEGMENT):
		_mp_segments[ceil(_mana/MANA_PER_SEGMENT)].get_child(0).visible = true
		_mana += MANA_PER_SEGMENT
		
	_mana = mana