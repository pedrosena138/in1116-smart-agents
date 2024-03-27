from heuristic_search.eight_puzzle.config import EMPTY_VALUE
from .puzzle import Puzzle


def main():
    init_state = [[EMPTY_VALUE, 1, 2], [4, 5, 3], [7, 8, 6]]
    puzzle = Puzzle(init_state=init_state)
    puzzle.start()


if __name__ == '__main__':
    main()
