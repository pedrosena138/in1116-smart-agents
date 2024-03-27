from .config import GOAL_STATE, EMPTY_VALUE, StateType
import numpy as np
from typing import Iterator, List
from .node import Node
from datetime import datetime


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
