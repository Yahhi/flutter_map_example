// Dart imports:
import 'dart:math';

// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_mobx/flutter_mobx.dart';

// Project imports:
import 'package:flutter_map_example/state/map_state.dart';
import 'package:flutter_map_example/widgets/big_map_view.dart';

class HomePage extends StatelessWidget {
  const HomePage(this.state, {Key? key}) : super(key: key);

  final MapState state;

  Future<void> _openAddCity(BuildContext context) async {
    final controller = TextEditingController();
    await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (BuildContext context) => AlertDialog(
            title: const Text('Введите город'),
            contentPadding: const EdgeInsets.all(16.0),
            content: Row(
              children: <Widget>[
                Expanded(
                  child: TextField(
                    controller: controller,
                    autofocus: true,
                    decoration: const InputDecoration(labelText: 'Город', hintText: 'например, Волгоград'),
                  ),
                )
              ],
            ),
            actions: <Widget>[
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('Отмена'),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('Сохранить'),
              )
            ],
          ),
          fullscreenDialog: true,
        ));
    await state.addCity(controller.text);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Позиционирование'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add_location_alt_outlined),
            onPressed: () => _openAddCity(context),
          ),
          IconButton(icon: const Icon(Icons.update), onPressed: () => state.changeViewType(ViewType.values[Random().nextInt(4)]))
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: BigMapView(
              mapState: state,
            ),
          ),
          Container(
            color: Colors.white,
            padding: const EdgeInsets.all(8),
            height: 150,
            child: Observer(
              builder: (_) => ListView(
                children: [
                  Text('Выбранный метод масштабирования: ${state.type.title}'),
                  const SizedBox(height: 8),
                  const Text('Выбранные точки:'),
                  ...state.markerInitializers.map((element) => Text('${element.id}: ${element.point.latitude}, ${element.point.longitude}'))
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
