extends Node2D

# Declare member variables here. Examples:
var _progress = 0
var _max_progress = 100.0
var _step = 0.5
var _amount = 16.0 / 250.0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if _progress < _max_progress:
		$Camera2D.offset_v -= _amount
		_progress += _step
