import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'app_colors.dart';
import 'app_text_styles.dart';
import 'theme_models.dart';

/// Light tema tanımı
ThemeData lightTheme(
  double textScaleFactor, {
  AppThemeModel? themeModel,
}) {
  final theme = themeModel ?? AppThemes.defaultTheme;
  
  return ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    colorScheme: theme.lightColorScheme,
    scaffoldBackgroundColor: theme.lightBackground,
    appBarTheme: AppBarTheme(
      elevation: 2,
      centerTitle: false,
      backgroundColor: AppColors.lightSurface,
      foregroundColor: AppColors.lightOnSurface,
      systemOverlayStyle: SystemUiOverlayStyle.dark,
      shadowColor: theme.lightColorScheme.primary.withOpacity(0.1),
      titleTextStyle: AppTextStyles.titleLarge(
        scale: textScaleFactor,
        color: AppColors.lightOnSurface,
      ),
      surfaceTintColor: Colors.transparent,
    ),
    cardTheme: CardThemeData(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(20)),
      ),
      color: AppColors.lightSurface,
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      shadowColor: theme.lightColorScheme.primary.withOpacity(0.15),
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
        borderSide: BorderSide(color: theme.lightColorScheme.primary, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColors.lightError),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        elevation: 3,
        padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 18),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        textStyle: AppTextStyles.labelLarge(scale: textScaleFactor),
        shadowColor: theme.lightColorScheme.primary.withOpacity(0.4),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 18),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        side: BorderSide(
          color: theme.lightColorScheme.primary,
          width: 2,
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
          return theme.lightColorScheme.primary;
        }
        return theme.lightColorScheme.onSurface;
      }),
      trackColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return theme.lightColorScheme.primary.withValues(alpha: 0.5);
        }
        return theme.lightColorScheme.onSurface.withValues(alpha: 0.3);
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
ThemeData darkTheme(
  double textScaleFactor, {
  AppThemeModel? themeModel,
}) {
  final theme = themeModel ?? AppThemes.defaultTheme;
  
  return ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    colorScheme: theme.darkColorScheme,
    scaffoldBackgroundColor: theme.darkBackground,
    appBarTheme: AppBarTheme(
      elevation: 3,
      centerTitle: false,
      backgroundColor: AppColors.darkSurface,
      foregroundColor: AppColors.darkOnSurface,
      systemOverlayStyle: SystemUiOverlayStyle.light,
      shadowColor: theme.darkColorScheme.primary.withOpacity(0.2),
      titleTextStyle: AppTextStyles.titleLarge(
        scale: textScaleFactor,
        color: AppColors.darkOnSurface,
      ),
      surfaceTintColor: Colors.transparent,
    ),
    cardTheme: CardThemeData(
      elevation: 6,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(20)),
        side: BorderSide(
          color: theme.darkColorScheme.primary.withOpacity(0.2),
          width: 1,
        ),
      ),
      color: AppColors.darkSurface,
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      shadowColor: theme.darkColorScheme.primary.withOpacity(0.3),
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
        borderSide: BorderSide(color: theme.darkColorScheme.primary, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColors.darkError),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        elevation: 4,
        padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 18),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        textStyle: AppTextStyles.labelLarge(scale: textScaleFactor),
        shadowColor: theme.darkColorScheme.primary.withOpacity(0.5),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 18),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        side: BorderSide(
          color: theme.darkColorScheme.primary,
          width: 2,
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
          return theme.darkColorScheme.primary;
        }
        return theme.darkColorScheme.onSurface;
      }),
      trackColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return theme.darkColorScheme.primary.withValues(alpha: 0.5);
        }
        return theme.darkColorScheme.onSurface.withValues(alpha: 0.3);
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

