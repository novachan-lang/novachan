// ============================================================================
//  C++ Snake Game — REAL Interactive Terminal Game (Windows)
//  Use arrow keys to play. Press Q to quit.
// ============================================================================

#include <iostream>
#include <vector>
#include <cstdlib>
#include <ctime>
#include <conio.h>
#include <windows.h>

struct Point { int x, y; };

enum Direction { UP, DOWN, LEFT, RIGHT };

struct Game {
    std::vector<Point> snake;
    Direction dir;
    Point food;
    int score;
    int width;
    int height;
    bool alive;
};

void set_cursor(int x, int y) {
    COORD pos = {(SHORT)x, (SHORT)y};
    SetConsoleCursorPosition(GetStdHandle(STD_OUTPUT_HANDLE), pos);
}

void hide_cursor() {
    CONSOLE_CURSOR_INFO ci = {1, FALSE};
    SetConsoleCursorInfo(GetStdHandle(STD_OUTPUT_HANDLE), &ci);
}

void show_cursor() {
    CONSOLE_CURSOR_INFO ci = {1, TRUE};
    SetConsoleCursorInfo(GetStdHandle(STD_OUTPUT_HANDLE), &ci);
}

bool contains(const std::vector<Point>& pts, int x, int y) {
    for (const auto& p : pts)
        if (p.x == x && p.y == y) return true;
    return false;
}

void spawn_food(Game& g) {
    do {
        g.food.x = rand() % g.width;
        g.food.y = rand() % g.height;
    } while (contains(g.snake, g.food.x, g.food.y));
}

Game new_game(int w, int h) {
    Game g;
    g.width = w;
    g.height = h;
    g.dir = RIGHT;
    g.score = 0;
    g.alive = true;
    int cx = w / 2, cy = h / 2;
    g.snake = {{cx, cy}, {cx-1, cy}, {cx-2, cy}};
    spawn_food(g);
    return g;
}

void render(const Game& g) {
    set_cursor(0, 0);

    // Title
    std::cout << "  SNAKE GAME  |  Score: " << g.score
              << "  |  Length: " << g.snake.size()
              << "       " << std::endl;
    std::cout << "  Arrow keys = move  |  Q = quit" << std::endl;

    // Top border
    std::cout << "+";
    for (int i = 0; i < g.width; i++) std::cout << "--";
    std::cout << "+" << std::endl;

    // Board
    for (int y = 0; y < g.height; y++) {
        std::cout << "|";
        for (int x = 0; x < g.width; x++) {
            if (x == g.snake[0].x && y == g.snake[0].y)
                std::cout << "@@";
            else if (contains(g.snake, x, y))
                std::cout << "##";
            else if (x == g.food.x && y == g.food.y)
                std::cout << "<>";
            else
                std::cout << "  ";
        }
        std::cout << "|" << std::endl;
    }

    // Bottom border
    std::cout << "+";
    for (int i = 0; i < g.width; i++) std::cout << "--";
    std::cout << "+" << std::endl;
}

void tick(Game& g) {
    Point head = g.snake[0];
    switch (g.dir) {
        case UP:    head.y--; break;
        case DOWN:  head.y++; break;
        case LEFT:  head.x--; break;
        case RIGHT: head.x++; break;
    }

    // Wall collision
    if (head.x < 0 || head.x >= g.width || head.y < 0 || head.y >= g.height) {
        g.alive = false;
        return;
    }

    // Self collision
    if (contains(g.snake, head.x, head.y)) {
        g.alive = false;
        return;
    }

    g.snake.insert(g.snake.begin(), head);

    // Eat food
    if (head.x == g.food.x && head.y == g.food.y) {
        g.score += 10;
        spawn_food(g);
    } else {
        g.snake.pop_back();
    }
}

int main() {
    srand((unsigned)time(nullptr));
    system("cls");
    hide_cursor();

    Game game = new_game(20, 15);

    while (game.alive) {
        render(game);

        // Non-blocking input
        int wait = 0;
        while (wait < 150) {
            if (_kbhit()) {
                int ch = _getch();
                if (ch == 'q' || ch == 'Q') {
                    game.alive = false;
                    break;
                }
                if (ch == 0 || ch == 224) {
                    ch = _getch();
                    switch (ch) {
                        case 72: if (game.dir != DOWN)  game.dir = UP;    break;
                        case 80: if (game.dir != UP)    game.dir = DOWN;  break;
                        case 75: if (game.dir != RIGHT) game.dir = LEFT;  break;
                        case 77: if (game.dir != LEFT)  game.dir = RIGHT; break;
                    }
                }
            }
            Sleep(10);
            wait += 10;
        }

        if (game.alive) tick(game);
    }

    show_cursor();
    set_cursor(0, game.height + 5);
    std::cout << std::endl;
    std::cout << "  GAME OVER!" << std::endl;
    std::cout << "  Final Score: " << game.score << std::endl;
    std::cout << "  Snake Length: " << game.snake.size() << std::endl;
    std::cout << std::endl;
    std::cout << "  Press any key to exit..." << std::endl;
    _getch();

    return 0;
}
