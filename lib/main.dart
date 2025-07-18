import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:particle_simulation/src/helper.dart';
import 'package:particle_simulation/src/particles.dart';

void main() {
  runApp(MainApp());
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
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: settings['appName'] ?? settings['title'],
      home: FutureBuilder<void>(
        future: _loadSettings(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(
                backgroundColor: Colors.blue,
                strokeWidth: 5,
              ),
            );
          }
          if (snapshot.connectionState == ConnectionState.done) {
            return Scaffold(
              backgroundColor: colorFromString(settings['backgroundColor']),
              body: ParticleAnimations(
                settings: settings,
                windowSize: MediaQuery.of(context).size,
              ),
            );
          } else {
            return const Center(
              child: Text(
                'Something went wrong!',
                style: TextStyle(
                  // fontFamily: 'Railway',
                  fontWeight: FontWeight.bold,
                  fontSize: 24,
                  color: Colors.red,
                ),
              ),
            );
          }
        },
      ),
    );
  }
}
