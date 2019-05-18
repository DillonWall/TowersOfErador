extends Node2D

func _process(delta):
	$WeatherShaders.get_node("Snow").get_material().set_shader_param("playerPos", $Player.position)
	$WeatherShaders.get_node("Snow").position = $Player.position;
	
	$WeatherShaders.get_node("Fog").get_material().set_shader_param("playerPos", $Player.position)
	$WeatherShaders.get_node("Fog").position = $Player.position;