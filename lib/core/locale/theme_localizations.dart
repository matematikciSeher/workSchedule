import '../../l10n/app_localizations.dart';

/// Tema renk adlarını locale'e göre döndürür.
String localizedThemeName(AppLocalizations l10n, String themeId) {
  switch (themeId) {
    case 'blue':
      return l10n.themeColorBlue;
    case 'purple':
      return l10n.themeColorPurple;
    case 'green':
      return l10n.themeColorGreen;
    case 'orange':
      return l10n.themeColorOrange;
    case 'red':
      return l10n.themeColorRed;
    case 'pink':
      return l10n.themeColorPink;
    case 'teal':
      return l10n.themeColorTeal;
    case 'cyan':
      return l10n.themeColorCyan;
    case 'indigo':
      return l10n.themeColorIndigo;
    case 'brown':
      return l10n.themeColorBrown;
    case 'grey':
      return l10n.themeColorGrey;
    case 'amber':
      return l10n.themeColorAmber;
    case 'deep_purple':
      return l10n.themeColorDeepPurple;
    case 'light_blue':
      return l10n.themeColorLightBlue;
    case 'lime':
      return l10n.themeColorLime;
    case 'deep_orange':
      return l10n.themeColorDeepOrange;
    case 'blue_grey':
      return l10n.themeColorBlueGrey;
    case 'yellow':
      return l10n.themeColorYellow;
    case 'light_green':
      return l10n.themeColorLightGreen;
    case 'red_accent':
      return l10n.themeColorRedAccent;
    case 'green_accent':
      return l10n.themeColorGreenAccent;
    case 'blue_accent':
      return l10n.themeColorBlueAccent;
    default:
      return themeId;
  }
}

String localizedPreviewColorName(AppLocalizations l10n, String key) {
  switch (key) {
    case 'blue':
      return l10n.themeColorBlue;
    case 'green':
      return l10n.themeColorGreen;
    case 'purple':
      return l10n.themeColorPurple;
    case 'orange':
      return l10n.themeColorOrange;
    case 'red':
      return l10n.themeColorRed;
    case 'teal':
      return l10n.themeColorTeal;
    default:
      return key;
  }
}

String localizedPriority(AppLocalizations l10n, int? priority) {
  switch (priority) {
    case 1:
      return l10n.priorityLow;
    case 2:
      return l10n.priorityMedium;
    case 3:
      return l10n.priorityHigh;
    default:
      return l10n.priorityUnspecified;
  }
}
