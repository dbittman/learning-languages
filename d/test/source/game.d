import drawing;
import physics;
import std.stdio;
interface Updatable {
	public void update(float dt);
};

interface Driver {
	public void draw(Renderer *);
	public bool update(float dt);
};

class GamePlayDriver : Driver {
	public void draw(Renderer *renderer)
	{
		SDL_RenderClear(renderer);
		foreach(Drawable d; current_game.current_draw_list) {
			d.draw(renderer);
		}
	}
	public bool update(float dt)
	{
		SDL_Event e;
		if(SDL_PollEvent(&e)) {
			if(e.type == SDL_QUIT
					|| e.type == SDL_KEYUP && e.key.keysym.sym == SDLK_ESCAPE)
				return true;

			if(e.type == SDL_KEYDOWN || e.type == SDL_KEYUP) {
				switch(e.key.keysym.sym) {
					case SDLK_LEFT:
						current_game.left = e.type == SDL_KEYDOWN;
						break;
					case SDLK_RIGHT:
						current_game.right = e.type == SDL_KEYDOWN;
						break;
					case SDLK_SPACE:
						current_game.jump = e.type == SDL_KEYDOWN;
						break;
					default: break;
				}
			}
		}

		current_game.world.update(dt);
		foreach(Updatable u; current_game.current_active) {
			u.update(dt);
		}
		return false;
	}
};

class Game {
	Updatable[] current_active;
	Drawable[] current_draw_list;
	World world;
	Driver driver;
	bool left, right, up, down, jump, shoot;
};

public __gshared Game current_game = new Game;

