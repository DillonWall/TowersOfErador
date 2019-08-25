extends Node2D

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

#Initializes the Navigation2D and patrol path for the monster
func init(nav_2d : Navigation2D, player):
	$KinematicBody2D.init(nav_2d, player, $PatrolPath)