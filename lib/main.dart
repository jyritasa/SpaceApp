import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'components/settings_manger.dart';
import 'providers/color_provider.dart';
import 'providers/lang_provider.dart';
import 'conf/languages.dart';
import 'pages/home.dart';

void main() async {
  await SettingsManager().init();

  runApp(
    ProviderScope(
      child: NasaApp(
        SettingsManager().color,
        SettingsManager().locale,
        SettingsManager().showIntro,
      ),
    ),
  );
}

class NasaApp extends ConsumerWidget {
  const NasaApp(this.color, this.locale, this.showIntro, {super.key});
  final dynamic color;
  final dynamic locale;
  final bool showIntro;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp(
      locale: ref.watch(languageProvider).locale ?? Locale(locale),
      title: 'Space Creator',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: ref.watch(colorProvider).color ??
              Color.fromARGB(
                255,
                color[0],
                color[1],
                color[2],
              ),
        ),
        useMaterial3: true,
      ),
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: languages.keys,
      home: const HomePage(),
    );
  }
}
