import 'package:flutter/material.dart';
import 'app_font_families.dart';

/// Responsive text stilleri
class AppTextStyles {
  // Temel text stilleri factory
  static TextStyle _baseStyle({
    required double fontSize,
    FontWeight? fontWeight,
    Color? color,
    double? height,
    double? letterSpacing,
    AppFontFamily? fontFamily,
  }) {
    final style = TextStyle(
      fontSize: fontSize,
      fontWeight: fontWeight ?? FontWeight.normal,
      color: color,
      height: height ?? 1.5,
      letterSpacing: letterSpacing ?? 0.0,
    );
    return fontFamily?.style(style) ?? style;
  }

  // Başlık stilleri
  static TextStyle displayLarge({
    required double scale,
    Color? color,
    AppFontFamily? fontFamily,
  }) =>
      _baseStyle(
        fontSize: 32.0 * scale,
        fontWeight: FontWeight.bold,
        color: color,
        height: 1.2,
        fontFamily: fontFamily,
      );

  static TextStyle displayMedium({
    required double scale,
    Color? color,
    AppFontFamily? fontFamily,
  }) =>
      _baseStyle(
        fontSize: 28.0 * scale,
        fontWeight: FontWeight.bold,
        color: color,
        height: 1.2,
        fontFamily: fontFamily,
      );

  static TextStyle displaySmall({
    required double scale,
    Color? color,
    AppFontFamily? fontFamily,
  }) =>
      _baseStyle(
        fontSize: 24.0 * scale,
        fontWeight: FontWeight.bold,
        color: color,
        height: 1.3,
        fontFamily: fontFamily,
      );

  static TextStyle headlineLarge({
    required double scale,
    Color? color,
    AppFontFamily? fontFamily,
  }) =>
      _baseStyle(
        fontSize: 22.0 * scale,
        fontWeight: FontWeight.w600,
        color: color,
        height: 1.3,
        fontFamily: fontFamily,
      );

  static TextStyle headlineMedium({
    required double scale,
    Color? color,
    AppFontFamily? fontFamily,
  }) =>
      _baseStyle(
        fontSize: 20.0 * scale,
        fontWeight: FontWeight.w600,
        color: color,
        height: 1.3,
        fontFamily: fontFamily,
      );

  static TextStyle headlineSmall({
    required double scale,
    Color? color,
    AppFontFamily? fontFamily,
  }) =>
      _baseStyle(
        fontSize: 18.0 * scale,
        fontWeight: FontWeight.w600,
        color: color,
        height: 1.4,
        fontFamily: fontFamily,
      );

  static TextStyle titleLarge({
    required double scale,
    Color? color,
    AppFontFamily? fontFamily,
  }) =>
      _baseStyle(
        fontSize: 16.0 * scale,
        fontWeight: FontWeight.w600,
        color: color,
        height: 1.4,
        fontFamily: fontFamily,
      );

  static TextStyle titleMedium({
    required double scale,
    Color? color,
    AppFontFamily? fontFamily,
  }) =>
      _baseStyle(
        fontSize: 14.0 * scale,
        fontWeight: FontWeight.w500,
        color: color,
        height: 1.4,
        fontFamily: fontFamily,
      );

  static TextStyle titleSmall({
    required double scale,
    Color? color,
    AppFontFamily? fontFamily,
  }) =>
      _baseStyle(
        fontSize: 12.0 * scale,
        fontWeight: FontWeight.w500,
        color: color,
        height: 1.4,
        fontFamily: fontFamily,
      );

  // Gövde stilleri
  static TextStyle bodyLarge({
    required double scale,
    Color? color,
    AppFontFamily? fontFamily,
  }) =>
      _baseStyle(
        fontSize: 16.0 * scale,
        color: color,
        fontFamily: fontFamily,
      );

  static TextStyle bodyMedium({
    required double scale,
    Color? color,
    AppFontFamily? fontFamily,
  }) =>
      _baseStyle(
        fontSize: 14.0 * scale,
        color: color,
        fontFamily: fontFamily,
      );

  static TextStyle bodySmall({
    required double scale,
    Color? color,
    AppFontFamily? fontFamily,
  }) =>
      _baseStyle(
        fontSize: 12.0 * scale,
        color: color,
        fontFamily: fontFamily,
      );

  // Label stilleri
  static TextStyle labelLarge({
    required double scale,
    Color? color,
    AppFontFamily? fontFamily,
  }) =>
      _baseStyle(
        fontSize: 14.0 * scale,
        fontWeight: FontWeight.w500,
        color: color,
        fontFamily: fontFamily,
      );

  static TextStyle labelMedium({
    required double scale,
    Color? color,
    AppFontFamily? fontFamily,
  }) =>
      _baseStyle(
        fontSize: 12.0 * scale,
        fontWeight: FontWeight.w500,
        color: color,
        fontFamily: fontFamily,
      );

  static TextStyle labelSmall({
    required double scale,
    Color? color,
    AppFontFamily? fontFamily,
  }) =>
      _baseStyle(
        fontSize: 10.0 * scale,
        fontWeight: FontWeight.w500,
        color: color,
        fontFamily: fontFamily,
      );
}

