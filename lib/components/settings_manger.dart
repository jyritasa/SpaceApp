import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../conf/colors.dart';
import '../pages/home.dart';
import '../providers/color_provider.dart';
import 'intro_dialog.dart';

///Global wrapper class for Hive database. Responsible setting up saved [Color]
///for app theme and the app [Locale] when new session is started.
///
///[init] is called in main.dart before [MaterialApp] is created.
class SettingsManager {
  //Creating singelton.
  SettingsManager._();
  static final SettingsManager _settingsManager = SettingsManager._();

  ///Global wrapper class for Hive database. Responsible setting up saved
  ///[Color] for app theme and the app [Locale] when new session is started.
  ///
  ///[init] is called in main.dart before [MaterialApp] is created.
  factory SettingsManager() {
    return _settingsManager;
  }

  static const String _box = "settings";
  static const String _colorKey = "color";
  static const String _localeKey = "locale";
  static const String _showIntroKey = "showIntro";

  //Hive deals with variables as dynamic. It can handle bools but [int]s and
  //[String]s are typed as [dynamic]. This affects: [_color], [_locale],

  bool _setupDone = false;
  //List<int>
  List<dynamic> _color = [
    initialSeedColor.red,
    initialSeedColor.green,
    initialSeedColor.blue
  ];
  //String
  dynamic _locale = "en";
  bool _showIntro = true;

  List<int> get color => _color.cast<int>();
  String get locale => _locale;
  bool get showIntro => _showIntro;
  bool get setupDone => _setupDone;

  ///Initializes global Hive object and retrieves all the settings from the
  ///database.
  Future<void> init() async {
    await Hive.initFlutter();
    var settings = await Hive.openBox(_box);
    _color = await settings.get(
      _colorKey,
      defaultValue: [
        initialSeedColor.red,
        initialSeedColor.green,
        initialSeedColor.blue,
      ],
    );
    _locale = await settings.get(_localeKey, defaultValue: "en");
    _showIntro = await settings.get(_showIntroKey, defaultValue: true);
    settings.close();
  }

  ///Save RGB value for theme seed color and background gradient into Hive.
  Future<void> setColor(int r, int g, int b) async {
    _color = [r, g, b];
    var settings = await Hive.openBox(_box);
    await settings.put(_colorKey, <int>[r, g, b]);
    settings.close();
  }

  ///Save app locale as String ("en", "fi", etc) into Hive.
  Future<void> setLocale(String locale) async {
    _locale = locale;
    var settings = await Hive.openBox(_box);
    await settings.put(_localeKey, locale);
    settings.close();
  }

  ///Marking Intro having been shown and wont be shown again at launch.
  Future<void> disableIntro() async {
    _showIntro = false;
    var settings = await Hive.openBox(_box);
    await settings.put(_showIntroKey, false);
    settings.close();
  }

  ///Updates color theme to one from [Hive], runs [showIntroDialog] and marks
  ///[_setupDone].
  ///
  ///This is called after [HomePage] is built inside the build() function.
  void completeSetUp(WidgetRef ref, context) {
    //Complete setup rebuilds the UI, this is to prevent post-setup from being
    //run more than once.
    if (!_setupDone) {
      updateColorTheme(color[0], color[1], color[2], ref);
      if (showIntro) showIntroDialog(context, ref);
    }
    _setupDone = true;
  }
}
