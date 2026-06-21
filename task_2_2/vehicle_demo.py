"""
Кейс-задача 2.2.
Демонстрация работы методов базового класса и классов-наследников.
Тема: транспортные средства (Vehicle -> Car, Bicycle).
"""

from __future__ import annotations

from abc import ABC, abstractmethod


class Vehicle(ABC):
    """Базовый класс — транспортное средство."""

    def __init__(self, brand: str, model: str, year: int) -> None:
        self.brand = brand
        self.model = model
        self.year = year
        self._mileage = 0.0

    @property
    def mileage(self) -> float:
        return self._mileage

    def get_info(self) -> str:
        return f"{self.brand} {self.model} ({self.year}), пробег: {self._mileage:.1f} км"

    def add_mileage(self, distance: float) -> None:
        if distance <= 0:
            raise ValueError("Расстояние должно быть положительным.")
        self._mileage += distance

    @abstractmethod
    def move(self, distance: float) -> str:
        """Перемещение на заданное расстояние."""

    def service_check(self) -> str:
        return f"{self.brand} {self.model}: базовая проверка пройдена."


class Car(Vehicle):
    """Наследник — автомобиль."""

    def __init__(
        self,
        brand: str,
        model: str,
        year: int,
        fuel_type: str,
        tank_capacity: float,
    ) -> None:
        super().__init__(brand, model, year)
        self.fuel_type = fuel_type
        self.tank_capacity = tank_capacity
        self._fuel_level = tank_capacity

    def move(self, distance: float) -> str:
        fuel_needed = distance * 0.08  # ~8 л на 100 км
        if fuel_needed > self._fuel_level:
            return f"{self.get_info()}: недостаточно топлива для поездки {distance} км."
        self._fuel_level -= fuel_needed
        self.add_mileage(distance)
        return (
            f"{self.get_info()} проехал {distance} км на {self.fuel_type}. "
            f"Остаток топлива: {self._fuel_level:.1f} л."
        )

    def refuel(self, liters: float) -> str:
        if liters <= 0:
            raise ValueError("Объём заправки должен быть положительным.")
        free_space = self.tank_capacity - self._fuel_level
        actual = min(liters, free_space)
        self._fuel_level += actual
        return f"Заправлено {actual:.1f} л. Текущий уровень: {self._fuel_level:.1f} л."

    def service_check(self) -> str:
        base = super().service_check()
        return f"{base} Проверка двигателя и тормозов выполнена."


class Bicycle(Vehicle):
    """Наследник — велосипед."""

    def __init__(self, brand: str, model: str, year: int, gears: int) -> None:
        super().__init__(brand, model, year)
        self.gears = gears
        self._current_gear = 1

    def move(self, distance: float) -> str:
        self.add_mileage(distance)
        return (
            f"{self.get_info()} проехал {distance} км "
            f"на передаче {self._current_gear} из {self.gears}."
        )

    def shift_gear(self, gear: int) -> str:
        if gear < 1 or gear > self.gears:
            raise ValueError(f"Передача должна быть от 1 до {self.gears}.")
        self._current_gear = gear
        return f"Переключено на передачу {gear}."

    def service_check(self) -> str:
        base = super().service_check()
        return f"{base} Проверка цепи и тормозов выполнена."


def demonstrate_polymorphism(vehicles: list[Vehicle]) -> None:
    print("\n--- Полиморфный вызов move() ---")
    for vehicle in vehicles:
        print(vehicle.move(15))


def main() -> None:
    print("=== Кейс-задача 2.2: базовый класс и наследники ===\n")

    car = Car("Toyota", "Camry", 2022, "бензин", 60.0)
    bike = Bicycle("Trek", "Marlin 7", 2023, 21)

    print("--- Создание объектов ---")
    print(car.get_info())
    print(bike.get_info())

    print("\n--- Вызов методов наследников ---")
    print(car.refuel(40))
    print(car.move(50))
    print(bike.shift_gear(5))
    print(bike.move(10))

    print("\n--- Переопределение service_check (super()) ---")
    print(car.service_check())
    print(bike.service_check())

    demonstrate_polymorphism([car, bike])

    print("\n--- isinstance / issubclass ---")
    print(f"car — Vehicle? {isinstance(car, Vehicle)}")
    print(f"Bicycle — подкласс Vehicle? {issubclass(Bicycle, Vehicle)}")


if __name__ == "__main__":
    main()
