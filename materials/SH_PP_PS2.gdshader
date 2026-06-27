shader_type canvas_item;

uniform float pixelation : hint_range(1.0, 4096.0) = 2048.0;
uniform float color_Levels : hint_range(1.0, 256.0) = 40.0;

uniform sampler2D screen_texture : hint_screen_texture, filter_nearest;

void fragment(){ 
	vec2 uv = SCREEN_UV;
	
	uv = floor(uv * pixelation) / pixelation;
	
	vec3 screen_color = texture(screen_texture, uv).rgb;
	
	screen_color = ceil(screen_color * color_Levels) / color_Levels;
	
	COLOR = vec4(screen_color, 1.0);
}