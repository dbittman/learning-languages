import physics;
import drawing;
import sprite;
import std.math;
class Platform : Drawable {
	PhysicsObject bod;
	Sprite sprite;

	this() {
		sprite = new Sprite("platform.png");
		bod = new PhysicsObject;
		bod.w = sprite.dr.w;
		bod.h = sprite.dr.h;
		bod.flags |= PHYSICS_STATIC;
	}

	void draw(Renderer *r)
	{
		float x, y;
		bod.getpos(x, y);
		sprite.dr.x = cast(int)round(x);
		sprite.dr.y = cast(int)round(y);
		sprite.draw(r);
	}
};
