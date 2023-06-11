import 'package:file_saver/file_saver.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:space_app/components/intro_dialog.dart';

import '../components/background_widget.dart';
import '../components/background_functions.dart';
import '../components/file_creation_functions.dart';
import '../components/language_select_widget.dart';
import '../components/logger.dart';
import '../components/settings_manger.dart';
import '../components/snackbars.dart';

import '/providers/color_provider.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends ConsumerState<HomePage> {
  List<CelestialPointData>? _stars, _planets;
  Color? _themeColor;
  int? _colorR, _colorG, _colorB, _oldColorR, _oldColorG, _oldColorB;

  /// Controls the canvas redraw animation.
  ///
  /// This prevents animation from being replayed when state is set (when b
  /// ackground color is updated, sliders are moved.)
  bool _playAnimation = true;
  //using mediaquery causes canvas to redraw itself when screensize changes or
  //parent widget state changes.
  ///Gets Width and Height of the screen from WidgetsBinding
  ///
  ///Returns (w: double, h: double)
  getCanvasSize() {
    double width = WidgetsBinding
            .instance.platformDispatcher.views.first.physicalSize.width /
        WidgetsBinding.instance.platformDispatcher.views.first.devicePixelRatio;
    double height = WidgetsBinding
            .instance.platformDispatcher.views.first.physicalSize.height /
        WidgetsBinding.instance.platformDispatcher.views.first.devicePixelRatio;
    return (w: width, h: height);
  }

  ///Gets the initial RGB values and updates old color values to current.
  void setColors() {
    if (_themeColor == null && !SettingsManager().setupDone) {
      _colorB = SettingsManager().color[2];
      _colorG = SettingsManager().color[1];
      _colorR = SettingsManager().color[0];
    }
    _oldColorR = _colorR;
    _oldColorG = _colorG;
    _oldColorB = _colorB;
  }

  @override
  void initState() {
    var size = getCanvasSize();
    if (_stars == null || _planets == null) {
      _stars = generateStars(size.w, size.h);
      _planets = generatePlanets(size.w, size.h);
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var size = getCanvasSize();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      SettingsManager().completeSetUp(ref, context);
    });

    setColors();
    return Scaffold(
      drawer: Drawer(
        child: drawerContent(),
      ),
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        title: Text(AppLocalizations.of(context)!.homePageTitle),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: LanguageSelect(ref: ref),
          )
        ],
      ),
      body: Container(
        color: Colors.black,
        child: StarryBackground(
          key: UniqueKey(),
          width: size.w,
          height: size.h,
          planets: _planets!,
          stars: _stars!,
        )
            .animate(
              key: UniqueKey(),
              onComplete: (_) => _playAnimation = false,
            )
            .fade(duration: Duration(milliseconds: (_playAnimation) ? 350 : 1))
            .scale(
                duration: Duration(milliseconds: (_playAnimation) ? 350 : 1)),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _playAnimation = true;
          _stars = generateStars(size.w, size.h);
          _planets = generatePlanets(size.w, size.h);
          setState(() {});
        },
        tooltip: AppLocalizations.of(context)!.refresh,
        child: const Icon(Icons.refresh),
      ),
    );
  }

  Widget drawerContent() {
    return ListView(
      children: [
        DrawerHeader(
          decoration: BoxDecoration(color: ref.watch(colorProvider).color),
          child: Image.asset("./assets/img/saturn.png"),
        ),
        StatefulBuilder(
          builder: (BuildContext context, setColorState) {
            return Column(
              children: [
                Slider(
                  value: _colorR!.toDouble(),
                  max: 255,
                  divisions: 255,
                  label: _colorR!.round().toString(),
                  onChanged: (double value) {
                    setColorState(() {
                      _colorR = value.toInt();
                    });
                  },
                ),
                Slider(
                  value: _colorG!.toDouble(),
                  max: 255,
                  divisions: 255,
                  label: _colorG!.round().toString(),
                  onChanged: (double value) {
                    setColorState(() {
                      _colorG = value.toInt();
                    });
                  },
                ),
                Slider(
                  value: _colorB!.toDouble(),
                  max: 255,
                  divisions: 255,
                  label: _colorB!.round().toString(),
                  onChanged: (double value) {
                    setColorState(() {
                      _colorB = value.toInt();
                    });
                  },
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Container(
                    height: 50,
                    color: Color.fromARGB(
                      255,
                      _colorR!.toInt(),
                      _colorG!.toInt(),
                      _colorB!.toInt(),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Container(
                    height: 50,
                    color: Color.fromARGB(
                      255,
                      _oldColorR!.toInt(),
                      _oldColorG!.toInt(),
                      _oldColorB!.toInt(),
                    ),
                  ),
                ),
                const Padding(padding: EdgeInsets.only(bottom: 8)),
                ListTile(
                  onTap: () => setColorState(() {
                    updateColorTheme(_colorR!, _colorG!, _colorB!, ref);
                    SettingsManager().setColor(_colorR!, _colorG!, _colorB!);
                  }),
                  title: Text(AppLocalizations.of(context)!.changeThemeColor),
                  leading: const Icon(Icons.format_paint),
                ),
                ListTile(
                  onTap: () => setColorState(() {
                    _colorR = _oldColorR;
                    _colorG = _oldColorG;
                    _colorB = _oldColorB;
                  }),
                  title: Text(AppLocalizations.of(context)!.resetThemeValues),
                  leading: const Icon(Icons.undo),
                ),
                ListTile(
                  title: Text(AppLocalizations.of(context)!.downloadImage),
                  leading: const Icon(Icons.download),
                  onTap: () => saveImageButtonClick(),
                ),
                ListTile(
                  title: Text(AppLocalizations.of(context)!.infoTitle),
                  leading: const Icon(Icons.info_outline),
                  onTap: () => showIntroDialog(context, ref),
                ),
              ],
            );
          },
        ),
      ],
    );
  }

  ///Closes Drawer, Generates Image and Saves it.
  void saveImageButtonClick() async {
    Navigator.pop(context);
    ScaffoldMessenger.of(context).showSnackBar(creatingFileSnackBar(context));
    try {
      var size = getCanvasSize();
      await generateSpaceImgData(
        size.w,
        size.h,
        _stars!,
        _planets!,
        [
          ref.watch(colorProvider).color?.withOpacity(0.2) ??
              Color.fromRGBO(
                SettingsManager().color[0],
                SettingsManager().color[1],
                SettingsManager().color[2],
                0.2,
              ),
          Colors.white.withOpacity(0.0),
        ],
      ).then(
        (value) async {
          if (kIsWeb) {
            await FileSaver.instance.saveFile(
              name: "image.png",
              bytes: value,
            );
          } else {
            await writeFile(value!, "img.png");
          }
        },
      ).then((value) {
        ScaffoldMessenger.of(context).hideCurrentSnackBar();
        ScaffoldMessenger.of(context).showSnackBar(doneSnackBar(context));
      });
    } catch (e) {
      logger.e(e);
      ScaffoldMessenger.of(context).showSnackBar(
          errorSnackBar(AppLocalizations.of(context)!.imageDownloadError));
    }
  }
}
