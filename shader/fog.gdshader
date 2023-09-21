shader_type canvas_item;

uniform sampler2D SCREEN_TEXTURE : hint_screen_texture, repeat_disable, filter_nearest;

uniform vec2 direction = vec2(1, 0);
uniform float speed = 0.1;
uniform sampler2D noise: repeat_enable;

vec4 overlay(vec4 base, vec4 blend){
	vec4 limit = step(0.5, base);
	return mix(2.0 * base * blend, 1.0 - 2.0 * (1.0 - base) * (1.0 - blend), limit);
}

void fragment()
{
	vec4 base = texture(SCREEN_TEXTURE, UV);
	vec4 blend = texture(noise, SCREEN_UV + (direction * speed * TIME));

	COLOR = overlay(base, blend);
}
