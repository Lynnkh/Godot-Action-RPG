shader_type canvas_item;

// 開啟
uniform bool active = false;

void fragment() {
	// 獲取精靈顏色
	vec4 previous_color = texture(TEXTURE,UV);
	// 顏色變成純白，但透明度不變
	vec4 white_color = vec4(1.0,1.0,1.0,previous_color.a);

	// 輸出的顏色
	vec4 new_color = previous_color;
	if (active == true) {
		new_color = white_color;
	}else {
		new_color = previous_color;
	}
	// 輸出顏色
	COLOR = vec4(new_color);
}