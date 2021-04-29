// Dart imports:
import 'dart:math';

// Package imports:
import 'package:geodesy/geodesy.dart' as gd;
import 'package:google_maps_flutter/google_maps_flutter.dart';

class Point {
  const Point({required this.latitude, required this.longitude});

  factory Point.moscow() => const Point(latitude: 55.7522, longitude: 37.6156);

  factory Point.fromCameraPosition(CameraPosition position) => Point(longitude: position.target.longitude, latitude: position.target.latitude);

  final double latitude;
  final double longitude;

  LatLng toLatLng() => LatLng(latitude, longitude);

  Point copyWithAzimuth(double distance, double degrees) {
    return Point(latitude: latitude + distance * sin(degrees), longitude: longitude + distance * cos(degrees));
  }

  double distanceTo(Point point) => gd.Geodesy().distanceBetweenTwoGeoPoints(toGeodesyLatLng(), point.toGeodesyLatLng()).toDouble();

  gd.LatLng toGeodesyLatLng() => gd.LatLng(latitude, longitude);
}

extension PointCreator on LatLng {
  Point get point => Point(longitude: longitude, latitude: latitude);
}
