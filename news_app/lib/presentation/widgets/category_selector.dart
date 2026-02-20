import 'package:flutter/material.dart';
import '../../core/utils/constants.dart';
import '../../core/theme/app_colors.dart';

/// Widget para seleccionar categorías de noticias
///
/// Diseño original NEWSPULSE:
/// - Lista horizontal scrollable
/// - Chips con iconos y texto
/// - "Todo" seleccionado por defecto
/// - Estilo outlined cuando no está seleccionado
class CategorySelector extends StatelessWidget {
  final String categoriaSeleccionada;
  final Function(String) onCategoriaSeleccionada;

  const CategorySelector({
    super.key,
    required this.categoriaSeleccionada,
    required this.onCategoriaSeleccionada,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 56,
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: ApiConstants.categorias.length,
        itemBuilder: (context, index) {
          final categoria = ApiConstants.categorias[index];
          final estaSeleccionada = categoriaSeleccionada == categoria;

          return Padding(
            padding: const EdgeInsets.only(right: 12),
            child: _CategoryChip(
              categoria: categoria,
              estaSeleccionada: estaSeleccionada,
              onTap: () => onCategoriaSeleccionada(categoria),
            ),
          );
        },
      ),
    );
  }
}

/// Chip individual de categoría
///
/// Widget privado que representa un botón de categoría individual.
/// Muestra el icono y nombre de la categoría con diferentes estilos
/// según si está seleccionada o no.
///
/// Propiedades:
/// - [categoria]: Identificador de la categoría (e.g., 'technology', 'sports')
/// - [estaSeleccionada]: Indica si esta categoría está actualmente seleccionada
/// - [onTap]: Callback que se ejecuta al hacer clic en el chip
class _CategoryChip extends StatelessWidget {
  final String categoria;
  final bool estaSeleccionada;
  final VoidCallback onTap;

  const _CategoryChip({
    required this.categoria,
    required this.estaSeleccionada,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: estaSeleccionada ? AppColors.primary : Colors.transparent,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: estaSeleccionada
                  ? AppColors.primary
                  : AppColors.textGrey.withOpacity(0.3),
              width: 1.5,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                ApiConstants.getCategoryIcon(categoria),
                size: 18,
                color: estaSeleccionada
                    ? AppColors.background
                    : AppColors.textLight,
              ),
              const SizedBox(width: 8),
              Text(
                ApiConstants.getCategoryName(categoria),
                style: TextStyle(
                  color: estaSeleccionada
                      ? AppColors.background
                      : AppColors.textLight,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
