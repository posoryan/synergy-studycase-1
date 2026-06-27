"""Тесты задачи 2.1. Запуск: python test_sum_negative.py"""

from __future__ import annotations

import unittest

from sum_negative_between_extremes import analyze_array, sum_negative_between_extremes

ORDERED_TESTS = [
    ("Основной пример", [8, -1, -2, -3, 2], -3),
    ("Нет отрицательных между", [1, 5, 2, 9, 3], 0),
    ("Max в начале", [20, -3, -5, -7, 10], -8),
    ("Один элемент", [5], 0),
    ("Два соседних", [5, -2], 0),
    ("Все одинаковые", [4, 4, 4], 0),
    ("Max 0, min в середине", [5, -2, -3, -1], -2),
    ("Max и min соседи", [3, -1, -2, 7, -4, 1], 0),
    ("Пустой массив", [], 0),
    ("Первое вхождение max", [9, -1, -2, 1, 5, 9], -1),
    ("Min слева, max справа", [-5, 2, 3, 10], 0),
    ("Ноль не отрицательный", [5, 0, 0, -3, 1], 0),
    ("Дробные числа", [5.0, -1.2, 2.0, -4.1], -1.2),
]


def format_report(n: int, total: int, title: str, arr: list[float], expected: float) -> str:
    a = analyze_array(arr)
    ok = a.result == expected
    lines = [
        f"[{n}/{total}] {title}",
        f"  массив: {arr}",
    ]
    if a.max_val is not None:
        lines.append(f"  max: {a.max_val:g} (индекс {a.max_index})  min: {a.min_val:g} (индекс {a.min_index})")
        lines.append(f"  между: {a.between if a.between else '-'}")
        lines.append(f"  отрицательные: {a.negatives if a.negatives else '-'}")
    lines.append(f"  ожидание: {expected:g}  факт: {a.result:g}  -> {'OK' if ok else 'FAIL'}")
    return "\n".join(lines)


class TestSumNegativeBetweenExtremes(unittest.TestCase):
    def test_01(self):
        self._run(1, *ORDERED_TESTS[0])

    def test_02(self):
        self._run(2, *ORDERED_TESTS[1])

    def test_03(self):
        self._run(3, *ORDERED_TESTS[2])

    def test_04(self):
        self._run(4, *ORDERED_TESTS[3])

    def test_05(self):
        self._run(5, *ORDERED_TESTS[4])

    def test_06(self):
        self._run(6, *ORDERED_TESTS[5])

    def test_07(self):
        self._run(7, *ORDERED_TESTS[6])

    def test_08(self):
        self._run(8, *ORDERED_TESTS[7])

    def test_09(self):
        self._run(9, *ORDERED_TESTS[8])

    def test_10(self):
        self._run(10, *ORDERED_TESTS[9])

    def test_11(self):
        self._run(11, *ORDERED_TESTS[10])

    def test_12(self):
        self._run(12, *ORDERED_TESTS[11])

    def test_13(self):
        self._run(13, *ORDERED_TESTS[12])

    def _run(self, n: int, title: str, arr: list[float], expected: float) -> None:
        print(format_report(n, len(ORDERED_TESTS), title, arr, expected))
        self.assertEqual(sum_negative_between_extremes(arr), expected)


def build_suite() -> unittest.TestSuite:
    suite = unittest.TestSuite()
    loader = unittest.TestLoader()
    for i in range(1, len(ORDERED_TESTS) + 1):
        suite.addTest(loader.loadTestsFromName(f"test_{i:02d}", TestSumNegativeBetweenExtremes))
    return suite


if __name__ == "__main__":
    print("тесты 2.1\n")
    result = unittest.TextTestRunner(verbosity=0).run(build_suite())
    print()
    if result.wasSuccessful():
        print(f"итог: {len(ORDERED_TESTS)}/{len(ORDERED_TESTS)} пройдено")
    else:
        print(f"итог: failures={len(result.failures)}, errors={len(result.errors)}")
