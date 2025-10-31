import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'app_colors.dart';
import 'app_text_styles.dart';

/// Light tema tanımı
ThemeData lightTheme(double textScaleFactor) {
  return ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    colorScheme: const ColorScheme.light(
      primary: AppColors.lightPrimary,
      secondary: AppColors.lightSecondary,
      tertiary: AppColors.lightAccent,
      error: AppColors.lightError,
      surface: AppColors.lightSurface,
      onPrimary: AppColors.lightOnPrimary,
      onSecondary: AppColors.lightOnSecondary,
      onError: AppColors.lightOnError,
      onSurface: AppColors.lightOnSurface,
    ),
    scaffoldBackgroundColor: AppColors.lightBackground,
    appBarTheme: AppBarTheme(
      elevation: 0,
      centerTitle: false,
      backgroundColor: AppColors.lightSurface,
      foregroundColor: AppColors.lightOnSurface,
      systemOverlayStyle: SystemUiOverlayStyle.dark,
      titleTextStyle: AppTextStyles.titleLarge(
        scale: textScaleFactor,
        color: AppColors.lightOnSurface,
      ),
    ),
    cardTheme: const CardThemeData(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(12)),
      ),
      color: AppColors.lightSurface,
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: AppColors.lightSurface,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: AppColors.dividerLight),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: AppColors.dividerLight),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColors.lightPrimary, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColors.lightError),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        elevation: 0,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        textStyle: AppTextStyles.labelLarge(scale: textScaleFactor),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        textStyle: AppTextStyles.labelLarge(scale: textScaleFactor),
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        textStyle: AppTextStyles.labelLarge(scale: textScaleFactor),
      ),
    ),
    dividerTheme: const DividerThemeData(
      color: AppColors.dividerLight,
      thickness: 1,
      space: 1,
    ),
    switchTheme: SwitchThemeData(
      thumbColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return AppColors.lightPrimary;
        }
        return AppColors.lightOnSurface;
      }),
      trackColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return AppColors.lightPrimary.withValues(alpha: 0.5);
        }
        return AppColors.lightOnSurface.withValues(alpha: 0.3);
      }),
    ),
    textTheme: TextTheme(
      displayLarge: AppTextStyles.displayLarge(scale: textScaleFactor),
      displayMedium: AppTextStyles.displayMedium(scale: textScaleFactor),
      displaySmall: AppTextStyles.displaySmall(scale: textScaleFactor),
      headlineLarge: AppTextStyles.headlineLarge(scale: textScaleFactor),
      headlineMedium: AppTextStyles.headlineMedium(scale: textScaleFactor),
      headlineSmall: AppTextStyles.headlineSmall(scale: textScaleFactor),
      titleLarge: AppTextStyles.titleLarge(scale: textScaleFactor),
      titleMedium: AppTextStyles.titleMedium(scale: textScaleFactor),
      titleSmall: AppTextStyles.titleSmall(scale: textScaleFactor),
      bodyLarge: AppTextStyles.bodyLarge(scale: textScaleFactor),
      bodyMedium: AppTextStyles.bodyMedium(scale: textScaleFactor),
      bodySmall: AppTextStyles.bodySmall(scale: textScaleFactor),
      labelLarge: AppTextStyles.labelLarge(scale: textScaleFactor),
      labelMedium: AppTextStyles.labelMedium(scale: textScaleFactor),
      labelSmall: AppTextStyles.labelSmall(scale: textScaleFactor),
    ),
  );
}

/// Dark tema tanımı
ThemeData darkTheme(double textScaleFactor) {
  return ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    colorScheme: const ColorScheme.dark(
      primary: AppColors.darkPrimary,
      secondary: AppColors.darkSecondary,
      tertiary: AppColors.darkAccent,
      error: AppColors.darkError,
      surface: AppColors.darkSurface,
      onPrimary: AppColors.darkOnPrimary,
      onSecondary: AppColors.darkOnSecondary,
      onError: AppColors.darkOnError,
      onSurface: AppColors.darkOnSurface,
    ),
    scaffoldBackgroundColor: AppColors.darkBackground,
    appBarTheme: AppBarTheme(
      elevation: 0,
      centerTitle: false,
      backgroundColor: AppColors.darkSurface,
      foregroundColor: AppColors.darkOnSurface,
      systemOverlayStyle: SystemUiOverlayStyle.light,
      titleTextStyle: AppTextStyles.titleLarge(
        scale: textScaleFactor,
        color: AppColors.darkOnSurface,
      ),
    ),
    cardTheme: const CardThemeData(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(12)),
        side: BorderSide(color: AppColors.dividerDark, width: 1),
      ),
      color: AppColors.darkSurface,
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: AppColors.darkSurface,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: AppColors.dividerDark),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: AppColors.dividerDark),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColors.darkPrimary, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColors.darkError),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        elevation: 0,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        textStyle: AppTextStyles.labelLarge(scale: textScaleFactor),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        textStyle: AppTextStyles.labelLarge(scale: textScaleFactor),
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        textStyle: AppTextStyles.labelLarge(scale: textScaleFactor),
      ),
    ),
    dividerTheme: const DividerThemeData(
      color: AppColors.dividerDark,
      thickness: 1,
      space: 1,
    ),
    switchTheme: SwitchThemeData(
      thumbColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return AppColors.darkPrimary;
        }
        return AppColors.darkOnSurface;
      }),
      trackColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return AppColors.darkPrimary.withValues(alpha: 0.5);
        }
        return AppColors.darkOnSurface.withValues(alpha: 0.3);
      }),
    ),
    textTheme: TextTheme(
      displayLarge: AppTextStyles.displayLarge(scale: textScaleFactor),
      displayMedium: AppTextStyles.displayMedium(scale: textScaleFactor),
      displaySmall: AppTextStyles.displaySmall(scale: textScaleFactor),
      headlineLarge: AppTextStyles.headlineLarge(scale: textScaleFactor),
      headlineMedium: AppTextStyles.headlineMedium(scale: textScaleFactor),
      headlineSmall: AppTextStyles.headlineSmall(scale: textScaleFactor),
      titleLarge: AppTextStyles.titleLarge(scale: textScaleFactor),
      titleMedium: AppTextStyles.titleMedium(scale: textScaleFactor),
      titleSmall: AppTextStyles.titleSmall(scale: textScaleFactor),
      bodyLarge: AppTextStyles.bodyLarge(scale: textScaleFactor),
      bodyMedium: AppTextStyles.bodyMedium(scale: textScaleFactor),
      bodySmall: AppTextStyles.bodySmall(scale: textScaleFactor),
      labelLarge: AppTextStyles.labelLarge(scale: textScaleFactor),
      labelMedium: AppTextStyles.labelMedium(scale: textScaleFactor),
      labelSmall: AppTextStyles.labelSmall(scale: textScaleFactor),
    ),
  );
}

