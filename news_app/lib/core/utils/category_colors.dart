import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

/// Utilidades para categorías SIN colores específicos.
/// Todas las categorías comparten el mismo color.
/// Se mantienen los emojis porque son útiles visualmente.
class CategoryColors {
  CategoryColors._();

  /// Color único para todas las categorías
  static const Color categoryColor = AppColors.primary;

  /// Color claro para fondos
  static Color light({bool isDark = false}) {
    return categoryColor.withOpacity(isDark ? 0.25 : 0.12);
  }

  /// Color oscuro para bordes o sombras
  static Color dark() {
    return Color.lerp(categoryColor, Colors.black, 0.25) ?? categoryColor;
  }

  /// Gradiente único (opcional)
  static LinearGradient gradient() {
    return LinearGradient(
      colors: [
        categoryColor,
        dark(),
      ],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    );
  }
}
