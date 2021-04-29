// Dart imports:
import 'dart:core';
import 'dart:math';

// Flutter imports:
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

// Package imports:
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:mobx/mobx.dart';

// Project imports:
import 'package:flutter_map_example/model/visible_area.dart';
import 'package:flutter_map_example/state/map_state.dart';

const String userMarkerId = 'userMarkerId';

class BigMapView extends StatefulWidget {
  const BigMapView({
    Key? key,
    this.onCameraMove,
    this.onCreated,
    this.onTap,
    required this.mapState,
  }) : super(key: key);

  final CameraPositionCallback? onCameraMove;
  final MapCreatedCallback? onCreated;
  final ArgumentCallback<LatLng>? onTap;
  final MapState mapState;

  @override
  _BigMapViewState createState() {
    return _BigMapViewState();
  }
}

class _BigMapViewState extends State<BigMapView> {
  static const double buildingLevelZoom = 17.5;

  late CameraPosition _initialCameraPosition;
  late GoogleMapController _googleMapController;

  late Marker _userMarker;
  late double _currentZoom;

  final List<ReactionDisposer> _disposers = [];

  double get currentZoom {
    return _currentZoom;
  }

  set currentZoom(double value) {
    if (_currentZoom != value) {
      _currentZoom = value;
    }
  }

  final Set<Marker> _markers = {};

  void _initMapController(GoogleMapController mapController) {
    _googleMapController = mapController;
    if (widget.onCreated != null) {
      widget.onCreated!(_googleMapController);
    }
    WidgetsBinding.instance?.addPostFrameCallback((timeStamp) {
      // необходимо дождаться завершения построения layout, иначе можно попасть на ошибку с нулевым размером карты
      _listenToState();
    });
  }

  void _listenToState() {
    _disposers.addAll([
      autorun((_) {
        _initMarkers();
        _initUserMarker();
      }),
      reaction(
        (_) => widget.mapState.area,
        (VisibleArea area) {
          if (area.desiredBounds != null) {
            showArea(area.desiredBounds!);
          } else {
            centerOn(area.center.toLatLng());
          }
        },
        fireImmediately: true,
      ),
    ]);
  }

  @override
  void dispose() {
    _disposers.forEach((d) => d());
    super.dispose();
  }

  void _onCameraMove(CameraPosition position) {
    currentZoom = position.zoom;
    if (widget.onCameraMove != null) {
      widget.onCameraMove!(position);
    }
  }

  void centerOn(LatLng point) {
    _googleMapController.animateCamera(CameraUpdate.newLatLngZoom(point, currentZoom));
  }

  void showArea(LatLngBounds area) {
    _googleMapController.animateCamera(CameraUpdate.newLatLngBounds(area, VisibleArea.areaPadding));
  }

  Future<void> _initMarkers() async {
    widget.mapState.markerInitializers.forEach((element) {
      _markers.add(element.toMarker());
    });
    setState(() {});
  }

  void _onMapTap(LatLng point) {
    if (widget.onTap != null) {
      widget.onTap!(point);
    }
  }

  void _initCameraPosition() {
    _initialCameraPosition = CameraPosition(target: widget.mapState.userPosition.toLatLng(), zoom: _currentZoom);
  }

  Future<void> _initUserMarker() async {
    _userMarker = Marker(position: widget.mapState.userPosition.toLatLng(), markerId: const MarkerId(userMarkerId));
    _markers.add(_userMarker);
    if (mounted) {
      setState(() {});
    }
  }

  Future<void> _findMe() async {
    await _initUserMarker();
    centerOn(_userMarker.position);
  }

  @override
  void initState() {
    super.initState();
    _currentZoom = buildingLevelZoom;
    _initCameraPosition();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        GoogleMap(
          onTap: _onMapTap,
          initialCameraPosition: _initialCameraPosition,
          onMapCreated: _initMapController,
          markers: _markers,
          buildingsEnabled: true,
          mapToolbarEnabled: false,
          myLocationButtonEnabled: false,
          zoomControlsEnabled: false,
          compassEnabled: false,
          trafficEnabled: false,
          scrollGesturesEnabled: true,
          tiltGesturesEnabled: false,
          indoorViewEnabled: false,
          onCameraMove: _onCameraMove,
        ),
        Container(
          padding: const EdgeInsets.only(right: 20, bottom: 20),
          alignment: Alignment.bottomRight,
          child: CircleAvatar(
            backgroundColor: Colors.blue,
            child: IconButton(icon: const Icon(Icons.near_me), iconSize: 14, onPressed: _findMe),
          ),
        ),
      ],
    );
  }
}
