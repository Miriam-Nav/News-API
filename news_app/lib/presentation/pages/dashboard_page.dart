import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/noticia_provider.dart';
import '../widgets/noticia_card.dart';
import '../widgets/category_selector.dart';
import '../../core/theme/app_colors.dart';
import 'search_page.dart';

/// Pantalla principal del dashboard de noticias
///
/// Diseño original NEWSPULSE:
/// - AppBar con logo "NEWSPULSE" y botones de búsqueda/refresh
/// - Selector de categorías horizontal
/// - Grid de noticias en 3 columnas
class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  String _categoriaSeleccionada = 'general';

  @override
  void initState() {
    super.initState();
    // Cargar noticias al iniciar la aplicación
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<NoticiaProvider>().cargarNoticiasRecientes();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: _buildAppBar(context),
      body: Column(
        children: [
          // Selector de categorías
          _buildCategorySection(),

          // Grid de noticias
          Expanded(child: _buildBody()),
        ],
      ),
    );
  }

  /// Construye el AppBar con el diseño NEWSPULSE
  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: AppColors.surface,
      elevation: 0,
      toolbarHeight: 70,
      title: const Text(
        'NEWSPULSE',
        style: TextStyle(
          color: AppColors.textLight,
          fontSize: 24,
          fontWeight: FontWeight.bold,
          letterSpacing: 2,
        ),
      ),
      actions: [
        // Botón de búsqueda
        Container(
          margin: const EdgeInsets.only(right: 8),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: AppColors.textGrey.withOpacity(0.3),
              width: 1,
            ),
          ),
          child: IconButton(
            icon: const Icon(Icons.search, color: AppColors.textLight),
            tooltip: 'Buscar',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SearchPage()),
              );
            },
          ),
        ),

        // Botón de refrescar
        Container(
          margin: const EdgeInsets.only(right: 16),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: AppColors.textGrey.withOpacity(0.3),
              width: 1,
            ),
          ),
          child: IconButton(
            icon: const Icon(Icons.refresh, color: AppColors.textLight),
            tooltip: 'Refrescar',
            onPressed: () {
              _refrescarNoticias();
            },
          ),
        ),
      ],
    );
  }

  /// Construye la sección de selector de categorías
  ///
  /// Muestra una lista horizontal scrollable con todas las categorías disponibles.
  /// Al seleccionar una categoría, se actualiza el estado y se cargan las noticias correspondientes.
  Widget _buildCategorySection() {
    return Container(
      color: AppColors.background,
      child: CategorySelector(
        categoriaSeleccionada: _categoriaSeleccionada,
        onCategoriaSeleccionada: (categoria) {
          setState(() {
            _categoriaSeleccionada = categoria;
          });
          _cambiarCategoria(categoria);
        },
      ),
    );
  }

  /// Construye el cuerpo principal con el grid de noticias
  ///
  /// Utiliza Consumer para escuchar cambios en el NoticiaProvider.
  /// Maneja los diferentes estados: cargando, error, vacío y con datos.
  /// Incluye RefreshIndicator para permitir "pull to refresh".
  Widget _buildBody() {
    return Consumer<NoticiaProvider>(
      builder: (context, provider, child) {
        // Estado de carga
        if (provider.estado == NoticiaEstado.cargando &&
            provider.noticias.isEmpty) {
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

        // Grid de noticias
        return RefreshIndicator(
          onRefresh: () async => _refrescarNoticias(),
          color: AppColors.primary,
          backgroundColor: AppColors.surface,
          child: GridView.builder(
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
          ),
        );
      },
    );
  }

  /// Estado de carga
  ///
  /// Muestra un indicador circular de progreso con un mensaje.
  Widget _buildLoadingState() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(color: AppColors.primary, strokeWidth: 3),
          SizedBox(height: 16),
          Text(
            'Cargando noticias...',
            style: TextStyle(color: AppColors.textGrey, fontSize: 16),
          ),
        ],
      ),
    );
  }

  /// Estado de error
  ///
  /// Muestra un mensaje de error con un botón para reintentar la carga.
  /// [mensaje] - Mensaje de error a mostrar al usuario
  Widget _buildErrorState(String mensaje) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, color: AppColors.error, size: 64),
            const SizedBox(height: 16),
            Text(
              'Error al cargar noticias',
              style: const TextStyle(
                color: AppColors.textLight,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              mensaje,
              style: const TextStyle(color: AppColors.textGrey, fontSize: 14),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () => _refrescarNoticias(),
              icon: const Icon(Icons.refresh),
              label: const Text('Reintentar'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: AppColors.background,
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Estado vacío
  ///
  /// Muestra un mensaje cuando no hay noticias disponibles.
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
            'No hay noticias disponibles',
            style: TextStyle(color: AppColors.textGrey, fontSize: 16),
          ),
        ],
      ),
    );
  }

  /// Refresca las noticias (limpia caché y recarga)
  ///
  /// Llama al método refrescar() del provider que limpia el caché
  /// y vuelve a cargar las noticias actuales.
  void _refrescarNoticias() {
    final provider = context.read<NoticiaProvider>();
    provider.refrescar();
  }

  /// Cambia la categoría y carga noticias
  ///
  /// Si la categoría es 'general', carga las noticias recientes.
  /// Para otras categorías, filtra las noticias por esa categoría específica.
  ///
  /// [categoria] - Categoría seleccionada por el usuario
  void _cambiarCategoria(String categoria) {
    final provider = context.read<NoticiaProvider>();
    if (categoria == 'general') {
      provider.cargarNoticiasRecientes();
    } else {
      provider.cargarNoticiasPorCategoria(categoria);
    }
  }
}
