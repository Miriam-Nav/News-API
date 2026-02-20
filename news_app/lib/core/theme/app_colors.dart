import 'package:flutter/material.dart';

/// Paleta de colores centralizada de la aplicación
///
/// Estética: Cybersecurity / Terminal — oscuro, preciso, con acento neón.
///
/// Esta clase define todos los colores utilizados en la aplicación para
/// mantener consistencia visual y facilitar cambios de tema.
///
/// Estilo de diseño:
/// - Fondo oscuro inspirado en terminales y herramientas de ciberseguridad
/// - Acentos cian neón (#00D4FF) para elementos interactivos
/// - Verde menta neón (#00FFB3) para elementos secundarios
/// - Paleta de grises fríos para texto y superficies intermedias
class AppColors {
  AppColors._();

  // ========== Colores Primarios ==========
  static const Color primary = Color(
    0xFF00D4FF,
  ); // Cian neón — acento principal
  static const Color secondary = Color(0xFF0A1628); // Azul abismo profundo
  static const Color tertiary = Color(
    0xFF00FFB3,
  ); // Verde menta neón — acento secundario

  // ========== Colores de Fondo ==========
  static const Color background = Color(
    0xFF0F141E,
  ); // Negro azulado — fondo base
  static const Color surface = Color(0xFF1A1F2E); // Fondo de panel
  static const Color card = Color(0xFF1E2433); // Fondo de tarjeta

  // Alias
  static const Color darkBackground = background;
  static const Color darkSurface = surface;
  static const Color darkCard = card;

  // ========== Colores de Texto ==========
  static const Color textDark = Color(0xFF0D0D0D);
  static const Color textLight = Color(0xFFFFFFFF); // Blanco puro
  static const Color textGrey = Color(0xFF8E98A8); // Gris terminal apagado
  static const Color textWhite = Colors.white;

  // ========== Colores de Categorías ==========
  static const Color categoryTechnology = Color(0xFF2979FF); // Azul fuerte
  static const Color categoryBusiness = Color(0xFF00C853); // Verde éxito
  static const Color categoryEntertainment = Color(0xFFFF4081); // Rosa intenso
  static const Color categorySports = Color(0xFFFFAB00); // Amarillo deportivo
  static const Color categoryScience = Color(0xFF7C4DFF); // Morado vibrante
  static const Color categoryHealth = Color(0xFF00BFA5); // Verde agua
  static const Color categoryWorld = Color(0xFF00B0FF); // Azul cielo brillante
  static const Color categoryGeneral = Color(0xFF546E7A); // Gris azulado

  /// Obtiene el color de una categoría
  static Color getCategoryColor(String category) {
    switch (category.toLowerCase()) {
      case 'technology':
        return categoryTechnology;
      case 'business':
        return categoryBusiness;
      case 'entertainment':
        return categoryEntertainment;
      case 'sports':
        return categorySports;
      case 'science':
        return categoryScience;
      case 'health':
        return categoryHealth;
      case 'world':
        return categoryWorld;
      default:
        return categoryGeneral;
    }
  }

  // ========== Colores de Estado ==========
  static const Color success = Color(0xFF00FFB3); // Verde menta
  static const Color error = Color(0xFFFF3B5C); // Rojo neón
  static const Color warning = Color(0xFFFFD600); // Amarillo alerta
  static const Color info = Color(0xFF00D4FF); // Cian info

  // ========== Neutros ==========
  static const Color white = Colors.white;
  static const Color black = Colors.black;
  static const Color transparent = Colors.transparent;

  // Grises fríos (escala oscura)
  static const Color grey50 = Color(0xFFE8F0F8);
  static const Color grey100 = Color(0xFFCDD8E5);
  static const Color grey200 = Color(0xFF9FB8CC);
  static const Color grey300 = Color(0xFF6E8EA8);
  static const Color grey400 = Color(0xFF4A6680);
  static const Color grey500 = Color(0xFF2E4A63);
  static const Color grey600 = Color(0xFF1E3348);
  static const Color grey700 = Color(0xFF142334);
  static const Color grey800 = Color(0xFF0C1828);
  static const Color grey900 = Color(0xFF060B14);

  // ========== Overlays ==========
  static Color overlayLight = Colors.black.withOpacity(0.25);
  static Color overlayDark = Colors.black.withOpacity(0.65);

  // ========== Shimmer ==========
  static Color shimmerBase = const Color(0xFF1E3348);
  static Color shimmerHighlight = const Color(0xFF2E4A63);

  // ========== Glow / Neon helpers ==========
  static Color get primaryGlow => primary.withOpacity(0.18);
  static Color get tertiaryGlow => tertiary.withOpacity(0.15);
  static Color get errorGlow => error.withOpacity(0.15);
}
