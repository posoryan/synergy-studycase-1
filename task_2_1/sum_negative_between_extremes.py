"""Кейс-задача 2.1: сумма отрицательных между max и min."""

from __future__ import annotations

import sys
from dataclasses import dataclass


@dataclass(frozen=True)
class ArrayAnalysis:
    arr: list[float]
    max_val: float | None
    min_val: float | None
    max_index: int | None
    min_index: int | None
    between: list[float]
    negatives: list[float]
    result: float


def sum_negative_between_extremes(arr: list[float]) -> float:
    return analyze_array(arr).result


def analyze_array(arr: list[float]) -> ArrayAnalysis:
    if len(arr) < 2:
        return ArrayAnalysis(arr, None, None, None, None, [], [], 0.0)

    max_val = max(arr)
    min_val = min(arr)
    max_index = arr.index(max_val)
    min_index = arr.index(min_val)

    if max_index == min_index:
        return ArrayAnalysis(arr, max_val, min_val, max_index, min_index, [], [], 0.0)

    start = min(max_index, min_index) + 1
    end = max(max_index, min_index)
    between = arr[start:end]
    negatives = [x for x in between if x < 0]

    return ArrayAnalysis(
        arr=arr,
        max_val=max_val,
        min_val=min_val,
        max_index=max_index,
        min_index=min_index,
        between=between,
        negatives=negatives,
        result=float(sum(negatives)),
    )


def read_array_from_input() -> list[float]:
    n = int(input("N: "))
    if n <= 0:
        raise ValueError("N должно быть > 0")

    values = list(map(float, input(f"{n} чисел через пробел: ").split()))
    if len(values) != n:
        raise ValueError(f"ожидалось {n}, получено {len(values)}")

    return values


def print_result(arr: list[float]) -> None:
    a = analyze_array(arr)
    print(f"массив: {a.arr}")
    print(f"max: {a.max_val:g} (@{a.max_index})  min: {a.min_val:g} (@{a.min_index})")
    print(f"между: {a.between if a.between else '—'}")
    print(f"отрицательные: {a.negatives if a.negatives else '—'}")
    print(f"сумма: {a.result:g}")


def main() -> None:
    if len(sys.argv) > 1:
        try:
            arr = [float(x) for x in sys.argv[1:]]
        except ValueError:
            print("ошибка: аргументы должны быть числами")
            print("пример: python sum_negative_between_extremes.py 8 -1 -2 -3 2")
            return
        if not arr:
            print("ошибка: передайте хотя бы одно число")
            return
        print_result(arr)
        return

    try:
        arr = read_array_from_input()
    except ValueError as e:
        print(f"ошибка ввода: {e}")
        return

    print_result(arr)


if __name__ == "__main__":
    main()
