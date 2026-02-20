import 'dart:async';
import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../core/utils/constants.dart';
import '../../core/error/exceptions.dart';
import '../models/noticia_model.dart';

/// Repositorio de noticias
///
/// Esta clase es responsable de obtener noticias desde la API de Currents
/// y gestionar el almacenamiento en caché para optimizar el rendimiento.
///
/// Características:
/// - Uso de Dio para peticiones HTTP con interceptores
/// - Headers correctos con API Key en Authorization
/// - Sistema de caché automático (15 minutos)
/// - Gestión robusta de errores (4xx, 5xx, timeout, sin conexión)
/// - Operaciones asíncronas que no bloquean la UI
class NoticiaRepository {
  final Dio _dio;
  final SharedPreferences _prefs;

  /// Constructor que configura Dio con opciones predeterminadas
  NoticiaRepository({Dio? dio, required SharedPreferences prefs})
    : _dio = dio ?? Dio(),
      _prefs = prefs {
    _configurarDio();
  }

  /// Configura Dio con headers, timeouts e interceptores
  void _configurarDio() {
    _dio.options = BaseOptions(
      baseUrl: ApiConstants.baseUrl,
      connectTimeout: Duration(seconds: ApiConstants.timeout),
      receiveTimeout: Duration(seconds: ApiConstants.timeout),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        // API Key enviada en el header de Authorization
        'Authorization': ApiConstants.apiKey,
      },
    );

