shader_type canvas_item;

uniform vec3 color = vec3(1.0, 1.0, 1.0);
uniform float velocity = 1.0;
uniform vec2 resolution = vec2(512,512);
uniform vec2 playerPos = vec2(0,0);

//--- hatsuyuki ---
// by Catzpaw 2016
//
// Modified for Godot; original code can be found at http://www.glslsandbox.com/e#36547.0
float snow(vec2 uv, float scale, float time)
{
//	float w = smoothstep(1.0, 0.0, -uv.y * (scale / 1.0));
//	if(w < 0.1)
//		return 0.0;
	uv += time / scale;
	uv.y += time * 2.0 / scale;
	uv.x += sin(uv.y + time * 0.5) / scale;
	uv *= scale;
	vec2 i = floor(uv);
	vec2 f = fract(uv);
	vec2 p;
	float k = 3.0;
	p = 0.5 + 0.35 * sin( 11.0 * fract(sin((i + p + scale) * mat2(vec2(7, 3), vec2(6, 5))) * 5.0))- f;
	float d = length(p);
	k = min(d,k);
	k = smoothstep(0.0, k, sin(f.x + f.y) * 0.01);
    return k; //k * w
}

void fragment(){
//	vec2 coord = UV * 20.0;
//
//	vec2 motion = vec2( fbm(coord - TIME * 0.5) );
//
//	float final = fbm(coord + motion);
//
//	COLOR = vec4(color, final * 0.5);
	float scale = 3.0;
	vec2 uv = ((UV) + playerPos / resolution);//(UV.xy*2.-resolution.xy)/min(resolution.x,resolution.y);
	//uv += playerPos / 256.0;
	float time = -TIME * velocity;
	//float c=smoothstep(1.,0.3,clamp(uv.y*.3+.8,0.,.75));
	float c=snow(uv, 30.0 * scale, time) * 0.3;
	c += snow(uv, 20.0 * scale, time) * 0.5;
	c += snow(uv, 15.0 * scale, time) * 0.8;
	c += snow(uv, 10.0 * scale, time);
	c += snow(uv, 8.0 * scale, time);
	c += snow(uv, 6.0 * scale, time);
	c += snow(uv, 5.0 * scale, time);
	COLOR = vec4(color,c);
}