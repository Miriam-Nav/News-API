import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../data/models/noticia_model.dart';
import '../../core/utils/constants.dart';
import '../../core/theme/app_colors.dart';
import 'dart:ui';

/// Página de detalles de una noticia
///
/// Diseño original NEWSPULSE:
/// - Imagen de fondo con blur/overlay
/// - Badge de categoría
/// - Título principal
/// - Información de autor y fecha
/// - Descripción
/// - Botón para leer artículo completo
class DetailPage extends StatelessWidget {
  final NoticiaModel noticia;

  const DetailPage({super.key, required this.noticia});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          // Imagen de fondo con blur
          _buildBackgroundImage(),

          // Contenido principal
          SafeArea(
            child: Column(
              children: [
                // Botón de retroceso
                _buildBackButton(context),

                // Contenido scrollable
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 200),

                        // Contenido sobre fondo oscuro
                        Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                AppColors.background.withOpacity(0.8),
                                AppColors.background,
                              ],
                            ),
                          ),
                          padding: const EdgeInsets.all(24),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Badge de categoría
                              _buildCategoryBadge(),

                              const SizedBox(height: 20),

                              // Título
                              _buildTitle(),

                              const SizedBox(height: 16),

                              // Autor y fecha
                              _buildMetadata(),

                              const SizedBox(height: 24),

                              // Descripción
                              _buildDescription(),

                              const SizedBox(height: 32),

                              // Botón de leer artículo completo
                              _buildReadButton(context),

                              const SizedBox(height: 40),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Imagen de fondo con blur
  ///
  /// Crea un efecto de imagen de fondo difuminada con un gradiente
  /// oscuro que mejora la legibilidad del contenido.
  Widget _buildBackgroundImage() {
    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      height: 400,
      child: Stack(
        fit: StackFit.expand,
        children: [
          CachedNetworkImage(
            imageUrl: noticia.imageUrl,
            fit: BoxFit.cover,
            errorWidget: (context, url, error) =>
                Container(color: AppColors.surface),
          ),
          BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    AppColors.background.withOpacity(0.3),
                    AppColors.background.withOpacity(0.8),
                    AppColors.background,
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Botón de retroceso
  ///
  /// Botón circular para volver a la pantalla anterior.
  /// Tiene un fondo semi-transparente para mejor visibilidad sobre la imagen.
  Widget _buildBackButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Align(
        alignment: Alignment.topLeft,
        child: Container(
          decoration: BoxDecoration(
            color: AppColors.background.withOpacity(0.8),
            shape: BoxShape.circle,
          ),
          child: IconButton(
            icon: const Icon(Icons.arrow_back, color: AppColors.textLight),
            onPressed: () => Navigator.pop(context),
          ),
        ),
      ),
    );
  }

  /// Badge de categoría
  ///
  /// Muestra la categoría de la noticia con estilo outlined.
  Widget _buildCategoryBadge() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: AppColors.primary, width: 1.5),
      ),
      child: Text(
        ApiConstants.getCategoryName(noticia.category).toUpperCase(),
        style: const TextStyle(
          color: AppColors.primary,
          fontSize: 12,
          fontWeight: FontWeight.bold,
          letterSpacing: 1.5,
        ),
      ),
    );
  }

  /// Título principal
  ///
  /// Muestra el título de la noticia con estilo destacado.
  Widget _buildTitle() {
    return Text(
      noticia.title,
      style: const TextStyle(
        color: AppColors.textLight,
        fontSize: 28,
        fontWeight: FontWeight.bold,
        height: 1.3,
      ),
    );
  }

  /// Metadata (autor y fecha)
  ///
  /// Muestra información del autor y fecha de publicación si están disponibles.
  Widget _buildMetadata() {
    return Row(
      children: [
        // Autor
        if (noticia.author.isNotEmpty) ...[
          const Icon(Icons.person_outline, color: AppColors.textGrey, size: 18),
          const SizedBox(width: 6),
          Flexible(
            child: Text(
              noticia.author,
              style: const TextStyle(color: AppColors.textGrey, fontSize: 14),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const SizedBox(width: 16),
        ],

        // Fecha
        if (noticia.published.isNotEmpty)
          Text(
            _formatearFecha(noticia.published),
            style: const TextStyle(color: AppColors.textGrey, fontSize: 14),
          ),
      ],
    );
  }

  /// Descripción
  ///
  /// Muestra la descripción completa de la noticia.
  /// Si no hay descripción disponible, no muestra nada.
  Widget _buildDescription() {
    if (noticia.description.isEmpty) {
      return const SizedBox.shrink();
    }

    return Text(
      noticia.description,
      style: const TextStyle(
        color: AppColors.textGrey,
        fontSize: 16,
        height: 1.6,
      ),
    );
  }

  /// Botón de leer artículo completo
  ///
  /// Botón que abre el artículo completo en el navegador externo.
  Widget _buildReadButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: OutlinedButton(
        onPressed: () => _abrirArticulo(context),
        style: OutlinedButton.styleFrom(
          side: const BorderSide(color: AppColors.primary, width: 1.5),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.open_in_new, color: AppColors.primary, size: 20),
            const SizedBox(width: 12),
            const Text(
              'LEER ARTÍCULO COMPLETO',
              style: TextStyle(
                color: AppColors.primary,
                fontSize: 14,
                fontWeight: FontWeight.bold,
                letterSpacing: 1,
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Formatea la fecha
  ///
  /// Convierte una fecha en formato ISO a un formato legible relativo:
  /// - "Hace Xh" para hoy
  /// - "Hace Xd" para esta semana
  /// - "Hace Xsem" para este mes
  /// - "DD/MM/YYYY" para fechas antiguas
  ///
  /// [fecha] - Fecha en formato ISO string
  /// Returns: Fecha formateada como string legible
  String _formatearFecha(String fecha) {
    try {
      final date = DateTime.parse(fecha);
      final now = DateTime.now();
      final difference = now.difference(date);

      if (difference.inDays == 0) {
        return 'Hace ${difference.inHours}h';
      } else if (difference.inDays == 1) {
        return 'Hace 1d';
      } else if (difference.inDays < 7) {
        return 'Hace ${difference.inDays}d';
      } else if (difference.inDays < 30) {
        final weeks = (difference.inDays / 7).floor();
        return 'Hace ${weeks}sem';
      } else {
        return '${date.day}/${date.month}/${date.year}';
      }
    } catch (e) {
      return fecha;
    }
  }

  /// Abre el artículo completo
  ///
  /// Intenta abrir la URL del artículo en el navegador externo.
  /// Muestra un SnackBar si hay algún error.
  Future<void> _abrirArticulo(BuildContext context) async {
    try {
      final uri = Uri.parse(noticia.url);

      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      } else {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('No se pudo abrir la URL'),
              backgroundColor: AppColors.error,
            ),
          );
        }
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: ${e.toString()}'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    }
  }
}
