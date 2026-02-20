import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/noticia_provider.dart';
import '../widgets/noticia_card.dart';
import '../../core/theme/app_colors.dart';

/// Pantalla de búsqueda de noticias
///
/// Diseño original NEWSPULSE:
/// - AppBar con campo de búsqueda
/// - Grid de resultados en 3 columnas
/// - Estados de carga, vacío y error
class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();
  bool _hasSearched = false;

  @override
  void initState() {
    super.initState();
    // Enfocar automáticamente el campo de búsqueda
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _searchFocusNode.requestFocus();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: _buildAppBar(context),
      body: _buildBody(),
    );
  }

  /// Construye el AppBar con campo de búsqueda
  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: AppColors.surface,
      elevation: 0,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: AppColors.textLight),
        onPressed: () => Navigator.pop(context),
      ),
      title: TextField(
        controller: _searchController,
        focusNode: _searchFocusNode,
        style: const TextStyle(color: AppColors.textLight, fontSize: 16),
        decoration: InputDecoration(
          hintText: 'Buscar noticias...',
          hintStyle: TextStyle(
            color: AppColors.textGrey.withOpacity(0.6),
            fontSize: 16,
          ),
          border: InputBorder.none,
          suffixIcon: _searchController.text.isNotEmpty
              ? IconButton(
                  icon: const Icon(Icons.clear, color: AppColors.textGrey),
                  onPressed: () {
                    _searchController.clear();
                    setState(() {
                      _hasSearched = false;
                    });
                  },
                )
              : null,
        ),
        onSubmitted: (query) {
          if (query.trim().isNotEmpty) {
            _realizarBusqueda(query.trim());
          }
        },
        onChanged: (value) {
          setState(() {});
        },
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.search, color: AppColors.primary),
          onPressed: () {
            if (_searchController.text.trim().isNotEmpty) {
              _realizarBusqueda(_searchController.text.trim());
            }
          },
        ),
      ],
    );
  }

  /// Construye el cuerpo de la página
  ///
  /// Muestra diferentes estados según si se ha realizado una búsqueda:
  /// - Estado inicial: guía de cómo buscar
  /// - Cargando: indicador de progreso
  /// - Error: mensaje de error
  /// - Vacío: sin resultados
  /// - Con datos: grid de noticias
  Widget _buildBody() {
    if (!_hasSearched) {
      return _buildInitialState();
    }

    return Consumer<NoticiaProvider>(
      builder: (context, provider, child) {
        // Estado de carga
        if (provider.estado == NoticiaEstado.cargando) {
          return _buildLoadingState();
        }

        // Estado de error
        if (provider.estado == NoticiaEstado.error) {
          return _buildErrorState(provider.mensajeError);
        }

        // Estado vacío
        if (provider.noticias.isEmpty) {
          return _buildEmptyState();
        }

        // Grid de resultados
        return GridView.builder(
          padding: const EdgeInsets.all(16),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            childAspectRatio: 0.75,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
          ),
          itemCount: provider.noticias.length,
          itemBuilder: (context, index) {
            final noticia = provider.noticias[index];
            return NoticiaCard(noticia: noticia);
          },
        );
      },
    );
  }

  /// Estado inicial
  ///
  /// Muestra una guía para el usuario indicando cómo usar la búsqueda.
  Widget _buildInitialState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.search,
            size: 80,
            color: AppColors.textGrey.withOpacity(0.3),
          ),
          const SizedBox(height: 24),
          const Text(
            'Buscar noticias',
            style: TextStyle(
              color: AppColors.textLight,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Escribe una palabra clave y presiona Enter',
            style: TextStyle(
              color: AppColors.textGrey.withOpacity(0.8),
              fontSize: 14,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  /// Estado de carga
  ///
  /// Muestra un indicador de progreso mientras se buscan las noticias.
  Widget _buildLoadingState() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(color: AppColors.primary, strokeWidth: 3),
          SizedBox(height: 16),
          Text(
            'Buscando...',
            style: TextStyle(color: AppColors.textGrey, fontSize: 16),
          ),
        ],
      ),
    );
  }

  /// Estado de error
  ///
  /// Muestra un mensaje cuando la búsqueda falla.
  /// [mensaje] - Mensaje de error descriptivo
  Widget _buildErrorState(String mensaje) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, color: AppColors.error, size: 64),
            const SizedBox(height: 16),
            const Text(
              'Error en la búsqueda',
              style: TextStyle(
                color: AppColors.textLight,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              mensaje,
              style: const TextStyle(color: AppColors.textGrey, fontSize: 14),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  /// Estado vacío
  ///
  /// Muestra un mensaje cuando la búsqueda no devuelve resultados.
  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.article_outlined,
            color: AppColors.textGrey.withOpacity(0.5),
            size: 64,
          ),
          const SizedBox(height: 16),
          const Text(
            'No se encontraron resultados',
            style: TextStyle(
              color: AppColors.textLight,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Intenta con otras palabras clave',
            style: TextStyle(
              color: AppColors.textGrey.withOpacity(0.8),
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  /// Realiza la búsqueda
  ///
  /// Actualiza el estado, llama al provider para buscar y quita el foco del teclado.
  /// [query] - Término de búsqueda ingresado por el usuario
  void _realizarBusqueda(String query) {
    setState(() {
      _hasSearched = true;
    });
    context.read<NoticiaProvider>().buscarNoticias(query);
    _searchFocusNode.unfocus();
  }
}
