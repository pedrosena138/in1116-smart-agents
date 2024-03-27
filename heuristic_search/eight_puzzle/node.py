# type: ignore
from typing import List, Tuple
from copy import deepcopy
from heuristic_search.eight_puzzle.config import EMPTY_VALUE, GOAL_POSITIONS, ActionEnum, StateType, get_state_positions


def manhattan_distance(state: StateType):
    """Calculate Manhattan distance between two states"""
    distance = 0
    for x in range(3):
        for y in range(3):
            index = state[x][y]
            if index != EMPTY_VALUE:
                goal_x, goal_y = GOAL_POSITIONS[index]
                distance += abs(goal_x - x) + abs(goal_y - y)
    return distance


class Node:
    def __init__(
            self,
            state: StateType,
            action: ActionEnum = ActionEnum.START,
            g: int = 0,
            parent: 'Node' = None
    ):
        self.state = state
        self.action = action
        self.g = g
        self.parent = parent

    def children(self) -> List['Node']:
        """Generate node children"""
        empty_x, empty_y = self._empty_position()

        nodes: List[Node] = []
        actions: List[ActionEnum] = []

        if not empty_x-1 < 0:
            actions.append(ActionEnum.UP)
        if empty_x+1 < 3:
            actions.append(ActionEnum.DOWN)
        if not empty_y-1 < 0:
            actions.append(ActionEnum.LEFT)
        if empty_y+1 < 3:
            actions.append(ActionEnum.RIGHT)

        for action in actions:
            state = deepcopy(self.state)

            move_x, move_y = action.value
            new_x = empty_x + move_x
            new_y = empty_y + move_y

            state[empty_x][empty_y] = state[new_x][new_y]
            state[new_x][new_y] = EMPTY_VALUE

            node = Node(
                state=state,
                action=action,
                g=self.g+1,
                parent=self
            )
            nodes.append(node)

        return nodes

    def cost(self) -> int:
        """Calculate f(n) = g(n) + h(n)"""
        return self.g + self.h()

    def h(self) -> int:
        """Calculate heuristic function"""
        return manhattan_distance(self.state)

    def traceback(self) -> List['Node']:
        """Generate traceback path from root"""
        path: List[Node] = []
        path.append(self)
        node = self.parent

        while node.parent is not None:
            path.append(node)
            node = node.parent
        path.append(node)
        path.reverse()
        return path

    def _empty_position(self) -> Tuple[int, int]:
        """Get empty positon from current state"""
        positions = get_state_positions(self.state)
        row, col = positions[EMPTY_VALUE]
        return row, col

    def __repr__(self) -> str:
        f = self.cost()
        h = self.h()
        return f'Node(action={self.action.name}, g(n)={self.g}, h(n)={h}, f(n)={f})'

    def __str__(self) -> str:
        f = self.cost()
        h = self.h()
        return f'Node(action={self.action.name}, g(n)={self.g}, h(n)={h}, f(n)={f})'
