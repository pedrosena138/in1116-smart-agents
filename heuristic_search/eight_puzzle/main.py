# from eight_puzzle.config import EMPTY_VALUE
# from eight_puzzle.puzzle import Puzzle
from copy import deepcopy
from datetime import datetime
from enum import Enum
from typing import Dict, Iterator, List, Tuple

import numpy as np

StateType = List[List[int]]


def get_state_positions(state: StateType) -> Dict[int, Tuple[int, int]]:
    return {
        state[row][col]: (row, col) for row in range(3) for col in range(3)
    }


EMPTY_VALUE = 0

GOAL_STATE: StateType = [
    [1, 2, 3],
    [4, 5, 6],
    [7, 8, EMPTY_VALUE]
]

GOAL_POSITIONS = get_state_positions(GOAL_STATE)


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


class ActionEnum(Enum):
    START = (0, 0)
    LEFT = (0, -1)
    RIGHT = (0, 1)
    UP = (-1, 0)
    DOWN = (1, 0)


class Node:
    def __init__(
            self,
            state: StateType,
            action: ActionEnum = ActionEnum.START,
            g: int = 0,
            parent: 'Node' = None  # type: ignore
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


class PriorityQueue:
    def __init__(self):
        self.queue = []

    def empty(self) -> bool:
        return len(self.queue) == 0

    def sort(self) -> None:
        self.queue = sorted(
            self.queue, key=lambda x: x.cost())

    def enqueue(self, node: Node) -> None:
        self.queue.append(node)
        self.sort()

    # for popping an element based on Priority
    def dequeue(self) -> Node:
        item: Node = self.queue.pop(0)
        return item

    def __str__(self) -> str:
        return '; '.join([str(n) for n in self.queue])

    def __iter__(self) -> Iterator:
        return self.queue.__iter__()


class Puzzle:
    def __init__(self, init_state: StateType):
        self.init_state = init_state
        self.goal_state: StateType = GOAL_STATE

        self._is_solvable()

    def start(self) -> None:
        queue = PriorityQueue()
        init_node = Node(self.init_state)
        queue.enqueue(init_node)
        i = 0
        self._save_frontier(
            f'-----------------------{datetime.now()}-----------------------------------------')
        while not queue.empty():
            self._save_frontier(f'Frontier {i}: [{queue}]')
            node = queue.dequeue()

            if node.state == self.goal_state:
                self._save_frontier(f'Final Frontier: [{queue}]')
                self._save_frontier(
                    '------------------------------------------------------------------------------------------\n')
                self._draw_path(node.traceback())
                return

            for child in node.children():
                queue.enqueue(child)
            i += 1

    def _draw_path(self, path: List[Node]) -> None:
        for node in path:
            print(f'\n{node}')
            self._draw_state(node.state)

    def _draw_state(self, state: StateType) -> None:
        print('________________')
        for i in state:
            print('  %d  |  %d  |  %d' % (i[0], i[1], i[2]))
            print('________________')

    def _is_solvable(self) -> None:
        inv_count = 0
        arr = np.array(np.matrix(self.init_state, dtype=int).flatten())[0]

        for i in range(0, 9):
            for j in range(i + 1, 9):
                if arr[j] != EMPTY_VALUE and arr[i] != EMPTY_VALUE and arr[i] > arr[j]:
                    inv_count += 1

        # return true if inversion count is even
        if inv_count % 2 != 0:
            raise Exception(
                f'Init state is not solvable: {self.init_state}')

    def _save_frontier(self, text: str) -> None:
        with open('./frontier.txt', mode='a', encoding='utf-8') as file:
            file.write(text + '\n')


def main():
    init_state = [[EMPTY_VALUE, 1, 2], [4, 5, 3], [7, 8, 6]]
    puzzle = Puzzle(init_state=init_state)
    puzzle.start()


if __name__ == '__main__':
    main()
