from enum import Enum
from typing import List, Dict, Tuple

StateType = List[List[int]]


class ActionEnum(Enum):
    START = (0, 0)
    LEFT = (0, -1)
    RIGHT = (0, 1)
    UP = (-1, 0)
    DOWN = (1, 0)


def get_state_positions(state: StateType) -> Dict[int, Tuple[int, int]]:
    return {
        state[row][col]: (row, col) for row in range(3) for col in range(3)
    }


GOAL_STATE: StateType = [
    [1, 2, 3],
    [4, 5, 6],
    [7, 8, 0]
]

GOAL_POSITIONS = get_state_positions(GOAL_STATE)

EMPTY_VALUE = 0
