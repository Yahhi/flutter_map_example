// Package imports:
import 'package:google_maps_flutter/google_maps_flutter.dart';

// Project imports:
import 'marker_initializer.dart';
import 'point.dart';

class VisibleArea {
  VisibleArea._(this.center, this.desiredBounds);

  factory VisibleArea.forAllPoints(Point center, List<MarkerInitializer> markerInitializers, {bool isCentered = true}) {
    final points = markerInitializers.map((e) => e.point).toList(growable: false);
    return VisibleArea._(center, isCentered ? _centeredScreenBounds(center, _differenceToFarthestPlace(points, center)) : _desiredScreenBounds(points));
  }

  VisibleArea.forCustomPoints(this.center, List<Point> customPoints) : desiredBounds = _desiredScreenBounds(customPoints);

  factory VisibleArea.forTwoNearestPoints(Point center, List<MarkerInitializer> markerInitializers) {
    final points = markerInitializers.map((e) => e.point).toList(growable: false);
    return VisibleArea._(center, _centeredScreenBounds(center, _differenceToSecondNearestPlace(points, center)));
  }

  factory VisibleArea.forFirstNearestPoint(Point center, List<MarkerInitializer> markerInitializers) {
    final points = markerInitializers.map((e) => e.point).toList(growable: false);
    return VisibleArea._(center, _centeredScreenBounds(center, _differenceToNearestPlace(points, center)));
  }

  VisibleArea.forSinglePointAndCenter(this.center, Point point) : desiredBounds = _centeredScreenBounds(center, _differenceToCenter(point.toLatLng(), center.toLatLng()));

  VisibleArea.simpleCenter(this.center) : desiredBounds = null;

  static const zoomMax = 21;
  static const areaPadding = 50.0;
  static const smallAreaPadding = 16.0;

  final LatLngBounds? desiredBounds;
  final Point center;

  static LatLng? _differenceToSecondNearestPlace(List<Point> points, Point center) {
    if (points.length > 2) {
      final first = _nearestPlace(points, center);
      final sublist = List<Point>.from(points);
      sublist.remove(first);
      final second = _nearestPlace(sublist, center);
      return _differenceToCenter(second.toLatLng(), center.toLatLng());
    } else if (points.length == 2) {
      return _differenceToCenter(
        center.distanceTo(points[0]) < center.distanceTo(points[1]) ? points[0].toLatLng() : points[1].toLatLng(),
        center.toLatLng(),
      );
    } else if (points.length == 1) {
      return _differenceToCenter(points.first.toLatLng(), center.toLatLng());
    } else {
      return null;
    }
  }

  static LatLng? _differenceToFarthestPlace(List<Point> points, Point center) {
    var maxLatitude = points.first.latitude;
    var maxLongitude = points.first.longitude;
    for (var markerInitializer in points) {
      if ((maxLatitude - center.latitude).abs() < (markerInitializer.latitude - center.latitude).abs()) {
        maxLatitude = markerInitializer.latitude;
      }
      if ((maxLongitude - center.longitude).abs() < (markerInitializer.longitude - center.longitude).abs()) {
        maxLongitude = markerInitializer.longitude;
      }
    }
    return _differenceToCenter(LatLng(maxLatitude, maxLongitude), center.toLatLng());
  }

  static LatLng? _differenceToNearestPlace(List<Point> points, Point center) {
    if (points.length > 1) {
      return _differenceToCenter(_nearestPlace(points, center).toLatLng(), center.toLatLng());
    } else if (points.isEmpty) {
      return null;
    } else {
      return _differenceToCenter(points.first.toLatLng(), center.toLatLng());
    }
  }

  static Point _nearestPlace(List<Point> points, Point center) {
    var first = points.first;
    for (var i = 1; i < points.length; i++) {
      if (center.distanceTo(first) > center.distanceTo(points[i])) {
        first = points[i];
        continue;
      }
    }
    return first;
  }

  static LatLng? _differenceToCenter(LatLng? point, LatLng? center) => point == null || center == null
      ? null
      : LatLng(
          (point.latitude - center.latitude).abs(),
          (point.longitude - center.longitude).abs(),
        );

  static LatLngBounds? _desiredScreenBounds(List<Point> desiredPoints) {
    final clearedPoints = _clearTheSame(desiredPoints);
    if (clearedPoints.length < 2) return null;
    var minLatitude = clearedPoints.first.latitude;
    var minLongitude = clearedPoints.first.longitude;
    var maxLatitude = clearedPoints.first.latitude;
    var maxLongitude = clearedPoints.first.longitude;
    for (var markerInitializer in clearedPoints) {
      if (minLatitude > markerInitializer.latitude) {
        minLatitude = markerInitializer.latitude;
      }
      if (minLongitude > markerInitializer.longitude) {
        minLongitude = markerInitializer.longitude;
      }
      if (maxLatitude < markerInitializer.latitude) {
        maxLatitude = markerInitializer.latitude;
      }
      if (maxLongitude < markerInitializer.longitude) {
        maxLongitude = markerInitializer.longitude;
      }
    }
    return LatLngBounds(northeast: LatLng(maxLatitude, maxLongitude), southwest: LatLng(minLatitude, minLongitude));
  }

  static List<Point> _clearTheSame(List<Point> points) {
    final updatedList = <Point>[];
    for (var i = 0; i < points.length; i++) {
      var haveToInsert = true;
      for (var j = 0; j < updatedList.length; j++) {
        if (updatedList[j].latitude == points[i].latitude && updatedList[j].longitude == points[j].longitude) {
          haveToInsert = false;
          break;
        }
      }
      if (haveToInsert) {
        updatedList.add(points[i]);
      }
    }
    return updatedList;
  }

  static LatLngBounds? _centeredScreenBounds(Point center, LatLng? differenceOnAxis) {
    if (differenceOnAxis == null) {
      return null;
    }
    return LatLngBounds(
        southwest: LatLng(center.latitude - differenceOnAxis.latitude, center.longitude - differenceOnAxis.longitude),
        northeast: LatLng(center.latitude + differenceOnAxis.latitude, center.longitude + differenceOnAxis.longitude));
  }
}
