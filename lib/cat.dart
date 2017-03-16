import 'dart:math' show Random;

final Random _random = new Random.secure();

// A service that feeds cats.
class CatCafe {
  List<String> _menu = ['fish', 'chicken', 'beef', 'milk', 'kibble'];

  bool hasMeal(String meal) => _menu.contains(meal);

  String serveMeal() {
    return _menu[_random.nextInt(_menu.length)];
  }
}

class Cat {
  String name;
  String favouriteMeal;

  bool _isHungry = true;
  bool _isJoyful = false;

  Cat(name, {this.favouriteMeal});

  void feed(String meal) {
    _isJoyful = meal == favouriteMeal;
    _isHungry = false;
  }

  void visitCafe(CatCafe cafe) {
    feed(cafe.serveMeal());
  }

  bool get isHungry => _isHungry;
  bool get isJoyful => _isJoyful;
}
