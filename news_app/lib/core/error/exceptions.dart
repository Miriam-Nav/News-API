// ========== Excepciones de Red ==========

/// Excepción base para errores de red
abstract class NetworkExceptionBase implements Exception {
  String get message;
  String get userFriendlyMessage;
}

/// Excepción lanzada cuando hay un error en el servidor (respuesta HTTP)
class ServerException implements NetworkExceptionBase {
  @override
  final String message;
  final int? statusCode;
  
  ServerException(this.message, {this.statusCode});
  
  @override
  String get userFriendlyMessage {
    switch (statusCode) {
      case 500:
        return 'Error interno del servidor. Intenta más tarde.';
      case 502:
        return 'Servidor no disponible. Intenta más tarde.';
      case 503:
        return 'Servicio temporalmente no disponible.';
      case 504:
        return 'El servidor tardó demasiado en responder.';
      default:
        return 'Error del servidor. Intenta más tarde.';
    }
  }
  
  @override
  String toString() => 'ServerException: $message (Status: ${statusCode ?? "unknown"})';
}

/// Excepción lanzada cuando hay problemas de conectividad de red
class NetworkException implements NetworkExceptionBase {
  @override
  final String message;
  
  NetworkException(this.message);
  
  @override
  String get userFriendlyMessage => 'Sin conexión a internet. Verifica tu conexión.';
  
  @override
  String toString() => 'NetworkException: $message';
}

/// Excepción lanzada cuando hay errores con la caché local
class CacheException implements NetworkExceptionBase {
  @override
  final String message;
  
  CacheException(this.message);
  
  @override
  String get userFriendlyMessage => 'Error al acceder al caché local.';
  
  @override
  String toString() => 'CacheException: $message';
}

/// Excepción específica para errores de cliente (4xx)
/// 
/// Incluye errores como:
/// - 400 Bad Request
/// - 401 Unauthorized
/// - 403 Forbidden
/// - 404 Not Found
/// - 429 Too Many Requests
class ClientException implements NetworkExceptionBase {
  @override
  final String message;
  final int statusCode;
  
  ClientException(this.message, this.statusCode);
  
  @override
  String get userFriendlyMessage {
    switch (statusCode) {
      case 400:
        return 'Petición inválida. Verifica los datos.';
      case 401:
        return 'API Key inválida o expirada.';
      case 403:
        return 'No tienes permisos para acceder a este recurso.';
      case 404:
        return 'Recurso no encontrado.';
      case 429:
        return 'Demasiadas peticiones. Espera un momento.';
      default:
        return 'Error en la petición: $message';
    }
  }
  
  @override
  String toString() => 'ClientException ($statusCode): $message';
}

/// Excepción para timeout de requests HTTP
class TimeoutException implements NetworkExceptionBase {
  @override
  final String message;
  
  TimeoutException([this.message = 'Request timeout']);
  
  @override
  String get userFriendlyMessage => 'La petición tardó demasiado. Intenta de nuevo.';
  
  @override
  String toString() => 'TimeoutException: $message';
}

/// Excepción para errores SSL/TLS (certificados)
class CertificateException implements NetworkExceptionBase {
  @override
  final String message;
  
  CertificateException(this.message);
  
  @override
  String get userFriendlyMessage => 'Error de seguridad en la conexión.';
  
  @override
  String toString() => 'CertificateException: $message';
}

// ========== Excepciones de Datos ==========

/// Excepción para errores al parsear JSON
class ParseException implements Exception {
  final String message;
  final dynamic originalError;
  
  ParseException(this.message, [this.originalError]);
  
  @override
  String toString() => 'ParseException: $message${originalError != null ? ' ($originalError)' : ''}';
}

/// Excepción para datos inválidos o incompletos
class ValidationException implements Exception {
  final String message;
  final List<String>? errors;
  
  ValidationException(this.message, [this.errors]);
  
  @override
  String toString() {
    if (errors != null && errors!.isNotEmpty) {
      return 'ValidationException: $message\nErrores: ${errors!.join(", ")}';
    }
    return 'ValidationException: $message';
  }
}

/// Excepción específica de la API (errores con estructura conocida)
class ApiException implements NetworkExceptionBase {
  @override
  final String message;
  final String? errorCode;
  final Map<String, dynamic>? details;
  
  ApiException(this.message, {this.errorCode, this.details});
  
  @override
  String get userFriendlyMessage => message;
  
  @override
  String toString() {
    String str = 'ApiException: $message';
    if (errorCode != null) str += ' [Code: $errorCode]';
    if (details != null) str += '\nDetails: $details';
    return str;
  }
}

/// Excepción para respuestas vacías inesperadas
class EmptyResponseException implements Exception {
  final String message;
  
  EmptyResponseException([this.message = 'La respuesta está vacía']);
  
  @override
  String toString() => 'EmptyResponseException: $message';
}

