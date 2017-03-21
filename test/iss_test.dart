import 'dart:math';

import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

import 'package:testing_example/iss.dart';

@proxy
class MockIssLocator extends Mock implements IssLocator {}

void main() {
  group('Spherical distance', () {
    test('London - Paris', () {
      Point<double> london = new Point(51.5073, -0.1277);
      Point<double> paris = new Point(48.8566, 2.3522);
      double d = sphericalDistanceKm(london, paris);
      expect(d, closeTo(343.5, 0.1));
    });

    test('San Francisco - Mountain View', () {
      Point<double> sf = new Point(37.783333, -122.416667);
      Point<double> mtv = new Point(37.389444, -122.081944);
      double d = sphericalDistanceKm(sf, mtv);
      expect(d, closeTo(52.8, 0.1));
    });
  });

  group('ISS spotter', () {
    test('ISS visible', () async {
      Point<double> sf = new Point(37.783333, -122.416667);
      Point<double> mtv = new Point(37.389444, -122.081944);
      IssLocator locator = new MockIssLocator();
      when(locator.currentPosition).thenReturn(sf);

      var spotter = new IssSpotter(locator, mtv);
      expect(spotter.isVisible, true);
    });

    test('ISS not visible', () async {
      Point<double> london = new Point(51.5073, -0.1277);
      Point<double> mtv = new Point(37.389444, -122.081944);
      IssLocator locator = new MockIssLocator();
      when(locator.currentPosition).thenReturn(london);

      var spotter = new IssSpotter(locator, mtv);
      expect(spotter.isVisible, false);
    });
  });
}
