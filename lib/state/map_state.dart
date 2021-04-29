// Package imports:
import 'package:geocode/geocode.dart';
import 'package:mobx/mobx.dart';

// Project imports:
import 'package:flutter_map_example/model/marker_initializer.dart';
import 'package:flutter_map_example/model/point.dart';
import 'package:flutter_map_example/model/visible_area.dart';

part 'map_state.g.dart';

class MapState = _MapStateBase with _$MapState;

abstract class _MapStateBase with Store {
  final geoCode = GeoCode();

  @observable
  ObservableList<MarkerInitializer> markerInitializers = ObservableList();

  @observable
  ViewType type = ViewType.center;

  @observable
  Point userPosition = Point.moscow();

  @observable
  Point? selectedPoint;

  @computed
  VisibleArea get area {
    if (selectedPoint != null) {
      return VisibleArea.forSinglePointAndCenter(selectedPoint!, userPosition);
    }
    switch (type) {
      case ViewType.allPoints:
        return VisibleArea.forAllPoints(userPosition, markerInitializers);
      case ViewType.twoNearest:
        return VisibleArea.forTwoNearestPoints(userPosition, markerInitializers);
      case ViewType.oneNearest:
        return VisibleArea.forFirstNearestPoint(userPosition, markerInitializers);
      case ViewType.center:
      default:
        return VisibleArea.simpleCenter(userPosition);
    }
  }

  /// перемеещает и масштабирует карту так, чтобы соответвтсвовать выбранному варианту просмотра с центром в позиции пользователя
  @action
  void changeViewType(ViewType type) {
    this.type = type;
    selectedPoint = null;
  }

  /// центрирует карту на заданную точку
  @action
  void selectPoint(Point? point) {
    if (selectedPoint == point) {
      selectedPoint = null;
    } else {
      selectedPoint = point;
    }
  }

  @action
  void changeUserPosition(Point point) {
    userPosition = point;
  }

  @action
  Future<void> addCity(String cityName) async {
    try {
      final coordinates = await geoCode.forwardGeocoding(address: cityName);

      print('Latitude: ${coordinates.latitude}');
      print('Longitude: ${coordinates.longitude}');
      if (coordinates.longitude != null && coordinates.latitude != null) {
        final point = Point(latitude: coordinates.latitude!, longitude: coordinates.longitude!);
        markerInitializers.add(MarkerInitializer(point: point, id: cityName, onPressed: () => selectPoint(point)));
      }
    } catch (e) {
      print(e);
    }
  }
}

enum ViewType { allPoints, twoNearest, oneNearest, center }

extension Title on ViewType {
  String get title {
    switch (this) {
      case ViewType.allPoints:
        return 'Все точки';
      case ViewType.twoNearest:
        return 'Две ближайшие к пользователю точки';
      case ViewType.oneNearest:
        return 'Одна ближайшая к пользователю точка';
      case ViewType.center:
        return 'Центрирование на позицию пользователя';
    }
  }
}
