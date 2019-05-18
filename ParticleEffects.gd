extends Node2D

export var ENABLE_FOG = false
export var ENABLE_SNOW = false

func _ready():
	$Fog.region_enabled = not ENABLE_FOG
	$Snow.region_enabled = not ENABLE_SNOW