import 'dart:async';
import 'dart:html';

import 'package:angular2/angular2.dart';
import 'package:google_maps/google_maps.dart' as gmap;

import '../iss.dart';

/// Main component
@Component(
  selector: 'app-component',
  templateUrl: 'app_component.html',
)
class AppComponent implements AfterViewInit {
  final IssLocator issLocator;
  gmap.GMap _map;
  gmap.Marker _issMarker;
  gmap.Circle _issCircle;
  gmap.Polyline _issPath;
  List<gmap.LatLng> _path = [];

  List<IssSpotter> spotters;

  AppComponent(this.issLocator);

  /// The DOM element reference for the Google Maps initialization.
  @ViewChild('mapArea')
  ElementRef mapAreaRef;

  @override
  Future ngAfterViewInit() async {
    _map ??= new gmap.GMap(
        mapAreaRef.nativeElement, new gmap.MapOptions()..zoom = 3);
    _issMarker ??= new gmap.Marker(new gmap.MarkerOptions()
      ..map = _map
      ..label = 'ISS');
    _issPath ??= new gmap.Polyline(new gmap.PolylineOptions()
      ..strokeColor = '#000000'
      ..strokeWeight = 1
      ..strokeOpacity = 0.6
      ..path = []
      ..map = _map);
    _issCircle ??= new gmap.Circle(new gmap.CircleOptions()
      ..strokeColor = '#FF0000'
      ..strokeWeight = 1
      ..strokeOpacity = 0.6
      ..fillColor = '#FF0000'
      ..fillOpacity = 0.3
      ..map = _map
      ..visible = true
      ..radius = 80000.0);
    _update();
    new Timer.periodic(new Duration(seconds: 15), (_) => _update());
  }

  Future _update() async {
    await issLocator.update();
    spotters ??= [
      new IssSpotter(issLocator, new Point(51.5073, -0.1277), label: 'London'),
      new IssSpotter(issLocator, new Point(37.389444, -122.081944),
          label: 'Mountain View'),
      new IssSpotter(issLocator, new Point(48.8566, 2.3522), label: 'Paris'),
      new IssSpotter(issLocator, new Point(37.783333, -122.416667),
          label: 'San Francisco'),
    ];
    gmap.LatLng position = new gmap.LatLng(
        issLocator.currentPosition.x, issLocator.currentPosition.y);
    _map.center = position;
    _path.add(position);
    _issCircle.center = position;
    if (_path.length > 100) {
      _path.removeAt(0);
    }
    _issPath.path = _path;
    _issMarker.position = position;
  }
}
