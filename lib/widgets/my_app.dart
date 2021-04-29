// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:flutter_map_example/state/map_state.dart';
import 'home_page.dart';

class MyApp extends StatelessWidget {
  final state = MapState();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Map positioning demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomePage(state),
    );
  }
}
