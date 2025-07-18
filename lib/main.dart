import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:particle_simulation/src/particles.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  Map<String, dynamic> settings = {};
  MainApp({super.key});

  Future<void> _loadSettings() async {
    String pathPrefix = '';
    if (kIsWeb) {
      pathPrefix = '';
    } else {
      pathPrefix = 'assets/';
    }

    String jsonData = await rootBundle.loadString(
      '${pathPrefix}settings/settings.json',
    );
    settings = json.decode(jsonData)['settings'];

    jsonData = await rootBundle.loadString(
      '${pathPrefix}settings/planets.json',
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: settings['appName'] ?? settings['title'],
      home: FutureBuilder(
        future: _loadSettings(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          return Center(
            child: Stack(
              alignment: Alignment.center,
              children: Particles(
                canvasSize: MediaQuery.of(context).size,
                settings: settings,
              ),
            ),
          );
        },
      ),

      Scaffold(body: Center(child: Text('Hello World!'))),
    );
  }
}
