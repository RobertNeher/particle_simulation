import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:particle_simulation/src/helper.dart';
import 'package:particle_simulation/src/particle.dart';

class ParticleAnimations extends StatefulWidget {
  final Size windowSize;
  final Map<String, dynamic> settings;
  const ParticleAnimations({
    super.key,
    required this.windowSize,
    required this.settings,
  });

  @override
  State<ParticleAnimations> createState() => _ParticleAnimationsState();
}

class _ParticleAnimationsState extends State<ParticleAnimations> {
  late List<Particle> particles;

  @override
  void initState() {
    particles = [];

    for (int i = 0; i < widget.settings['maxParticles']; i++) {
      particles.add(
        Particle(
          width: widget.windowSize.width,
          height: widget.windowSize.height,
          settings: widget.settings['particle'],
        ),
      );
    }

    update();
    super.initState();
  }

  update() {
    Timer.periodic(Duration(milliseconds: widget.settings['updatePeriod']), (
      timer,
    ) {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: GestureDetector(
        onPanUpdate: (details) {
          var localPosition = details.localPosition;

          particles.add(
            Particle(
                width: widget.windowSize.width,
                height: widget.windowSize.height,
                settings: widget.settings['particle'],
              )
              ..x = localPosition.dx
              ..y = localPosition.dy,
          );

          setState(() {});
        },
        child: CustomPaint(
          painter: ParticlesPainter(
            particles: particles,
            settings: widget.settings['particle'],
          ),
          child: Container(),
        ),
      ),
    );
  }
}

class ParticlesPainter extends CustomPainter {
  final List<Particle> particles;
  final Map<String, dynamic> settings;

  ParticlesPainter({required this.particles, required this.settings});

  //eucledian distance formula
  double euclidianDistance(double x1, double y1, double x2, double y2) {
    return sqrt(pow(x2 - x1, 2) + pow(y2 - y1, 2));
  }

  @override
  void paint(Canvas canvas, Size size) {
    for (var i = 0; i < particles.length; i++) {
      var particle = particles[i];

      if (particle.x < 0 || particle.x > size.width) {
        particles[i].xSpeed *= -1;
      }

      if (particle.y < 0 || particle.y > size.height) {
        particles[i].ySpeed *= -1;
      }

      particles[i].x += particle.xSpeed;
      particles[i].y += particle.ySpeed;

      for (var j = i + 1; j < particles.length; j++) {
        var nxtParticle = particles[j];

        double distance = euclidianDistance(
          particle.x,
          particle.y,
          nxtParticle.x,
          nxtParticle.y,
        );

        if (distance < settings['distance']) {
          var linePaint = Paint()
            ..color = (settings['randomColor']
                ? randomColor()
                : colorFromString(settings['lineColor']))
            ..style = PaintingStyle.stroke
            ..strokeCap = StrokeCap.round
            ..strokeWidth = 4;

          Offset point1 = Offset(particle.x, particle.y);
          Offset point2 = Offset(nxtParticle.x, nxtParticle.y);

          canvas.drawLine(point1, point2, linePaint);
        }
      }

      var dotPaint = Paint()
        ..color = (settings['randomColor']
            ? randomColor()
            : colorFromString(settings['dotColor']))
        ..style = PaintingStyle.fill;

      var circlePosition = Offset(particle.x, particle.y);

      canvas.drawCircle(circlePosition, particle.radius, dotPaint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
