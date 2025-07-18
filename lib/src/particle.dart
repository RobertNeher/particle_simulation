import 'dart:math';

class Particle {
  double width;
  double height;
  Map<String, dynamic> settings;

  late double radius;
  late double xSpeed;
  late double ySpeed;

  late double x;
  late double y;

  Particle({
    required this.width,
    required this.height,
    required this.settings,
  }) {
    x = Random().nextDouble() * width;
    y = Random().nextDouble() * height;
    radius = Random().nextDouble() * settings['maxRadius'];

    xSpeed = Random().nextDouble() * settings['maxSpeedX'];
    ySpeed = Random().nextDouble() * settings['maxSpeedY'];
  }
}
