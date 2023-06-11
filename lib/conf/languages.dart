import 'package:flutter/material.dart';

class Language {
  Language({
    required this.name,
    required this.nativeName,
    required this.flag,
  });
  final String name;
  final String nativeName;
  final Image flag;
}

Map<Locale, Language> languages = {
  const Locale("en"): Language(
    name: "English",
    nativeName: "English",
    flag: Image.asset("./assets/img/en_flag.png"),
  ),
  const Locale("fi"): Language(
    name: "Finnish",
    nativeName: "Suomi",
    flag: Image.asset("./assets/img/fi_flag.png"),
  ),
};
