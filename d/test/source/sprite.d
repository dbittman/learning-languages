import drawing;
public class Sprite : Drawable {
	DrawRect dr;
	DrawData dd;
	void draw(Renderer *r) {
		draw_data_in_rect(r, &dd, &dr);
	};

	this(string name) {
		load_draw_data(&dd, &dr, name);
		dr.x = 400;
		dr.y = 300;
	};

	~this() {
		cleanup_draw_data(&dd);
	}
}

