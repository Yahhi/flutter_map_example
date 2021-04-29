// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'map_state.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$MapState on _MapStateBase, Store {
  Computed<VisibleArea>? _$areaComputed;

  @override
  VisibleArea get area => (_$areaComputed ??=
          Computed<VisibleArea>(() => super.area, name: '_MapStateBase.area'))
      .value;

  final _$markerInitializersAtom =
      Atom(name: '_MapStateBase.markerInitializers');

  @override
  ObservableList<MarkerInitializer> get markerInitializers {
    _$markerInitializersAtom.reportRead();
    return super.markerInitializers;
  }

  @override
  set markerInitializers(ObservableList<MarkerInitializer> value) {
    _$markerInitializersAtom.reportWrite(value, super.markerInitializers, () {
      super.markerInitializers = value;
    });
  }

  final _$typeAtom = Atom(name: '_MapStateBase.type');

  @override
  ViewType get type {
    _$typeAtom.reportRead();
    return super.type;
  }

  @override
  set type(ViewType value) {
    _$typeAtom.reportWrite(value, super.type, () {
      super.type = value;
    });
  }

  final _$userPositionAtom = Atom(name: '_MapStateBase.userPosition');

  @override
  Point get userPosition {
    _$userPositionAtom.reportRead();
    return super.userPosition;
  }

  @override
  set userPosition(Point value) {
    _$userPositionAtom.reportWrite(value, super.userPosition, () {
      super.userPosition = value;
    });
  }

  final _$selectedPointAtom = Atom(name: '_MapStateBase.selectedPoint');

  @override
  Point? get selectedPoint {
    _$selectedPointAtom.reportRead();
    return super.selectedPoint;
  }

  @override
  set selectedPoint(Point? value) {
    _$selectedPointAtom.reportWrite(value, super.selectedPoint, () {
      super.selectedPoint = value;
    });
  }

  final _$_MapStateBaseActionController =
      ActionController(name: '_MapStateBase');

  @override
  void changeViewType(ViewType type) {
    final _$actionInfo = _$_MapStateBaseActionController.startAction(
        name: '_MapStateBase.changeViewType');
    try {
      return super.changeViewType(type);
    } finally {
      _$_MapStateBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void selectPoint(Point? point) {
    final _$actionInfo = _$_MapStateBaseActionController.startAction(
        name: '_MapStateBase.selectPoint');
    try {
      return super.selectPoint(point);
    } finally {
      _$_MapStateBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void changeUserPosition(Point point) {
    final _$actionInfo = _$_MapStateBaseActionController.startAction(
        name: '_MapStateBase.changeUserPosition');
    try {
      return super.changeUserPosition(point);
    } finally {
      _$_MapStateBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
markerInitializers: ${markerInitializers},
type: ${type},
userPosition: ${userPosition},
selectedPoint: ${selectedPoint},
area: ${area}
    ''';
  }
}
