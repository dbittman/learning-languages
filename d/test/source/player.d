import drawing;
import physics;
import sprite;
import std.math, std.algorithm : clamp;
import std.stdio;
import game;
class Player : Drawable, Updatable {
	PhysicsObject bod;
	Sprite sprite;

	this() {
		sprite = new Sprite("sprite.png");
		bod = new PhysicsObject;
		bod.w = sprite.dr.w;
		bod.h = sprite.dr.h;
		bod.layer = LAYER_PLAYER;
	}

	void draw(Renderer *r)
	{
		float x, y;
		bod.getpos(x, y);
		sprite.dr.x = cast(int)round(x);
		sprite.dr.y = cast(int)round(y);
		sprite.draw(r);
	}

	void update(float dt)
	{
		float l = 0;
		if(current_game.left) l -= 5;
		if(current_game.right) l += 5;
		bod.vel.data[0] += l;
		bod.vel.data[0] = clamp(bod.vel.data[0], -100, 100);

		if(current_game.jump && bod.grounded) {
			bod.vel.data[1] -= 20;
		}
	}

};

