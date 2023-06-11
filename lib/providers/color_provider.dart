import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../conf/colors.dart';

@immutable
class ColorState {
  const ColorState({required this.color});
  final Color? color;
}

class LanguageNotifier extends StateNotifier<ColorState> {
  LanguageNotifier() : super(const ColorState(color: initialSeedColor));
  void update(Color color) => state = ColorState(color: color);
}

///State management for app ColorScheme seedcolor and background gradient.
final colorProvider = StateNotifierProvider<LanguageNotifier, ColorState>(
    (ref) => LanguageNotifier());

void updateColorTheme(int r, int g, int b, WidgetRef ref) {
  ref.read(colorProvider.notifier).update(
        Color.fromARGB(255, r, g, b),
      );
}
