import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../data/models/noticia_model.dart';
import '../../core/theme/app_colors.dart';
import '../pages/detail_page.dart';

/// Widget que muestra una tarjeta de noticia
///
/// Diseño original NEWSPULSE:
/// - Imagen de portada con barra cyan superior
/// - Título superpuesto sobre fondo oscuro
/// - Navegación a página de detalles al hacer clic
class NoticiaCard extends StatelessWidget {
  final NoticiaModel noticia;

  const NoticiaCard({super.key, required this.noticia});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _navegarADetalle(context),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.card,
          borderRadius: BorderRadius.circular(8),
        ),
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Imagen con barra cyan superior
            _buildImagen(),

            // Título
            _buildTitulo(),
          ],
        ),
      ),
    );
  }

  /// Construye el widget de la imagen con barra cyan
  Widget _buildImagen() {
    return Stack(
      children: [
        // Imagen de portada
        AspectRatio(
          aspectRatio: 16 / 11,
          child: CachedNetworkImage(
            imageUrl: noticia.imageUrl,
            fit: BoxFit.cover,
            placeholder: (context, url) => Container(
              color: AppColors.surface,
              child: const Center(
                child: CircularProgressIndicator(
                  color: AppColors.primary,
                  strokeWidth: 2,
                ),
              ),
            ),
            errorWidget: (context, url, error) => Container(
              color: AppColors.surface,
              child: const Center(
                child: Icon(
                  Icons.image_not_supported_outlined,
                  size: 40,
                  color: AppColors.textGrey,
                ),
              ),
            ),
          ),
        ),

        // Barra cyan en la parte superior
        Positioned(
          top: 0,
          left: 0,
          right: 0,
          child: Container(
            height: 3,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [AppColors.primary, AppColors.primary.withOpacity(0.6)],
              ),
            ),
          ),
        ),
      ],
    );
  }

  /// Construye el título
  ///
  /// Muestra el título de la noticia con un máximo de 3 líneas.
  /// Usa ellipsis para texto que excede el espacio disponible.
  Widget _buildTitulo() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Text(
        noticia.title,
        maxLines: 3,
        overflow: TextOverflow.ellipsis,
        style: const TextStyle(
          color: AppColors.textLight,
          fontSize: 15,
          fontWeight: FontWeight.w600,
          height: 1.4,
        ),
      ),
    );
  }

  /// Navega a la página de detalles
  ///
  /// Abre DetailPage pasando la noticia como parámetro.
  void _navegarADetalle(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => DetailPage(noticia: noticia)),
    );
  }
}
