shader_type canvas_item;
render_mode unshaded;

uniform vec4 level1 : source_color = vec4(0,0,0,1);
uniform vec4 level2 : source_color = vec4(0.5,0.5,0.5,1);
uniform vec4 level3 : source_color = vec4(1,1,1,1);
uniform vec4 level4 : source_color = vec4(1,1,1,1);

uniform float threshold1 	: hint_range(0.0,1.0) = .1;
uniform float threshold2 	: hint_range(0.0,1.0) = .4;
uniform float threshold3	: hint_range(0.0,1.0) = .6;
uniform sampler2D SCREEN_TEXTURE : hint_screen_texture, filter_linear_mipmap;

void fragment() {
	vec2 Resolution = 1.0 / SCREEN_PIXEL_SIZE; 
	vec2 uv = FRAGCOORD.xy / Resolution.xy;
	vec4 color = texture(SCREEN_TEXTURE, uv);
	float rgb_avg = (color.r + color.g + color.b)/3.0;
	if(rgb_avg < threshold1){
		COLOR = color+level1;
	}else if(rgb_avg < threshold2){
		COLOR = color+level2;
	}else if(rgb_avg < threshold3){
		COLOR = color+level3;
	}else{
		COLOR = color+level4;
	}
}