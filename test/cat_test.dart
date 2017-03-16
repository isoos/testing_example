import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

import 'package:testing_example/cat.dart';

@proxy
class MockCatCafe extends Mock implements CatCafe {}

void main() {
  group('Cat', () {

    test('Eating favourite meal makes Cat joyful.', () {
      Cat cat = new Cat('Kitty', favouriteMeal: 'fish');
      expect(cat.isHungry, true);
      expect(cat.isJoyful, false);

      cat.feed('fish');
      expect(cat.isHungry, false);
      expect(cat.isJoyful, true);

      cat.feed('beef');
      expect(cat.isHungry, false);
      expect(cat.isJoyful, false);
    });

    test('Eats meal in CatCafe.', () {
      CatCafe cafe = new CatCafe();

      Cat cat = new Cat('Kitty', favouriteMeal: 'fish');
      expect(cat.isHungry, true);

      cat.visitCafe(cafe);
      expect(cat.isHungry, false);
    });

    test('Eats favourite in CatCafe.', () {
      MockCatCafe cafe = new MockCatCafe();
      when(cafe.serveMeal()).thenReturn('fish');

      Cat cat = new Cat('Kitty', favouriteMeal: 'fish');
      expect(cat.isHungry, true);

      cat.visitCafe(cafe);
      expect(cat.isHungry, false);
      expect(cat.isJoyful, false);
    });
  });
}
