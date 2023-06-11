import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:space_app/components/background_functions.dart';

void main() {
  const double width = 200;
  const double height = 200;
  final stars = [
    CelestialPointData(
      c: const Offset(100, 100),
      radius: 5,
      paint: Paint()..color = Colors.white,
    ),
  ];
  final planets = [
    CelestialPointData(
      c: const Offset(150, 150),
      radius: 30,
      paint: Paint()..color = Colors.blue,
    ),
  ];
  final gradient = [Colors.black, Colors.white];

  group('canvas creation', () {
    test('should draw the background, stars, and planets on the canvas', () {
      final canvas = FakeCanvas(ui.PictureRecorder());

      generateRandomSpace(canvas, width, height, stars, planets, gradient);

      expect(canvas.drawRectCalls.length, 2);
      expect(canvas.drawRectCalls.first, Rect.largest);
      expect(canvas.drawRectCalls.last, Rect.largest);

      expect(canvas.drawCircleCalls.length, 2);
      expect(canvas.drawCircleCalls.first.center, const Offset(100, 100));
      expect(canvas.drawCircleCalls.first.radius, 5);
      expect(canvas.drawCircleCalls.last.center, const Offset(150, 150));
      expect(canvas.drawCircleCalls.last.radius, 30);
    });

    test('should return a list of CelestialPointInfo with correct length', () {
      final stars = generateStars(width, height);
      final planets = generatePlanets(width, height);
      expect(stars.length, equals(100));
      expect(planets.length, equals(6));
    });
  });

  group('file creation', () {
    test('should return Uint8List data when given valid arguments', () async {
      Uint8List? imageData =
          await generateSpaceImgData(width, height, stars, planets, gradient);

      expect(imageData, isNotNull);
      expect(imageData, isA<Uint8List>());
    });
  });
}

class FakeCanvas extends ui.Canvas {
  final List<Rect> drawRectCalls = [];
  final List<CircleCall> drawCircleCalls = [];

  FakeCanvas(super.recorder);

  @override
  void drawRect(Rect rect, Paint paint) {
    drawRectCalls.add(rect);
  }

  @override
  void drawCircle(Offset c, double radius, Paint paint) {
    drawCircleCalls.add(CircleCall(c, radius));
  }
}

class CircleCall {
  final Offset center;
  final double radius;

  CircleCall(this.center, this.radius);
}

class RectCall {
  final Rect rect;

  RectCall(this.rect);
}
