public import derelict.sdl2.sdl;
public import derelict.sdl2.image;
import std.stdio;
import sprite;
import game;
import player;
import physics;
import platform;
import std.string;
alias Renderer = SDL_Renderer;
alias DrawRect = SDL_Rect;

private __gshared Renderer *renderer;

public struct DrawData {
	SDL_Texture *texture;
};

public interface Drawable {
	void draw(Renderer *r);
};


void draw_data_in_rect(Renderer *renderer, DrawData *dd, DrawRect *rect)
{
	SDL_RenderCopy(renderer, dd.texture, null, rect);
}

void load_draw_data(DrawData *dd, DrawRect *rect, string path)
{
	dd.texture = IMG_LoadTexture(renderer, path.toStringz);
	SDL_QueryTexture(dd.texture, null, null, &rect.w, &rect.h);
}

void cleanup_draw_data(DrawData *dd)
{
	SDL_DestroyTexture(dd.texture);
}

void render_update_loop()
{
	DerelictSDL2.load();
	DerelictSDL2Image.load();
	SDL_Init(SDL_INIT_VIDEO);
	auto window = SDL_CreateWindow("Test", SDL_WINDOWPOS_UNDEFINED, SDL_WINDOWPOS_UNDEFINED, 800, 600, 0);
	renderer = SDL_CreateRenderer(window, -1, 0);
	SDL_RenderClear(renderer);
	SDL_SetRenderDrawColor(renderer, 255, 0, 0, 255);
	SDL_RenderClear(renderer);

	current_game.driver = new GamePlayDriver();
	current_game.world = new World;
	Player p = new Player;
	p.bod.move(300, 300);
	p.bod.vel.data[1] = 1;
	current_game.current_draw_list ~= p;

	Platform g = new Platform;
	g.bod.move(200, 500);
	current_game.current_draw_list ~= g;

	current_game.world.objects ~= g.bod;
	current_game.world.objects ~= p.bod;
	current_game.current_active ~= p;
	long last = 0;
	long now = 0;
	while(true) {
		now = SDL_GetTicks();
		long dt = now - last;
		last = now;
		if(current_game.driver.update(dt / 1000.0)) {
			break;
		}
		current_game.driver.draw(renderer);
		SDL_RenderPresent(renderer);
	}
	SDL_DestroyWindow(window);
	SDL_Quit();
}

