"""Тесты задачи 2.2. Запуск: python test_vehicle_demo.py"""

from __future__ import annotations

import unittest

from vehicle_demo import Bicycle, Car, Vehicle

ORDERED_TESTS = [
    "test_01_car_creation",
    "test_02_bicycle_creation",
    "test_03_car_refuel_and_move",
    "test_04_bicycle_gear_and_move",
    "test_05_service_check_override",
    "test_06_polymorphism",
    "test_07_inheritance_checks",
    "test_08_invalid_input",
]

TOTAL = len(ORDERED_TESTS)


def print_block(number: int, title: str, lines: list[str], ok: bool) -> None:
    print(f"[{number}/{TOTAL}] {title}")
    for line in lines:
        print(f"  {line}")
    print(f"  -> {'OK' if ok else 'FAIL'}")
    print()


class TestVehicleDemo(unittest.TestCase):
    def test_01_car_creation(self):
        """Создание объекта Car и вызов метода базового класса get_info()."""
        car = Car("Toyota", "Camry", 2022, "бензин", 60.0)
        info = car.get_info()
        lines = [
            "класс: Car, наследует Vehicle",
            'вызов: Car("Toyota", "Camry", 2022, "бензин", 60.0)',
            f"get_info(): {info}",
            f"пробег (mileage): {car.mileage}",
            "проверка: brand == Toyota, пробег == 0",
        ]
        ok = car.brand == "Toyota" and car.mileage == 0.0
        print_block(1, "Создание Car", lines, ok)
        self.assertEqual(car.brand, "Toyota")
        self.assertEqual(car.mileage, 0.0)

    def test_02_bicycle_creation(self):
        """Создание Bicycle и проверка полей наследника."""
        bike = Bicycle("Trek", "Marlin 7", 2023, 21)
        info = bike.get_info()
        lines = [
            "класс: Bicycle, наследует Vehicle",
            'вызов: Bicycle("Trek", "Marlin 7", 2023, 21)',
            f"get_info(): {info}",
            f"передач (gears): {bike.gears}",
            "проверка: в get_info() есть Trek, gears == 21",
        ]
        ok = "Trek" in info and bike.gears == 21
        print_block(2, "Создание Bicycle", lines, ok)
        self.assertEqual(bike.gears, 21)
        self.assertIn("Trek", info)

    def test_03_car_refuel_and_move(self):
        """Методы наследника Car: refuel() и move()."""
        car = Car("Toyota", "Camry", 2022, "бензин", 60.0)
        car.move(500)
        refuel_msg = car.refuel(40)
        move_msg = car.move(50)
        lines = [
            "шаг 1: move(500), расход топлива, пробег 500 км",
            f"шаг 2: refuel(40) -> {refuel_msg}",
            f"шаг 3: move(50) -> {move_msg}",
            f"пробег после поездок: {car.mileage}",
            "проверка: в ответе move есть «проехал 50 км», пробег == 550",
        ]
        ok = "проехал 50 км" in move_msg and car.mileage == 550.0
        print_block(3, "Car: refuel и move", lines, ok)
        self.assertIn("проехал 50 км", move_msg)
        self.assertEqual(car.mileage, 550.0)

    def test_04_bicycle_gear_and_move(self):
        """Методы наследника Bicycle: shift_gear() и move()."""
        bike = Bicycle("Trek", "Marlin 7", 2023, 21)
        gear_msg = bike.shift_gear(5)
        move_msg = bike.move(10)
        lines = [
            f"шаг 1: shift_gear(5) -> {gear_msg}",
            f"шаг 2: move(10) -> {move_msg}",
            f"пробег: {bike.mileage}",
            "проверка: move упоминает передачу 5, пробег == 10",
        ]
        ok = "передаче 5" in move_msg and bike.mileage == 10.0
        print_block(4, "Bicycle: shift_gear и move", lines, ok)
        self.assertIn("передаче 5", move_msg)
        self.assertEqual(bike.mileage, 10.0)

    def test_05_service_check_override(self):
        """Переопределение service_check() с вызовом super()."""
        car = Car("Toyota", "Camry", 2022, "бензин", 60.0)
        bike = Bicycle("Trek", "Marlin 7", 2023, 21)
        car_msg = car.service_check()
        bike_msg = bike.service_check()
        lines = [
            f"Car.service_check(): {car_msg}",
            f"Bicycle.service_check(): {bike_msg}",
            "проверка: Car - двигателя, Bicycle - цепи",
            "ожидание: текст базового класса + дополнение наследника",
        ]
        ok = "двигателя" in car_msg and "цепи" in bike_msg
        print_block(5, "Переопределение service_check (super)", lines, ok)
        self.assertIn("двигателя", car_msg)
        self.assertIn("цепи", bike_msg)

    def test_06_polymorphism(self):
        """Один вызов move() для разных типов через базовый класс Vehicle."""
        car = Car("Toyota", "Camry", 2022, "бензин", 60.0)
        bike = Bicycle("Trek", "Marlin 7", 2023, 21)
        car.refuel(60)
        results: list[str] = []
        lines = [
            "список: [car, bike], тип Vehicle, объекты разные",
            "цикл: for v in vehicles: v.move(15)",
        ]
        for label, vehicle in (("Car", car), ("Bicycle", bike)):
            msg = vehicle.move(15)
            results.append(msg)
            lines.append(f"  {label}.move(15) -> {msg}")
        lines.append("проверка: получено 2 разных ответа move()")
        ok = len(results) == 2
        print_block(6, "Полиморфный вызов move()", lines, ok)
        self.assertEqual(len(results), 2)

    def test_07_inheritance_checks(self):
        """isinstance и issubclass — проверка иерархии классов."""
        car = Car("Toyota", "Camry", 2022, "бензин", 60.0)
        is_vehicle = isinstance(car, Vehicle)
        is_subclass = issubclass(Bicycle, Vehicle)
        lines = [
            f"isinstance(car, Vehicle) -> {is_vehicle}",
            f"issubclass(Bicycle, Vehicle) -> {is_subclass}",
            "проверка: оба выражения == True",
        ]
        ok = is_vehicle and is_subclass
        print_block(7, "isinstance / issubclass", lines, ok)
        self.assertTrue(is_vehicle)
        self.assertTrue(is_subclass)

    def test_08_invalid_input(self):
        """ValueError при некорректных аргументах."""
        car = Car("Toyota", "Camry", 2022, "бензин", 60.0)
        bike = Bicycle("Trek", "Marlin 7", 2023, 21)
        checks: list[str] = []

        def expect_error(label: str, action) -> None:
            try:
                action()
                checks.append(f"{label} -> ошибки нет (FAIL)")
            except ValueError:
                checks.append(f"{label} -> ValueError (OK)")

        expect_error("car.add_mileage(-1)", lambda: car.add_mileage(-1))
        expect_error("car.refuel(0)", lambda: car.refuel(0))
        expect_error("bike.shift_gear(99)", lambda: bike.shift_gear(99))

        lines = checks + ["проверка: все три вызова выбрасывают ValueError"]
        ok = all("ValueError (OK)" in c for c in checks)
        print_block(8, "Ошибочный ввод", lines, ok)
        with self.assertRaises(ValueError):
            car.add_mileage(-1)
        with self.assertRaises(ValueError):
            car.refuel(0)
        with self.assertRaises(ValueError):
            bike.shift_gear(99)


def build_suite() -> unittest.TestSuite:
    suite = unittest.TestSuite()
    loader = unittest.TestLoader()
    for name in ORDERED_TESTS:
        suite.addTest(loader.loadTestsFromName(name, TestVehicleDemo))
    return suite


if __name__ == "__main__":
    print("тесты 2.2\n")
    result = unittest.TextTestRunner(verbosity=0).run(build_suite())
    print()
    if result.wasSuccessful():
        print(f"итог: {TOTAL}/8 пройдено")
    else:
        print(f"итог: failures={len(result.failures)}, errors={len(result.errors)}")
