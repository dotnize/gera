shader_type canvas_item;

void fragment() {
    // Get the vertex color or the color from the texture if set
    vec4 inputColor = min(texture(TEXTURE, UV), COLOR);

    if(AT_LIGHT_PASS) {
        // For all fragments in the light we just use the input color
        COLOR = inputColor;
    } else {
        // For all other fragments we make them B&W
		
		// original B&W color
		//float value = dot(inputColor.rgb, vec3(0.2126, 0.7152, 0.0722));
		
		// darker B&W color
        float value = dot(inputColor.rgb, vec3(0.2000, 0.7000, 0.0700));
        COLOR = vec4(value, value, value, 1.0);	
    }
}