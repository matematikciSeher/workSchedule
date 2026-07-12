import '../../l10n/app_localizations.dart';
import 'app_locale.dart';

/// BuildContext olmadan (bildirimler, arka plan servisleri) kullanım için.
AppLocalizations get systemL10n =>
    lookupAppLocalizations(AppLocale.systemLocale);

String systemDateFormatLocale() =>
    AppLocale.dateFormatLocale(AppLocale.systemLocale);
