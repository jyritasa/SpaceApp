import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:space_app/components/settings_manger.dart';

import '../providers/color_provider.dart';
import 'background_functions.dart';

@immutable

///Background with randomly generated assortment of stars and planets.
class StarryBackground extends ConsumerWidget {
  final double width;
  final double height;
  final List<CelestialPointData> stars;
  final List<CelestialPointData> planets;

  const StarryBackground({
    super.key,
    required this.width,
    required this.height,
    required this.stars,
    required this.planets,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final SettingsManager sm = SettingsManager();
    final gradient = [
      ref.watch(colorProvider).color?.withOpacity(0.2) ??
          Color.fromRGBO(sm.color[0], sm.color[1], sm.color[2], 0.2),
      Colors.white.withOpacity(0.0),
    ];
    return CustomPaint(
      painter: SpacePainter(
        stars: stars,
        planets: planets,
        gradient: gradient,
        width: width,
        height: height,
      ),
      isComplex: true,
      willChange: true,
      child: Container(),
    );
  }
}

///CustomPainter for creating background with randomized stars and planets for
///[StarryBackground].
class SpacePainter extends CustomPainter {
  SpacePainter({
    required this.stars,
    required this.planets,
    required this.gradient,
    required this.width,
    required this.height,
  });
  final List<CelestialPointData> stars, planets;
  final List<Color> gradient;
  final double width, height;

  @override
  void paint(Canvas canvas, Size size) {
    generateRandomSpace(canvas, width, height, stars, planets, gradient);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
  @override
  bool shouldRebuildSemantics(CustomPainter oldDelegate) => true;
}
