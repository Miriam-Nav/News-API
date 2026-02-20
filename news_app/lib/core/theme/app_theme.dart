import 'package:flutter/material.dart';
import 'app_colors.dart';
import 'app_text_styles.dart';
import 'app_dimensions.dart';

/// Configuración del tema de la aplicación
///
/// Proporciona el tema oscuro de la aplicación
/// utilizando los colores, estilos de texto y dimensiones definidos.
class AppTheme {
  AppTheme._(); // Constructor privado

  /// Tema oscuro de la aplicación
  static ThemeData get darkTheme {
    return ThemeData(
      // Configuración general
      useMaterial3: true,
      brightness: Brightness.dark,

      // Color Scheme
      colorScheme: ColorScheme.dark(
        primary: AppColors.primary,
        secondary: AppColors.secondary,
        tertiary: AppColors.tertiary,
        surface: AppColors.darkSurface,
        background: AppColors.darkBackground,
        onPrimary: AppColors.white,
        onSecondary: AppColors.white,
        onSurface: AppColors.textLight,
        onBackground: AppColors.textLight,
        error: AppColors.error,
      ),

      // Scaffold
      scaffoldBackgroundColor: AppColors.darkBackground,

      // AppBar
      appBarTheme: const AppBarTheme(
        centerTitle: false,
        elevation: AppDimensions.elevationNone,
        backgroundColor: AppColors.transparent,
        foregroundColor: AppColors.textLight,
        titleTextStyle: TextStyle(
          fontFamily: AppTextStyles.fontFamilyHeadline,
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: AppColors.textLight,
        ),
      ),

      // Cards
      cardTheme: CardThemeData(
        elevation: AppDimensions.elevationNone,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDimensions.radiusL),
        ),
        color: AppColors.darkCard,
      ),

      // Text Theme
      textTheme: TextTheme(
        headlineLarge: AppTextStyles.headlineLarge.copyWith(
          color: AppColors.textLight,
        ),
        headlineMedium: AppTextStyles.headlineMedium.copyWith(
          color: AppColors.textLight,
        ),
        headlineSmall: AppTextStyles.headlineSmall.copyWith(
          color: AppColors.textLight,
        ),
        titleLarge: AppTextStyles.titleLarge.copyWith(
          color: AppColors.textLight,
        ),
        titleMedium: AppTextStyles.titleMedium.copyWith(
          color: AppColors.textLight,
        ),
        titleSmall: AppTextStyles.titleSmall.copyWith(
          color: AppColors.textLight,
        ),
        bodyLarge: AppTextStyles.bodyLarge.copyWith(color: AppColors.textLight),
        bodyMedium: AppTextStyles.bodyMedium.copyWith(
          color: AppColors.textLight,
        ),
        bodySmall: AppTextStyles.bodySmall.copyWith(color: AppColors.textLight),
        labelLarge: AppTextStyles.labelLarge.copyWith(
          color: AppColors.textLight,
        ),
        labelMedium: AppTextStyles.labelMedium.copyWith(
          color: AppColors.textLight,
        ),
        labelSmall: AppTextStyles.labelSmall.copyWith(
          color: AppColors.textLight,
        ),
      ),

      // Elevated Button
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          elevation: AppDimensions.elevationS,
          padding: const EdgeInsets.symmetric(
            horizontal: AppDimensions.spaceXL,
            vertical: AppDimensions.spaceM,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppDimensions.radiusM),
          ),
        ),
      ),

      // Icon Theme
      iconTheme: const IconThemeData(
        color: AppColors.textLight,
        size: AppDimensions.iconSizeM,
      ),

      // Divider
      dividerTheme: DividerThemeData(
        color: AppColors.grey700,
        thickness: AppDimensions.borderWidthThin,
        space: AppDimensions.spaceL,
      ),

      // Input Decoration
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.darkSurface,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppDimensions.radiusM),
          borderSide: const BorderSide(color: AppColors.grey700),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppDimensions.radiusM),
          borderSide: const BorderSide(color: AppColors.grey700),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppDimensions.radiusM),
          borderSide: const BorderSide(
            color: AppColors.primary,
            width: AppDimensions.borderWidthThick,
          ),
        ),
      ),
    );
  }
}
