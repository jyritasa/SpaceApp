import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../conf/colors.dart';

SnackBar messageSnackBar(String text, Widget? trailing) => SnackBar(
      content: Row(
        children: [
          Text(text),
          const Padding(
            padding: EdgeInsets.only(right: 5),
          ),
          if (trailing != null) trailing,
        ],
      ),
    );

SnackBar errorSnackBar(String errText) => SnackBar(
      backgroundColor: errorColor,
      content: Row(
        children: [
          Text(
            errText,
            style: const TextStyle(color: Colors.white),
          ),
          const Padding(
            padding: EdgeInsets.only(right: 5),
          ),
          const Icon(
            Icons.error_outline,
            color: Colors.white,
          ),
        ],
      ),
    );

SnackBar creatingFileSnackBar(context) => messageSnackBar(
    AppLocalizations.of(context)!.creatingFile,
    const CupertinoActivityIndicator());

SnackBar doneSnackBar(context) =>
    messageSnackBar(AppLocalizations.of(context)!.done, const Icon(Icons.done));
