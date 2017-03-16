import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:http/http.dart';

/// Provides the International Space Station's current GPS position.
class IssLocator {
  /// Returns the current GPS position in [latitude, longitude] format.
  Future<Point<double>> currentPosition() async {
    Client client = new Client();
    Response rs = await client.get('http://api.open-notify.org/iss-now.json');
    Map data = JSON.decode(rs.body);
    double latitude = double.parse(data['iss_position']['latitude']);
    double longitude = double.parse(data['iss_position']['longitude']);
    client.close();
    return new Point<double>(latitude, longitude);
  }
}

class IssSpotter {
  final IssLocator locator;
  final Point<double> observer;

  IssSpotter(this.locator, this.observer);

  Future<bool> isVisible() async {
    Point<double> current = await locator.currentPosition();
    double distance = sphericalDistanceKm(current, observer);
    return distance < 80.0;
  }
}

double sphericalDistanceKm(Point<double> p1, Point<double> p2) {
  double dLat = _toRadian(p1.x - p2.x);
  double sLat = pow(sin(dLat / 2), 2);
  double dLng = _toRadian(p1.y - p2.y);
  double sLng = pow(sin(dLng / 2), 2);
  double cosALat = cos(_toRadian(p1.x));
  double cosBLat = cos(_toRadian(p2.x));
  double x = sLat + cosALat * cosBLat * sLng;
  double d = 2 * atan2(sqrt(x), sqrt(1 - x)) * _radiusOfEarth;
  return d;
}

/// Radius of the earth in km.
const int _radiusOfEarth = 6371;
double _toRadian(num degree) => degree * PI / 180.0;
