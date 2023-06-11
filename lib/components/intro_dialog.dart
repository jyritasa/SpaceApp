import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:space_app/components/settings_manger.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'language_select_widget.dart';

///Shows introDialog with instructions to use the Application and change
///language with [LanguageSelect].
void showIntroDialog(BuildContext context, WidgetRef ref) {
  const Padding sectionPadding = Padding(padding: EdgeInsets.only(bottom: 16));
  const Padding rowPadding = Padding(padding: EdgeInsets.only(right: 8));
  const EdgeInsets contentPadding = EdgeInsets.all(8);
  const TextStyle titleStyle = TextStyle(fontSize: 32);
  const TextStyle subTitleStyle = TextStyle(fontSize: 24);
  const double maxWidth = 300;

  showDialog(
    barrierDismissible: false,
    context: context,
    builder: (BuildContext context) => Dialog(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: maxWidth),
        child: Padding(
          padding: contentPadding,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      AppLocalizations.of(context)!.infoTitle.toUpperCase(),
                      style: titleStyle,
                    ),
                  ],
                ),
                Text(AppLocalizations.of(context)!.infoText),
                sectionPadding,
                Row(
                  children: [
                    const Icon(Icons.refresh),
                    rowPadding,
                    Text(
                      AppLocalizations.of(context)!.refresh.toUpperCase(),
                      style: subTitleStyle,
                    ),
                  ],
                ),
                Text(AppLocalizations.of(context)!.refreshText),
                sectionPadding,
                Row(
                  children: [
                    const Icon(Icons.menu),
                    rowPadding,
                    Text(AppLocalizations.of(context)!.menuTitle.toUpperCase(),
                        style: subTitleStyle),
                  ],
                ),
                Text(AppLocalizations.of(context)!.menuText),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    LanguageSelect(ref: ref),
                  ],
                ),
                sectionPadding,
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                        SettingsManager().disableIntro();
                      },
                      child: Text(
                          AppLocalizations.of(context)!.dismiss.toUpperCase()),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    ),
  );
}
