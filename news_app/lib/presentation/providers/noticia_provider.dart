import 'package:flutter/foundation.dart';
import '../../data/models/noticia_model.dart';
import '../../data/repositories/noticia_repository.dart';
import '../../core/error/exceptions.dart';

/// Estado de carga de las noticias
enum NoticiaEstado {
  /// Estado inicial, sin cargar datos
  inicial,

  /// Cargando datos de la API
  cargando,

  /// Datos cargados exitosamente
  exitoso,

  /// Error al cargar datos
  error,
}

/// Provider para gestionar el estado de las noticias
///
/// Esta clase usa ChangeNotifier para notificar cambios a los widgets
/// que estén escuchando. Gestiona:
/// - Carga de noticias recientes
/// - Búsqueda de noticias
/// - Filtrado por categoría
/// - Estado de carga y errores
/// - Caché automático a través del repositorio
///
/// Todas las operaciones son asíncronas y no bloquean la interfaz.
class NoticiaProvider extends ChangeNotifier {
  final NoticiaRepository _repository;

  NoticiaProvider({required NoticiaRepository repository})
    : _repository = repository;

  // ========== Estado ==========

  /// Estado actual de la carga
  NoticiaEstado _estado = NoticiaEstado.inicial;
  NoticiaEstado get estado => _estado;

  /// Lista de noticias actuales
  List<NoticiaModel> _noticias = [];
  List<NoticiaModel> get noticias => _noticias;

  /// Mensaje de error si existe
  String _mensajeError = '';
  String get mensajeError => _mensajeError;

  /// Categoría seleccionada actualmente
  String _categoriaSeleccionada = 'general';
  String get categoriaSeleccionada => _categoriaSeleccionada;

  /// Término de búsqueda actual
  String _terminoBusqueda = '';
  String get terminoBusqueda => _terminoBusqueda;

  // ========== Getters de estado ==========

  /// Indica si el provider está actualmente cargando datos
  bool get estaCargando => _estado == NoticiaEstado.cargando;
  
  /// Indica si ocurrió un error durante la última operación
  bool get tieneError => _estado == NoticiaEstado.error;
  
  /// Indica si los datos se cargaron exitosamente
  bool get estaCargado => _estado == NoticiaEstado.exitoso;
  
  /// Indica si hay noticias disponibles en la lista
  bool get tieneNoticias => _noticias.isNotEmpty;

  // ========== Métodos públicos ==========

  /// Carga las noticias más recientes
  ///
  /// Muestra las últimas noticias disponibles en el idioma configurado.
  /// Usa caché automáticamente para mejorar el rendimiento.
  Future<void> cargarNoticiasRecientes() async {
    _setEstado(NoticiaEstado.cargando);
    _categoriaSeleccionada = 'general';
    _terminoBusqueda = '';

    try {
      _noticias = await _repository.obtenerNoticiasRecientes();
      _setEstado(NoticiaEstado.exitoso);
      _mensajeError = '';
    } catch (e) {
      _manejarError(e);
    }
  }

  /// Busca noticias por palabra clave
  ///
  /// [query] - Término de búsqueda
  ///
  /// Si el término está vacío, carga las noticias recientes.
  Future<void> buscarNoticias(String query) async {
    if (query.trim().isEmpty) {
      await cargarNoticiasRecientes();
      return;
    }

    _setEstado(NoticiaEstado.cargando);
    _terminoBusqueda = query;
    _categoriaSeleccionada = '';

    try {
      _noticias = await _repository.buscarNoticias(query);
      _setEstado(NoticiaEstado.exitoso);
      _mensajeError = '';
    } catch (e) {
      _manejarError(e);
    }
  }

