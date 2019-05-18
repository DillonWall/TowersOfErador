extends ParallaxBackground

export var ENABLE_SNOW = false
export var ENABLE_FOG = false
export var ENABLE_SHADER_SNOW = false

func _ready():
	$ParallaxLayer.get_node("ParticleEffects/Snow").emitting = ENABLE_SNOW
	$ParallaxLayer.get_node("ParticleEffects/Fog").region_enabled = not ENABLE_FOG
	$ParallaxLayer.get_node("ParticleEffects/ShaderSnow").region_enabled = not ENABLE_SHADER_SNOW