import game;
import std.stdio;
import std.typecons;
const int MAXLAYERS = 4;
const int LAYER_PLAYER = 1;

const string[MAXLAYERS] layer_names = [
	"ground", "player", "enemy", ""
];

enum Direction {
	Up, Right, Down, Left
};

const int COLL_FLAG_EXCLUDE = 1;
const int COLL_FLAG_NOTIFY  = 2;

const int PHYSICS_STATIC = 1;

int [MAXLAYERS][MAXLAYERS] layer_matrix = [
	[ 0, 0, 0, 0 ],
	[ 1, 0, 0, 0 ],
	[ 0, 0, 0, 0 ],
	[ 0, 0, 0, 0 ],
];

public class Collision {
	Direction dir;
	const PhysicsObject * other;
	this(const PhysicsObject *o, Direction d) {
		other = o;
		dir = d;
	}
};

public struct Vector(int T) {
	float[T] data;
	Vector!(T) opOpAssign(string s)(Vector!(T) v) if (s == "+")
	{
		for(size_t i = 0;i<data.length;i++) {
			data[i] += v.data[i];
		}
		return this;
	};

	Vector!(T) opBinary(string s)(float scale) if (s == "*") {
		Vector!(T) v;
		for(size_t i = 0;i<data.length;i++) {
			v.data[i] = data[i] * scale;
		}
		return v;
	}

	Vector!(T) opBinary(string s)(Vector!(T) o) if (s == "*") {
		Vector!(T) v;
		for(size_t i = 0;i<data.length;i++) {
			v.data[i] = data[i] * o.data[i];
		}
		return v;
	}

};

import std.algorithm : remove;
public class PhysicsObject {
	int layer = 0, flags = 0;
	Vector!(2) pos = { data: [0, 0] };
	Vector!(2) vel = { data: [0, 0] };
	Vector!(2) acc = { data: [0, 0] };
	float w = 0.0, h = 0.0;
	float friction = 0.0;
	bool grounded = false;

	Collision[] collisions;

	void update(float dt)
	{
		bool up = true, down = true, left = true, right = true;
		grounded = false;
		foreach(Collision c; collisions) {
			if(c.dir == Direction.Up)
				up = false;
			if(c.dir == Direction.Down) {
				grounded = true;
				down = false;
			}
			if(c.dir == Direction.Left)
				left = false;
			if(c.dir == Direction.Right)
				right = false;
		}
		if(!(flags & PHYSICS_STATIC)) {
			vel += current_game.world.gravity * dt;
			writeln(up, " ", right, " ", down, " ", left);
		}
		vel += acc * dt;
		if(vel.data[0] > 0 && !right)
			vel.data[0] = 0;
		if(vel.data[0] < 0 && !left)
			vel.data[0] = 0;
		if(vel.data[1] > 0 && !down)
			vel.data[1] = 0;
		if(vel.data[1] < 0 && !up)
			vel.data[1] = 0;
		pos += vel * dt;
	}

	void move(float x, float y)
	{
		pos.data[0] = x;
		pos.data[1] = y;
	}

	void getpos(ref float x, ref float y)
	{
		x = pos.data[0];
		y = pos.data[1];
	}

	void collide_detect(const ref PhysicsObject other)
	{
		collisions = [];
		if (pos.data[0] < other.pos.data[0] + other.w
				&& pos.data[0] + w > other.pos.data[0]
				&& pos.data[1] < other.pos.data[1] + other.h
				&& h + pos.data[1] > other.pos.data[1]
				&& layer_matrix[layer][other.layer] != 0) {

			if(pos.data[1] >= other.pos.data[1] + other.h - 2) {
				collisions ~= new Collision(&other, Direction.Up);
			}

			if(pos.data[1] + h <= other.pos.data[1]+2) {
				collisions ~= new Collision(&other, Direction.Down);
			}

			if(pos.data[0] >= other.pos.data[0] + other.w-2) {
				collisions ~= new Collision(&other, Direction.Left);
			}

			if(pos.data[0] + w <= other.pos.data[0]+2) {
				collisions ~= new Collision(&other, Direction.Right);
			}

		}
	}
}

class World {
	PhysicsObject[] objects;
	Vector!(2) gravity = { data: [0, 9.8 * 10] };

	void update(float dt)
	{
		for(float i = 0.002; i < dt; i+=0.002) {
			foreach(PhysicsObject po; objects) {
				foreach(PhysicsObject po2; objects) {
					if(po != po2)
						po.collide_detect(po2);
				}
				po.update(0.002);
			}
		}
	}
};

