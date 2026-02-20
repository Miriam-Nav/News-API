/// Dimensiones y espaciados centralizados de la aplicación
///
/// Define todos los valores numéricos de diseño (padding, margin,
/// border radius, etc.) para mantener consistencia visual.
class AppDimensions {
  AppDimensions._(); // Constructor privado

  // ========== Border Radius ==========
  static const double radiusXS = 4.0;
  static const double radiusS = 8.0;
  static const double radiusM = 12.0;
  static const double radiusL = 16.0;
  static const double radiusXL = 20.0;
  static const double radius2XL = 24.0;
  static const double radiusFull = 999.0;

  // ========== Padding & Margin ==========
  static const double spaceXS = 4.0;
  static const double spaceS = 8.0;
  static const double spaceM = 12.0;
  static const double spaceL = 16.0;
  static const double spaceXL = 20.0;
  static const double space2XL = 24.0;
  static const double space3XL = 32.0;
  static const double space4XL = 40.0;

  // ========== Elevations ==========
  static const double elevationNone = 0.0;
  static const double elevationXS = 1.0;
  static const double elevationS = 2.0;
  static const double elevationM = 4.0;
  static const double elevationL = 8.0;
  static const double elevationXL = 12.0;
  static const double elevation2XL = 16.0;

  // ========== Tamaños de Componentes ==========
  static const double iconSizeXS = 16.0;
  static const double iconSizeS = 20.0;
  static const double iconSizeM = 24.0;
  static const double iconSizeL = 32.0;
  static const double iconSizeXL = 40.0;
  static const double iconSize2XL = 48.0;

  static const double buttonHeightS = 36.0;
  static const double buttonHeightM = 44.0;
  static const double buttonHeightL = 52.0;

  // ========== Tamaños de Tarjetas ==========
  static const double cardImageWidthS = 80.0;
  static const double cardImageWidthM = 100.0;
  static const double cardImageWidthL = 120.0;

  static const double cardImageHeightS = 80.0;
  static const double cardImageHeightM = 100.0;
  static const double cardImageHeightL = 120.0;

  static const double carouselHeight = 240.0;
  static const double carouselViewportFraction = 0.9;

  // ========== Anchos Máximos ==========
  static const double maxContentWidth = 1200.0;
  static const double maxCardWidth = 600.0;

  // ========== Border Width ==========
  static const double borderWidthThin = 0.5;
  static const double borderWidthNormal = 1.0;
  static const double borderWidthThick = 2.0;
  static const double borderWidthBold = 3.0;

  // ========== Blur Radius para Sombras ==========
  static const double blurRadiusS = 4.0;
  static const double blurRadiusM = 8.0;
  static const double blurRadiusL = 12.0;
  static const double blurRadiusXL = 16.0;

  // ========== Opacidades ==========
  static const double opacityDisabled = 0.38;
  static const double opacityMedium = 0.6;
  static const double opacityHigh = 0.87;
  static const double opacityFull = 1.0;

  // ========== Tamaños Específicos de Widgets ==========
  static const double appBarHeight = 56.0;
  static const double bottomNavHeight = 60.0;
  static const double tabBarHeight = 48.0;

  // ========== Duraciones de Animaciones (en milisegundos) ==========
  static const int animationFast = 150;
  static const int animationNormal = 300;
  static const int animationSlow = 500;
}