    // Interceptor para logging (útil para debugging)
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          print('REQUEST[${options.method}] => ${options.uri}');
          return handler.next(options);
        },
        onResponse: (response, handler) {
          print(
            'RESPONSE[${response.statusCode}] <= ${response.requestOptions.uri}',
          );
          return handler.next(response);
        },
        onError: (DioException e, handler) {
          print(
            'ERROR[${e.response?.statusCode}] => ${e.requestOptions.uri}',
          );
          return handler.next(e);
        },
      ),
    );
  }

  /// Obtiene las noticias más recientes
  ///
  /// Primero intenta obtener datos del caché. Si no existen o han expirado,
  /// realiza una petición a la API y guarda el resultado en caché.
  ///
  /// Returns: Lista de [NoticiaModel] con las últimas noticias
  ///
  /// Throws:
  /// - [ServerException] si hay error en el servidor (5xx)
  /// - [ClientException] si hay error del cliente (4xx)
  /// - [NetworkException] si no hay conexión a internet
  /// - [TimeoutException] si la petición excede el tiempo límite
  Future<List<NoticiaModel>> obtenerNoticiasRecientes() async {
    const cacheKey = 'latest_news';

    // Intentar obtener del caché primero
    final cachedData = await _obtenerDeCache(cacheKey);
    if (cachedData != null) {
      print('Noticias recientes obtenidas del caché');
      return cachedData;
    }

    // Si no hay caché, hacer petición a la API
    // DIO: https://api.currentsapi.services/v1/latest-news?language=en
    try {
      final response = await _dio.get(
        ApiConstants.noticiasRecientes,
        queryParameters: {'language': ApiConstants.defaultLanguage},
      );

      final noticias = _procesarRespuesta(response);
      await _guardarEnCache(cacheKey, noticias);

      return noticias;
    } on DioException catch (e) {
      throw _manejarErrorDio(e);
    } on ParseException catch (e) {
      // Re-lanzar excepciones de parsing
      rethrow;
    } on ValidationException catch (e) {
      // Re-lanzar excepciones de validación
      rethrow;
    } on EmptyResponseException catch (e) {
      // Re-lanzar excepciones de respuesta vacía
      rethrow;
    } catch (e) {
      // Cualquier otro error inesperado
      throw NetworkException('Error inesperado al procesar noticias: $e');
    }
  }

  /// Busca noticias por palabra clave
  ///
  /// Implementa búsqueda con caché basado en el término de búsqueda.
  ///
  /// [query] - Término de búsqueda
  ///
  /// Returns: Lista de [NoticiaModel] que coinciden con la búsqueda
  ///
  /// Throws: Las mismas excepciones que [obtenerNoticiasRecientes]
  Future<List<NoticiaModel>> buscarNoticias(String query) async {
    if (query.trim().isEmpty) {
      return obtenerNoticiasRecientes();
    }

    final cacheKey = 'search_${query.toLowerCase()}';

    // Intentar obtener del caché
    final cachedData = await _obtenerDeCache(cacheKey);
    if (cachedData != null) {
      print('Búsqueda "$query" obtenida del caché');
      return cachedData;
    }

    try {
      final response = await _dio.get(
        ApiConstants.buscarNoticias,
        queryParameters: {
          'keywords': query,
          'language': ApiConstants.defaultLanguage,
        },
      );

      final noticias = _procesarRespuesta(response);
      await _guardarEnCache(cacheKey, noticias);

      return noticias;
    } on DioException catch (e) {
      throw _manejarErrorDio(e);
    } on ParseException catch (e) {
      rethrow;
    } on ValidationException catch (e) {
      rethrow;
    } on EmptyResponseException catch (e) {
      rethrow;
    } catch (e) {
      throw NetworkException('Error inesperado al buscar noticias: $e');
    }
  }

  /// Obtiene noticias filtradas por categoría
  ///
  /// [category] - Categoría de noticias (technology, sports, etc.)
  ///
  /// Returns: Lista de [NoticiaModel] de la categoría especificada
  ///
  /// Throws: Las mismas excepciones que [obtenerNoticiasRecientes]
  Future<List<NoticiaModel>> obtenerNoticiasPorCategoria(
    String category,
  ) async {
    final cacheKey = 'category_${category.toLowerCase()}';

    // Intentar obtener del caché
    final cachedData = await _obtenerDeCache(cacheKey);
    if (cachedData != null) {
      print('Categoría "$category" obtenida del caché');
      return cachedData;
    }

    try {
      final response = await _dio.get(
        ApiConstants.noticiasRecientes,
        queryParameters: {
          'category': category,
          'language': ApiConstants.defaultLanguage,
        },
      );

      final noticias = _procesarRespuesta(response);
      await _guardarEnCache(cacheKey, noticias);

      return noticias;
    } on DioException catch (e) {
      throw _manejarErrorDio(e);
    } on ParseException catch (e) {
      rethrow;
    } on ValidationException catch (e) {
      rethrow;
    } on EmptyResponseException catch (e) {
      rethrow;
    } catch (e) {
      throw NetworkException('Error inesperado al obtener categoría: $e');
    }
  }

  /// Procesa la respuesta de la API y convierte a lista de NoticiaModel
  ///
  /// [response] - Respuesta de Dio
  ///
  /// Returns: Lista de [NoticiaModel] parseadas desde JSON
  ///
  /// Throws:
  /// - [ParseException] si el JSON es inválido
  /// - [ValidationException] si los datos son incorrectos
  /// - [EmptyResponseException] si no hay datos
  List<NoticiaModel> _procesarRespuesta(Response response) {
    // Validar que la respuesta no sea nula
    if (response.data == null) {
      throw EmptyResponseException('La respuesta del servidor está vacía');
    }

    // Validar que sea un Map
    if (response.data is! Map<String, dynamic>) {
      throw ParseException(
        'Formato de respuesta inválido. Se esperaba Map<String, dynamic>',
        response.data.runtimeType,
      );
    }

    final data = response.data as Map<String, dynamic>;

    // Validar estructura de respuesta de la API
    if (!data.containsKey('news')) {
      throw ParseException(
        'Respuesta sin campo "news"',
        data.keys.toList(),
      );
    }

    final newsArray = data['news'];

    // Validar que news sea una lista
    if (newsArray is! List) {
      throw ParseException(
        'El campo "news" no es una lista',
        newsArray.runtimeType,
      );
    }

    if (newsArray.isEmpty) {
      return []; // Lista vacía es válida (sin resultados)
    }

    // Parsear cada noticia con manejo de errores individual
    final List<NoticiaModel> noticias = [];
    final List<String> erroresParseo = [];

    for (int i = 0; i < newsArray.length; i++) {
      try {
        final item = newsArray[i];
        
        if (item is! Map<String, dynamic>) {
          erroresParseo.add('Item $i no es un objeto válido');
          continue;
        }

        final noticia = NoticiaModel.fromJson(item);
        noticias.add(noticia);
      } catch (e) {
        erroresParseo.add('Error en item $i: $e');
        print('Error parseando noticia $i: $e');
        // Continuar con las demás noticias
      }
    }

    // Si no se pudo parsear ninguna noticia, lanzar error
    if (noticias.isEmpty && newsArray.isNotEmpty) {
      throw ParseException(
        'No se pudo parsear ninguna noticia',
        erroresParseo,
      );
    }

    // Nota: Retornamos las noticias válidas aunque algunas fallaran
    if (erroresParseo.isNotEmpty) {
      print('Algunas noticias no se pudieron parsear: ${erroresParseo.length}/${newsArray.length}');
    }

    return noticias;
  }

  /// Obtiene noticias del caché si existen y no han expirado
  ///
  /// [key] - Clave de caché
  ///
  /// Returns: Lista de noticias o null si no existe/expiró
  Future<List<NoticiaModel>?> _obtenerDeCache(String key) async {
    final cacheKey = '${CacheConstants.cachePrefix}$key';
    final timestampKey = '$cacheKey${CacheConstants.cacheTimestampSuffix}';

    // Verificar si existe la caché y el timestamp
    if (!_prefs.containsKey(cacheKey) || !_prefs.containsKey(timestampKey)) {
      return null;
    }

    // Verificar si ha expirado
    final timestamp = _prefs.getInt(timestampKey);
    if (timestamp == null) return null;

    final cacheTime = DateTime.fromMillisecondsSinceEpoch(timestamp);
    final now = DateTime.now();

    if (now.difference(cacheTime).inMinutes > CacheConstants.cacheDuration) {
      // Caché expirada, eliminar
      await _prefs.remove(cacheKey);
      await _prefs.remove(timestampKey);
      return null;
    }

    // Recuperar y deserializar datos
    final jsonString = _prefs.getString(cacheKey);
    if (jsonString == null) return null;

    try {
      final List<dynamic> decoded = json.decode(jsonString);
      return decoded
          .map((item) => NoticiaModel.fromJson(item as Map<String, dynamic>))
          .toList();
    } catch (e) {
      // Error al deserializar, eliminar caché corrupta
      await _prefs.remove(cacheKey);
      await _prefs.remove(timestampKey);
      return null;
    }
  }

  /// Guarda noticias en el caché con timestamp
  ///
  /// [key] - Clave de caché
  /// [noticias] - Lista de noticias a guardar
  Future<void> _guardarEnCache(String key, List<NoticiaModel> noticias) async {
    final cacheKey = '${CacheConstants.cachePrefix}$key';
    final timestampKey = '$cacheKey${CacheConstants.cacheTimestampSuffix}';

    // Convertir noticias a JSON
    final jsonList = noticias.map((n) => n.toJson()).toList();

    // Guardar en SharedPreferences
    await _prefs.setString(cacheKey, json.encode(jsonList));
    await _prefs.setInt(timestampKey, DateTime.now().millisecondsSinceEpoch);

    print('Guardado en caché: $key (${noticias.length} noticias)');
  }

  /// Maneja errores de Dio y los convierte en excepciones personalizadas
  ///
  /// [error] - Error capturado de Dio
  ///
  /// Returns: Excepción personalizada según el tipo de error
  Exception _manejarErrorDio(DioException error) {
    // Log detallado del error para debugging
    print('DioException capturado:');
    print('  Tipo: ${error.type}');
    print('  Mensaje: ${error.message}');
    print('  Status: ${error.response?.statusCode}');
    print('  URL: ${error.requestOptions.uri}');

    switch (error.type) {
      // ========== Timeouts ==========
      case DioExceptionType.connectionTimeout:
        return TimeoutException(
          'No se pudo conectar al servidor en ${ApiConstants.timeout}s',
        );

      case DioExceptionType.sendTimeout:
        return TimeoutException(
          'El envío de datos excedió el límite de ${ApiConstants.timeout}s',
        );

      case DioExceptionType.receiveTimeout:
        return TimeoutException(
          'La recepción de datos excedió el límite de ${ApiConstants.timeout}s',
        );

      // ========== Errores de Conexión ==========
      case DioExceptionType.connectionError:
        // Verificar si es un error de DNS
        if (error.message?.contains('Failed host lookup') ?? false) {
          return NetworkException(
            'No se pudo resolver el nombre del servidor. Verifica tu conexión.',
          );
        }
        // Error de socket
        if (error.message?.contains('SocketException') ?? false) {
          return NetworkException(
            'No se pudo establecer conexión. Verifica tu red.',
          );
        }
        return NetworkException(
          'Error de conexión. Verifica tu conexión a internet.',
        );

      // ========== Errores de Certificado SSL/TLS ==========
      case DioExceptionType.badCertificate:
        return CertificateException(
          'Certificado SSL inválido o no confiable. El servidor puede no ser seguro.',
        );

      // ========== Respuestas HTTP (4xx, 5xx) ==========
      case DioExceptionType.badResponse:
        return _manejarBadResponse(error);

      // ========== Petición Cancelada ==========
      case DioExceptionType.cancel:
        return NetworkException(
          'La petición fue cancelada por el usuario o sistema.',
        );

      // ========== Errores Desconocidos ==========
      case DioExceptionType.unknown:
        // Intentar identificar el error
        if (error.error != null) {
          final errorMessage = error.error.toString();
          
          // Error de formato JSON
          if (errorMessage.contains('FormatException') || 
              errorMessage.contains('JSON')) {
            return ParseException(
              'Respuesta con formato JSON inválido',
              error.error,
            );
          }
          
          // Error de tipo
          if (errorMessage.contains('type') && errorMessage.contains('is not')) {
            return ParseException(
              'Tipo de dato inesperado en la respuesta',
              error.error,
            );
          }
          
          // Error de red subyacente
          if (errorMessage.contains('SocketException') ||
              errorMessage.contains('HandshakeException')) {
            return NetworkException(
              'Error de red: ${error.message ?? errorMessage}',
            );
          }
        }
        
        return NetworkException(
          'Error desconocido: ${error.message ?? error.error?.toString() ?? "Sin detalles"}',
        );

      // ========== Otros ==========
      default:
        return NetworkException(
          'Error inesperado: ${error.message ?? "Sin descripción"}',
        );
    }
  }

  /// Maneja respuestas HTTP con código de error (4xx, 5xx)
  ///
  /// [error] - Error de Dio con respuesta HTTP
  ///
  /// Returns: Excepción apropiada según el código de estado
  Exception _manejarBadResponse(DioException error) {
    final statusCode = error.response?.statusCode ?? 0;
    final responseData = error.response?.data;

    // Intentar extraer mensaje de error de la respuesta
    String errorMessage = 'Error desconocido';
    
    if (responseData != null) {
      if (responseData is Map<String, dynamic>) {
        // Buscar mensaje en diferentes campos comunes
        errorMessage = responseData['message'] ??
                      responseData['error'] ??
                      responseData['detail'] ??
                      responseData['msg'] ??
                      error.message ??
                      'Error desconocido';
      } else if (responseData is String) {
        errorMessage = responseData;
      }
    } else {
      errorMessage = error.message ?? 'Error sin detalles';
    }

    // ========== Errores del Servidor (5xx) ==========
    if (statusCode >= 500) {
      switch (statusCode) {
        case 500:
          return ServerException(
            'Error interno del servidor: $errorMessage',
            statusCode: 500,
          );
        case 502:
          return ServerException(
            'Bad Gateway: El servidor recibió una respuesta inválida',
            statusCode: 502,
          );
        case 503:
          return ServerException(
            'Servicio no disponible: $errorMessage',
            statusCode: 503,
          );
        case 504:
          return ServerException(
            'Gateway Timeout: El servidor no respondió a tiempo',
            statusCode: 504,
          );
        default:
          return ServerException(
            'Error del servidor ($statusCode): $errorMessage',
            statusCode: statusCode,
          );
      }
    }

    // ========== Errores del Cliente (4xx) ==========
    if (statusCode >= 400) {
      switch (statusCode) {
        case 400:
          return ClientException(
            'Petición inválida: $errorMessage',
            400,
          );
        case 401:
          return ClientException(
            'No autorizado: API Key inválida o expirada',
            401,
          );
        case 403:
          return ClientException(
            'Prohibido: No tienes permisos para este recurso',
            403,
          );
        case 404:
          return ClientException(
            'Recurso no encontrado: $errorMessage',
            404,
          );
        case 405:
          return ClientException(
            'Método HTTP no permitido',
            405,
          );
        case 408:
          return TimeoutException(
            'Timeout del cliente: La petición tardó demasiado',
          );
        case 429:
          return ClientException(
            'Demasiadas peticiones: Has excedido el límite de rate',
            429,
          );
        default:
          return ClientException(
            'Error del cliente ($statusCode): $errorMessage',
            statusCode,
          );
      }
    }

    // ========== Otros Códigos ==========
    return ServerException(
      'Error HTTP ($statusCode): $errorMessage',
      statusCode: statusCode,
    );
  }

  /// Limpia todo el caché de noticias
  ///
  /// Útil para forzar actualización de datos
  Future<void> limpiarCache() async {
    final keys = _prefs.getKeys();

    for (final key in keys) {
      if (key.startsWith(CacheConstants.cachePrefix)) {
        await _prefs.remove(key);
      }
    }

    print('Caché limpiada completamente');
  }
}
