shader_type canvas_item;

uniform vec3 color = vec3(0.0, 0.0, 0.0);
uniform float OCTAVES = 4.0;
//uniform float fPeriodSize = 2;
uniform vec2 playerPos = vec2(0,0);
uniform vec2 resolution = vec2(512,512);

float rand(vec2 coord){
	return fract(sin(dot(coord, vec2(56, 78)) * 1000.0) * 1000.0);
}

//float tileRand(vec2 coord){
//	float fScaleX = coord.x / (fPeriodSize * 5.0);
//	float fPeriodX = fScaleX * 2.0f * 3.14159f;
//	float fScaleY = coord.y / (fPeriodSize * 5.0);
//	float fPeriodY = fScaleY * 2.0f * 3.14159f;
//	float fRadius = 1.0f;
//
//	return fract(fRadius * sin(fPeriodX) + fRadius * cos(fPeriodY));
//}

float noise(vec2 coord){
	vec2 i = floor(coord);
	vec2 f = fract(coord);

	float a = rand(i + vec2(-0.5, -0.5));
	float b = rand(i + vec2(0.5, -0.5));
	float c = rand(i + vec2(-0.5, 0.5));
	float d = rand(i + vec2(0.5, 0.5));

	vec2 cubic = f * f * (3.0 - 2.0 * f);

	return mix(a, b, cubic.x) + (c - a) * cubic.y * (1.0 - cubic.x) + (d - b) * cubic.x * cubic.y;

//https://www.gamedev.net/forums/topic/642794-tileable-fbm-noise/
//	float fScaleX = coord.x / fPeriodSize;
//	float fPeriodX = fScaleX * 2.0f * 3.14159f;
//	float fScaleY = coord.y / fPeriodSize;
//	float fPeriodY = fScaleY * 2.0f * 3.14159f;
//	float fRadius = 1.0f;
//
//	return fRadius * sin(fPeriodX) + fRadius * cos(fPeriodY);
}

float fbm(vec2 coord){
	float value = 0.0;
	float scale = 0.5;
	
	for (float i = 0.0; i < OCTAVES; i += 1.0){
		value += noise(coord) * scale;
		coord *= 2.0;
		scale *= 0.5;
	}
	
	return value;
}

void fragment(){
	float scale = 20.0;
	vec2 coord = ((UV * scale) + playerPos / (resolution / scale));
	
	vec2 motion = vec2( fbm(coord + TIME * 0.5) );
	
	float final = fbm(coord + motion);
	
	COLOR = vec4(color, final * 0.25);
}