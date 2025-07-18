import 'dart:math';

import 'package:flutter/material.dart';
import 'package:particle_simulation/src/helper.dart';

class Particles {
  final Size canvasSize;
  final Map<String, dynamic> settings;
  List<Particle> particles = [];
  Particles({required this.canvasSize, required this.settings}) {
    for (int i = 0; i < settings['maxParticles']; i++) {
      particles.add(Particle(canvasSize: canvasSize, settings: settings));
    }
  }
}

// ignore: must_be_immutable
class Particle extends StatefulWidget {
  double radius = 5;
  final Size canvasSize;
  final Map<String, dynamic> settings;
  Offset position = Offset.zero;
  Color color = Colors.black;

  Particle({super.key, required this.canvasSize, required this.settings});

  @override
  State<Particle> createState() => _ParticleState();
}

class _ParticleState extends State<Particle> {
  @override
  Widget build(BuildContext context) {
    if (widget.settings['particle']['randomSize']) {
      widget.radius =
          Random().nextDouble() *
          (widget.settings['particle']['randomSize']
              ? Random().nextInt(widget.settings['particle']['maxSize'])
              : widget.settings['particle']['maxSize']);
    } else {
      widget.radius = widget.settings['particle']['maxSize'].toDouble();
    }
    widget.position = Offset(
      Random().nextDouble() * widget.canvasSize.width,
      Random().nextDouble() * widget.canvasSize.height,
    );
    widget.color = widget.settings['particle']['randomColor']
        ? randomColor()
        : colorFromString(widget.settings['particle']['color']);

    return CustomPaint(
      willChange: true,
      painter: ParticlePainter(
        radius: widget.radius,
        position: widget.position,
        color: widget.color,
      ),
      child: Container(),
    );
  }
}

class ParticlePainter extends CustomPainter {
  final double radius;
  final Color color;
  final Offset position;
  ParticlePainter({
    required this.radius,
    required this.color,
    required this.position,
  });

  @override
  void paint(Canvas canvas, Size size) {
    Paint particlePaint = Paint()
      ..color = color
      ..strokeCap = StrokeCap.butt
      ..style = PaintingStyle.fill;

    canvas.drawCircle(position, radius, particlePaint);
  }

  @override
  bool shouldRepaint(ParticlePainter oldDelegate) => false;

  @override
  bool shouldRebuildSemantics(ParticlePainter oldDelegate) => false;
}
