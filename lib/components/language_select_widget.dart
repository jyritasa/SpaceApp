import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:space_app/components/settings_manger.dart';

import '../conf/languages.dart';
import '../providers/lang_provider.dart';

///Dropdown menu for switching current app [Locale].
class LanguageSelect extends StatelessWidget {
  const LanguageSelect({
    super.key,
    required this.ref,
  });

  final WidgetRef ref;

  @override
  Widget build(BuildContext context) {
    return DropdownButtonHideUnderline(
      child: DropdownButton2(
        iconStyleData: const IconStyleData(
            icon: Icon(
          Icons.arrow_drop_down,
          color: Colors.black,
        )),
        items: languages.entries
            .map(
              (e) => DropdownMenuItem<Locale>(
                value: e.key,
                child: Row(
                  children: [
                    const Padding(padding: EdgeInsets.only(right: 5)),
                    e.value.flag,
                    const Padding(padding: EdgeInsets.only(right: 5)),
                    Text(e.value.nativeName),
                  ],
                ),
              ),
            )
            .toList(),
        value: ref.watch(languageProvider).locale ??
            Locale(SettingsManager().locale),
        onChanged: (value) {
          SettingsManager().setLocale(value!.languageCode);
          ref.read(languageProvider.notifier).update(value);
        },
        buttonStyleData: const ButtonStyleData(
          height: 40,
          width: 140,
        ),
        menuItemStyleData: const MenuItemStyleData(
          height: 40,
        ),
      ),
    );
  }
}
