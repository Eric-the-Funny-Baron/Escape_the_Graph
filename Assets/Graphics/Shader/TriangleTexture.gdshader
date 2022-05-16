shader_type canvas_item;

uniform float thickness;
uniform float size;
uniform vec3 color1;
uniform vec3 color2;

vec2 rotate(float degree, vec2 input) {
	float rad_of_deg = radians(degree);
	mat2 rotationMatrix = mat2(
								vec2(cos(rad_of_deg), sin(rad_of_deg)), 
								vec2(-sin(rad_of_deg), cos(rad_of_deg))
							);
							
	return rotationMatrix * input;
}

vec2 scale(float xSize, float ySize, vec2 input) {
	mat2 scaleMatrix = mat2(vec2(xSize, 0.0), vec2(0.0, ySize));
	return scaleMatrix * input;
}

void fragment() {
	vec2 scaled_uv = scale(size, size, UV);
	vec2 mod_uv_0 = rotate(0.0, scaled_uv);
	vec2 mod_uv_60 = rotate(60.0, scaled_uv);
	vec2 mod_uv_120 = rotate(120.0, scaled_uv); 
	vec3 pixelColor = vec3(sin(mod_uv_0.y + thickness*2.0));
	pixelColor = step(pixelColor, vec3(thickness));
	pixelColor *= step(vec3(sin(mod_uv_60.y)), vec3(thickness));
	pixelColor *= step(vec3(sin(mod_uv_120.y)),vec3(thickness));
	
	vec3 mixColor = mix(color1, color2, pixelColor);
	COLOR = vec4(mixColor, 1.0);
}