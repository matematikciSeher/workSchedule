import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

typedef FontStyleApplier = TextStyle Function({TextStyle? textStyle});

/// Uygulamada kullanılabilir yazı tipi tanımları
class AppFontFamily {
  final String id;
  final String displayName;
  final FontStyleApplier apply;

  const AppFontFamily({
    required this.id,
    required this.displayName,
    required this.apply,
  });

  TextStyle style(TextStyle base) => apply(textStyle: base);
}

class AppFontFamilies {
  static const List<AppFontFamily> all = [
    AppFontFamily(
      id: 'roboto',
      displayName: 'Roboto',
      apply: GoogleFonts.roboto,
    ),
    AppFontFamily(
      id: 'inter',
      displayName: 'Inter',
      apply: GoogleFonts.inter,
    ),
    AppFontFamily(
      id: 'poppins',
      displayName: 'Poppins',
      apply: GoogleFonts.poppins,
    ),
    AppFontFamily(
      id: 'nunito',
      displayName: 'Nunito',
      apply: GoogleFonts.nunito,
    ),
    AppFontFamily(
      id: 'open_sans',
      displayName: 'Open Sans',
      apply: GoogleFonts.openSans,
    ),
    AppFontFamily(
      id: 'lato',
      displayName: 'Lato',
      apply: GoogleFonts.lato,
    ),
    AppFontFamily(
      id: 'montserrat',
      displayName: 'Montserrat',
      apply: GoogleFonts.montserrat,
    ),
    AppFontFamily(
      id: 'raleway',
      displayName: 'Raleway',
      apply: GoogleFonts.raleway,
    ),
  ];

  static AppFontFamily get defaultFont => all.first;

  static AppFontFamily? getById(String id) {
    for (final font in all) {
      if (font.id == id) return font;
    }
    return null;
  }
}
