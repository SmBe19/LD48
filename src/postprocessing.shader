shader_type canvas_item;

void fragment() {
	vec2 ps = SCREEN_PIXEL_SIZE;
	int off = 10;
	float coeff = 0.;
	vec4 sur = vec4(0);
	for (int dx = -off; dx <= off; dx++) {
		for (int dy = -off; dy <= off; dy++) {
			float acoeff = (float(off + 1) - abs(float(dx))) * (float(off + 1) - abs(float(dy)));
			coeff += acoeff;
			sur += acoeff * texture(TEXTURE, UV + vec2(float(dx) * ps.x, float(dy) * ps.y));
		}
	}
	sur /= coeff;

	vec4 col = texture(TEXTURE, UV);

	COLOR = vec4(col.rgb * 0.8 + sur.rgb * 0.6, col.a);
}