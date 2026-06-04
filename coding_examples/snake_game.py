# ============================================================================
#  Python Snake Game — Terminal Edition
#  Same logic as snake_game.nova for direct comparison.
# ============================================================================

from dataclasses import dataclass
from enum import Enum, auto
from typing import List, Optional
import math

# --- Data types ---

@dataclass
class Point:
    x: int
    y: int

    def eq(self, other: 'Point') -> bool:
        return self.x == other.x and self.y == other.y

    def to_string(self) -> str:
        return f"({self.x},{self.y})"

class Direction(Enum):
    Up = auto()
    Down = auto()
    Left = auto()
    Right = auto()

@dataclass
class GameState:
    snake: List[Point]
    dir: Direction
    food: Point
    score: int
    width: int
    height: int
    alive: bool
    ticks: int

# --- Direction helpers ---

def direction_dx(d: Direction) -> int:
    if d == Direction.Left: return -1
    if d == Direction.Right: return 1
    return 0

def direction_dy(d: Direction) -> int:
    if d == Direction.Up: return -1
    if d == Direction.Down: return 1
    return 0

def opposite_dir(d1: Direction, d2: Direction) -> bool:
    return (direction_dx(d1) + direction_dx(d2) == 0 and
            direction_dy(d1) + direction_dy(d2) == 0)

# --- Pseudo-random number generator (LCG) ---

_rng_state = 42

def rand_next() -> int:
    global _rng_state
    _rng_state = (_rng_state * 1103515245 + 12345) % 2147483648
    return _rng_state

def rand_range(lo: int, hi: int) -> int:
    r = rand_next()
    if r < 0: r = -r
    return lo + (r % (hi - lo))

# --- Point-in-list check ---

def list_contains_point(lst: List[Point], pt: Point) -> bool:
    for p in lst:
        if p.x == pt.x and p.y == pt.y:
            return True
    return False

# --- Spawn food at random empty cell ---

def spawn_food(snake: List[Point], w: int, h: int) -> Point:
    for _ in range(1000):
        fx = rand_range(0, w)
        fy = rand_range(0, h)
        pt = Point(fx, fy)
        if not list_contains_point(snake, pt):
            return pt
    return Point(0, 0)

# --- Create initial game ---

def new_game(w: int, h: int) -> GameState:
    cx = w // 2
    cy = h // 2
    snake = [
        Point(cx, cy),
        Point(cx - 1, cy),
        Point(cx - 2, cy)
    ]
    food = spawn_food(snake, w, h)
    return GameState(
        snake=snake,
        dir=Direction.Right,
        food=food,
        score=0,
        width=w,
        height=h,
        alive=True,
        ticks=0
    )

# --- One game tick: move, eat, collide ---

def tick(game: GameState, new_dir: Direction) -> GameState:
    if not game.alive:
        return game

    dir = game.dir
    if not opposite_dir(dir, new_dir):
        dir = new_dir

    head = game.snake[0]
    nx = head.x + direction_dx(dir)
    ny = head.y + direction_dy(dir)

    # Wall collision
    if nx < 0 or nx >= game.width or ny < 0 or ny >= game.height:
        return GameState(
            snake=game.snake, dir=dir, food=game.food,
            score=game.score, width=game.width, height=game.height,
            alive=False, ticks=game.ticks + 1
        )

    new_head = Point(nx, ny)

    # Self collision
    if list_contains_point(game.snake, new_head):
        return GameState(
            snake=game.snake, dir=dir, food=game.food,
            score=game.score, width=game.width, height=game.height,
            alive=False, ticks=game.ticks + 1
        )

    # Move: build new snake with head prepended
    ate = new_head.x == game.food.x and new_head.y == game.food.y
    limit = len(game.snake) if ate else len(game.snake) - 1
    new_snake = [new_head] + game.snake[:limit]

    new_score = game.score
    new_food = game.food
    if ate:
        new_score += 10
        new_food = spawn_food(new_snake, game.width, game.height)

    return GameState(
        snake=new_snake, dir=dir, food=new_food,
        score=new_score, width=game.width, height=game.height,
        alive=True, ticks=game.ticks + 1
    )

# --- Render game board to terminal ---

def render(game: GameState) -> None:
    top = "+" + "--" * game.width + "+"
    print(top)

    for y in range(game.height):
        row = "|"
        for x in range(game.width):
            pt = Point(x, y)
            if pt.x == game.snake[0].x and pt.y == game.snake[0].y:
                row += "@@"
            elif list_contains_point(game.snake, pt):
                row += "##"
            elif pt.x == game.food.x and pt.y == game.food.y:
                row += "<>"
            else:
                row += "  "
        row += "|"
        print(row)

    print(top)
    print(f"  Score: {game.score}  |  Length: {len(game.snake)}  |  Tick: {game.ticks}")

# --- Auto-play: simple AI that chases food ---

def auto_dir(game: GameState) -> Direction:
    head = game.snake[0]
    dx = game.food.x - head.x
    dy = game.food.y - head.y

    if abs(dx) >= abs(dy):
        if dx > 0: return Direction.Right
        if dx < 0: return Direction.Left
    if dy > 0: return Direction.Down
    if dy < 0: return Direction.Up
    return game.dir

# --- Main ---

def main():
    print("========================================")
    print("  Python Snake Game — Auto-Play Demo")
    print("  For comparison with NOVA version.")
    print("========================================")
    print()

    game = new_game(20, 15)
    render(game)

    for step in range(60):
        if not game.alive:
            break
        d = auto_dir(game)
        game = tick(game, d)

        if step % 10 == 9:
            print()
            print(f"--- After {step + 1} moves ---")
            render(game)

    print()
    if game.alive:
        print(f"Game still running after {game.ticks} ticks!")
    else:
        print(f"Game over at tick {game.ticks}!")
    print(f"Final score: {game.score}")
    print(f"Final length: {len(game.snake)}")

if __name__ == "__main__":
    main()
