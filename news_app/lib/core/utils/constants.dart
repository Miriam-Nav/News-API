import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

/// Constantes de la API de Currents
///
/// Esta clase centraliza todas las configuraciones relacionadas con
/// la API externa de noticias, incluyendo credenciales, endpoints y
/// parámetros de configuración.
class ApiConstants {
  ApiConstants._();

  // ========== API Configuration ==========
  /// URL base de la API de Currents
  static String get baseUrl =>
      dotenv.env['BASE_URL'] ?? 'https://api.currentsapi.services/v1';

  /// API Key para autenticación (se envía en el header Authorization)
  static String get apiKey => dotenv.env['API_KEY'] ?? '';

  /// Timeout para peticiones HTTP (en segundos)
  static const int timeout = 30;

  // ========== Endpoints ==========
  /// Endpoint para obtener noticias recientes
  static const String noticiasRecientes = "/latest-news";

  /// Endpoint para buscar noticias
  static const String buscarNoticias = "/search";

  /// Endpoint para obtener categorías disponibles
  static const String categoriasDisponibles = "/available/categories";

  // ========== Query Parameters ==========
  /// Idioma por defecto para las noticias
  static const String defaultLanguage = "en";

  /// Límite de noticias por petición
  static const int defaultLimit = 20;

  // ========== Categorías disponibles ==========
  /// Lista de categorías soportadas por la API de Currents
  ///
  /// Categorías disponibles:
  /// - general: Noticias generales (muestra como "Todo")
  /// - technology: Tecnología
  /// - business: Negocios
  /// - sports: Deportes
  /// - entertainment: Entretenimiento/Cultura
  /// - health: Salud
  /// - science: Ciencia
  /// - world: Política internacional
  static const List<String> categorias = [
    'general',
    'technology',
    'business',
    'sports',
    'entertainment',
    'health',
    'science',
    'world',
  ];

  /// Obtiene el nombre legible de una categoría
  static String getCategoryName(String category) {
    final names = {
      'general': 'Todo',
      'technology': 'Tecnología',
      'business': 'Negocios',
      'entertainment': 'Cultura',
      'sports': 'Deportes',
      'science': 'Ciencia',
      'health': 'Salud',
      'world': 'Política',
    };
    return names[category.toLowerCase()] ?? category;
  }

  /// Obtiene el icono de una categoría
  static IconData getCategoryIcon(String category) {
    final icons = {
      'general': Icons.grid_view_rounded,
      'technology': Icons.computer_rounded,
      'business': Icons.trending_up_rounded,
      'entertainment': Icons.theaters_rounded,
      'sports': Icons.sports_soccer_rounded,
      'science': Icons.science_rounded,
      'health': Icons.favorite_rounded,
      'world': Icons.account_balance_rounded,
    };
    return icons[category.toLowerCase()] ?? Icons.article_rounded;
  }
}

/// Utilidades de caché
///
/// Configuración para el sistema de almacenamiento temporal de noticias.
class CacheConstants {
  CacheConstants._();

  /// Duración del caché en minutos
  static const int cacheDuration = 15;

  /// Prefijo para las claves de caché de noticias
  static const String cachePrefix = 'news_cache_';

  /// Clave para timestamp del caché
  static const String cacheTimestampSuffix = '_timestamp';
}
