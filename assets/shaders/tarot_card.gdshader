shader_type canvas_item;

void vertex() {

	if (VERTEX.y == 0.0){
		VERTEX += vec2(sin(TIME) * 2.5, 0);
	}

	if (VERTEX.y > 0.0){
		VERTEX += -vec2(sin(TIME) * 2.5, 0);
	}

}

void fragment() {
	// Called for every pixel the material is visible on.
}
