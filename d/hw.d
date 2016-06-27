import std.stdio, std.range, std.array, std.algorithm.sorting;
import std.random;
import core.thread, core.sync.mutex, core.atomic;

class Foo {
	int x;
};

void main()
{
	Foo[] list;
	Foo f = new Foo;
	f.x = 10;
	list ~= f;
	writeln(f.x, " ", list[0].x);

	list[0].x = 20;
	writeln(f.x, " ", list[0].x);

}