  /// Filtra noticias por categoría
  ///
  /// [category] - Categoría a filtrar (technology, sports, etc.)
  Future<void> filtrarPorCategoria(String category) async {
    _setEstado(NoticiaEstado.cargando);
    _categoriaSeleccionada = category;
    _terminoBusqueda = '';

    try {
      _noticias = await _repository.obtenerNoticiasPorCategoria(category);
      _setEstado(NoticiaEstado.exitoso);
      _mensajeError = '';
    } catch (e) {
      _manejarError(e);
    }
  }

  /// Alias para cargarNoticiasPorCategoria
  Future<void> cargarNoticiasPorCategoria(String category) async {
    await filtrarPorCategoria(category);
  }

  /// Refresca las noticias actuales
  ///
  /// Limpia el caché y vuelve a cargar los datos desde la API.
  Future<void> refrescar() async {
    await _repository.limpiarCache();

    if (_terminoBusqueda.isNotEmpty) {
      await buscarNoticias(_terminoBusqueda);
    } else if (_categoriaSeleccionada.isNotEmpty &&
        _categoriaSeleccionada != 'general') {
      await filtrarPorCategoria(_categoriaSeleccionada);
    } else {
      await cargarNoticiasRecientes();
    }
  }

  /// Limpia el estado y vuelve al inicial
  void limpiar() {
    _estado = NoticiaEstado.inicial;
    _noticias = [];
    _mensajeError = '';
    _categoriaSeleccionada = 'general';
    _terminoBusqueda = '';
    notifyListeners();
  }

  // ========== Métodos privados ==========

  /// Establece el estado y notifica a los listeners
  ///
  /// [nuevoEstado] - Nuevo estado a establecer
  void _setEstado(NoticiaEstado nuevoEstado) {
    _estado = nuevoEstado;
    notifyListeners();
  }

  /// Maneja errores de forma centralizada
  ///
  /// Convierte excepciones en mensajes amigables para el usuario.
  ///
  /// [error] - Error capturado
  void _manejarError(Object error) {
    print('Error en NoticiaProvider: $error');

    // Priorizar mensajes específicos de excepciones personalizadas
    if (error is NetworkExceptionBase) {
      _mensajeError = error.userFriendlyMessage;
    }
    // Casos específicos adicionales
    else if (error is ParseException) {
      _mensajeError = 'Error al procesar los datos. La respuesta del servidor es inválida.';
    } else if (error is ValidationException) {
      _mensajeError = 'Los datos recibidos no son válidos. Intenta de nuevo.';
    } else if (error is EmptyResponseException) {
      _mensajeError = 'No se encontraron resultados para tu búsqueda.';
    } else if (error is CertificateException) {
      _mensajeError = 'Conexión no segura. Verifica la configuración del servidor.';
    } else if (error is NetworkException) {
      _mensajeError = 'Sin conexión a internet. Verifica tu conexión.';
    } else if (error is ServerException) {
      // Mensajes más específicos para errores de servidor
      if (error.statusCode == 503) {
        _mensajeError = 'El servicio no está disponible temporalmente.';
      } else if (error.statusCode == 502 || error.statusCode == 504) {
        _mensajeError = 'Error de comunicación con el servidor. Intenta más tarde.';
      } else {
        _mensajeError = 'Error del servidor. Intenta más tarde.';
      }
    } else if (error is ClientException) {
      if (error.statusCode == 401 || error.statusCode == 403) {
        _mensajeError = 'API Key inválida o sin permisos.';
      } else if (error.statusCode == 429) {
        _mensajeError = 'Demasiadas peticiones. Espera un momento.';
      } else if (error.statusCode == 404) {
        _mensajeError = 'El recurso solicitado no existe.';
      } else {
        _mensajeError = 'Error: ${error.message}';
      }
    } else if (error is TimeoutException) {
      _mensajeError = 'La petición tardó demasiado. Intenta de nuevo.';
    } else {
      _mensajeError = 'Error inesperado: ${error.toString()}';
    }

    _estado = NoticiaEstado.error;
    notifyListeners();
  }

  @override
  void dispose() {
    // Limpiar recursos si es necesario
    super.dispose();
  }
}
