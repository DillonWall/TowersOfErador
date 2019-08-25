extends Node2D

func _ready():
	$Grapple.set_player_obj($Player)
	$Player.set_grapple_obj($Grapple)
	$MonsterList.init($Navigation2D, $Player)
	$"HUDCanvasLayer/InGame HUD/HPBar".set_playerref_and_update_stats($Player)
	$"HUDCanvasLayer/InGame HUD/MPBar".set_playerref_and_update_stats($Player)

func _process(delta):
	$WeatherShaders.get_node("Snow").get_material().set_shader_param("playerPos", $Player.position)
	$WeatherShaders.get_node("Snow").position = $Player.position
	
	$WeatherShaders.get_node("Fog").get_material().set_shader_param("playerPos", $Player.position)
	$WeatherShaders.get_node("Fog").position = $Player.position
	
	$Grapple.update_grapple(delta, $Player.position)
	
func _unhandled_input(event):
	if event is InputEventMouseButton:
		if event.pressed and event.button_index == BUTTON_LEFT: #attack
			$Player.attack(get_global_mouse_position())
		if event.pressed and event.button_index == BUTTON_RIGHT: #grapple
			$Grapple.on_click($Player.position, get_global_mouse_position())