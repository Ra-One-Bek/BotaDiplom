import 'package:flutter/material.dart';
import '../../l10n/generated/app_localizations.dart';

extension LocalizationExtension on BuildContext {
  AppLocalizations get loc {
    return AppLocalizations.of(this);
  }
}