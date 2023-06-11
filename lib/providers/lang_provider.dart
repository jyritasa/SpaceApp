import 'package:flutter/material.dart';
import 'package:riverpod/riverpod.dart';

@immutable
class LanguageState {
  const LanguageState({required this.locale});
  final Locale? locale;
}

class LanguageNotifier extends StateNotifier<LanguageState> {
  LanguageNotifier() : super(const LanguageState(locale: null));
  void update(Locale locale) => state = LanguageState(locale: locale);
}

///State management for app Locale.
final languageProvider = StateNotifierProvider<LanguageNotifier, LanguageState>(
    (ref) => LanguageNotifier());
