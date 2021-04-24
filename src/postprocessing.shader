shader_type canvas_item;

vec4 sample_pixel(sampler2D tex, vec2 uv) {
	return texture(tex, uv);
}

void fragment() {
	vec2 ps = SCREEN_PIXEL_SIZE;
	vec4 sur = vec4(0);
	for (int i = -4; i <= 4; i++) {
		sur += sample_pixel(TEXTURE, UV + vec2(float(i) * ps.x, 0));
	}
	for (int i = -4; i <= 4; i++) {
		sur += sample_pixel(TEXTURE, UV + vec2(0, float(i) * ps.y));
	}
	sur /= 18.0;

	vec4 col = texture(TEXTURE, UV);

	COLOR = vec4(col.rgb * 0.75 + sur.rgb * 0.5, col.a);
}