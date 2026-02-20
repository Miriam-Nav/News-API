import 'package:flutter/material.dart';

/// Estilos de texto centralizados de la aplicación
///
/// Define todos los estilos de texto utilizados en la app para
/// mantener tipografía consistente.
class AppTextStyles {
  AppTextStyles._(); // Constructor privado

  // ========== Fuentes ==========
  static const String fontFamilyHeadline = 'Montserrat';
  static const String fontFamilyBody = 'Inter';

  // ========== Headlines ==========
  static const TextStyle headlineLarge = TextStyle(
    fontFamily: fontFamilyHeadline,
    fontWeight: FontWeight.bold,
    fontSize: 32,
    letterSpacing: -0.5,
    height: 1.2,
  );

  static const TextStyle headlineMedium = TextStyle(
    fontFamily: fontFamilyHeadline,
    fontWeight: FontWeight.bold,
    fontSize: 28,
    letterSpacing: -0.5,
    height: 1.2,
  );

  static const TextStyle headlineSmall = TextStyle(
    fontFamily: fontFamilyHeadline,
    fontWeight: FontWeight.bold,
    fontSize: 24,
    letterSpacing: -0.5,
    height: 1.3,
  );

  // ========== Titles ==========
  static const TextStyle titleLarge = TextStyle(
    fontFamily: fontFamilyBody,
    fontWeight: FontWeight.w600,
    fontSize: 22,
    height: 1.3,
  );

  static const TextStyle titleMedium = TextStyle(
    fontFamily: fontFamilyBody,
    fontWeight: FontWeight.w600,
    fontSize: 16,
    height: 1.4,
  );

  static const TextStyle titleSmall = TextStyle(
    fontFamily: fontFamilyBody,
    fontWeight: FontWeight.w600,
    fontSize: 14,
    height: 1.4,
  );

  // ========== Body ==========
  static const TextStyle bodyLarge = TextStyle(
    fontFamily: fontFamilyBody,
    fontSize: 16,
    height: 1.6,
    fontWeight: FontWeight.normal,
  );

  static const TextStyle bodyMedium = TextStyle(
    fontFamily: fontFamilyBody,
    fontSize: 14,
    height: 1.5,
    fontWeight: FontWeight.normal,
  );

  static const TextStyle bodySmall = TextStyle(
    fontFamily: fontFamilyBody,
    fontSize: 12,
    height: 1.5,
    fontWeight: FontWeight.normal,
  );

  // ========== Label ==========
  static const TextStyle labelLarge = TextStyle(
    fontFamily: fontFamilyBody,
    fontSize: 14,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.1,
  );

  static const TextStyle labelMedium = TextStyle(
    fontFamily: fontFamilyBody,
    fontSize: 12,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.5,
  );

  static const TextStyle labelSmall = TextStyle(
    fontFamily: fontFamilyBody,
    fontSize: 11,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.5,
  );

  // ========== Estilos Personalizados ==========
  static const TextStyle categoryBadge = TextStyle(
    fontFamily: fontFamilyBody,
    fontSize: 12,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.5,
  );

  static const TextStyle timestamp = TextStyle(
    fontFamily: fontFamilyBody,
    fontSize: 12,
    fontWeight: FontWeight.normal,
    letterSpacing: 0.2,
  );

  static const TextStyle readingTime = TextStyle(
    fontFamily: fontFamilyBody,
    fontSize: 11,
    fontWeight: FontWeight.w500,
  );

  static const TextStyle articleSource = TextStyle(
    fontFamily: fontFamilyBody,
    fontSize: 13,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.2,
  );

  static const TextStyle buttonText = TextStyle(
    fontFamily: fontFamilyBody,
    fontSize: 14,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.5,
  );
}
