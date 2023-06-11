import 'dart:math';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'dart:ui';
import 'package:flutter/material.dart';

import 'logger.dart';

///Coordinate, Radius and Paint of Stars and Planets for [generateRandomSpace].
class CelestialPointData {
  final Offset c;
  final double radius;
  final Paint paint;

  CelestialPointData(
      {required this.c, required this.radius, required this.paint});
}

///Generates random [CelestialPointData] for Stars. Takes size of the canvas as
/// input.
List<CelestialPointData> generateStars(double width, double height) {
  const int minStarSize = 1;
  const int maxStarSize = 5;
  const int amountOfStars = 100;
  List<CelestialPointData> list = [];

  for (var i = 0; i < amountOfStars; i++) {
    list.add(
      CelestialPointData(
        c: Offset(
            Random().nextDouble() * width, Random().nextDouble() * height),
        paint: Paint()
          ..maskFilter = const MaskFilter.blur(BlurStyle.inner, 1.0)
          ..color = Colors.white,
        radius: (Random().nextInt(maxStarSize - minStarSize) + minStarSize)
            .toDouble(),
      ),
    );
  }
  return list;
}

///Generates random [CelestialPointData] for Planets. Takes size of the canvas
/// as input.
List<CelestialPointData> generatePlanets(double width, double height) {
  //Max Radius of the circle.
  const double maxPlanetSize = 50;
  const int amountOfPlanets = 6;
  List<CelestialPointData> list = [];
  //TODO? Maybe add randomized colors from ARGB?
  //Might get colors unsuitable for [Colors.black] background.
  List<Color> planetColors = [
    Colors.blue,
    Colors.yellow,
    Colors.purple,
    Colors.green,
    Colors.grey,
    Colors.greenAccent,
    Colors.orange,
    Colors.red,
    Colors.cyan,
    Colors.deepPurple,
    Colors.amber,
    Colors.deepOrange,
    Colors.pink
  ];

  planetColors.shuffle();

  //incase amount of planets is inreased and we need more colors.
  if (amountOfPlanets > planetColors.length) {
    logger.w("Not enough Colors, Creating More");
    while (amountOfPlanets > planetColors.length) {
      planetColors.addAll(planetColors.toList());
      if (amountOfPlanets < planetColors.length) break;
    }
  }

  for (var i = 0; i < amountOfPlanets; i++) {
    list.add(CelestialPointData(
        c: Offset(
            Random().nextDouble() * width, Random().nextDouble() * height),
        paint: Paint()
          ..maskFilter = const MaskFilter.blur(BlurStyle.inner, 3.0)
          ..color = planetColors[i],
        radius: Random().nextDouble() * maxPlanetSize));
  }
  return list;
}

///Function that modifies given canvas with backgrount gradient, stars and
/// planets. Used by [SpacePainter] and [generateSpaceImgData]
void generateRandomSpace(
  Canvas canvas,
  double width,
  double height,
  List<CelestialPointData> stars,
  List<CelestialPointData> planets,
  List<Color> gradient,
) {
  Paint gradientPaint(gradient) => Paint()
    ..color = Colors.black
    ..shader = ui.Gradient.linear(
      Offset(width / 2, 0),
      Offset(width / 2, height),
      gradient,
    );
  canvas.drawRect(Rect.largest, Paint()..color = Colors.black);
  canvas.drawRect(Rect.largest, gradientPaint(gradient));
  for (var star in stars) {
    canvas.drawCircle(star.c, star.radius, star.paint);
  }
  for (var planet in planets) {
    canvas.drawCircle(planet.c, planet.radius, planet.paint);
  }
}

///Function that turns [generateRandomSpace] into [Uint8List] data that can be
///saved and downloaded as a file.
Future<Uint8List?> generateSpaceImgData(
  double width,
  double height,
  List<CelestialPointData> stars,
  List<CelestialPointData> planets,
  List<Color> gradient,
) async {
  final recorder = ui.PictureRecorder();
  final Canvas canvas = Canvas(
    recorder,
    Rect.fromPoints(
      const Offset(0.0, 0.0),
      Offset(height, width),
    ),
  );
  generateRandomSpace(canvas, width, height, stars, planets, gradient);
  final picture = recorder.endRecording();
  final img = await picture.toImage(width.toInt(), height.toInt());
  final pngBytes = await img.toByteData(format: ImageByteFormat.png);
  Uint8List data = pngBytes!.buffer
      .asUint8List(pngBytes.offsetInBytes, pngBytes.lengthInBytes);
  return data;
}
