// Dart imports:
import 'dart:io';
import 'dart:ui';

// Flutter imports:
import 'package:flutter/foundation.dart';

// Package imports:
import 'package:google_maps_flutter/google_maps_flutter.dart';

// Project imports:
import 'package:flutter_map_example/model/point.dart';

class MarkerInitializer {
  MarkerInitializer({
    this.id,
    required this.point,
    this.onPressed,
  });

  final String? id;
  final Point point;
  final VoidCallback? onPressed;

  Marker toMarker() => Marker(
        markerId: MarkerId(id ?? point.toString()),
        position: point.toLatLng(),
        onTap: onPressed,
        anchor: const Offset(0.5, 0.5),
      );
}
