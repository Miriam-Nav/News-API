/// Modelo de noticia
///
/// Esta clase representa una noticia completa con todos sus campos.
/// Incluye métodos para convertir desde/hacia JSON para comunicación
/// con la API y almacenamiento en caché.
class NoticiaModel {
  /// Título de la noticia
  final String title;
  
  /// Categoría (technology, sports, business, etc.)
  final String category;
  
  /// Descripción o resumen de la noticia
  final String description;
  
  /// URL de la noticia completa
  final String url;
  
  /// URL de la imagen de portada
  final String imageUrl;
  
  /// Autor de la noticia
  final String author;
  
  /// Fecha de publicación (formato: YYYY-MM-DD HH:MM:SS)
  final String published;
  
  /// Fuente de la noticia (BBC, CNN, etc.)
  final String source;

  const NoticiaModel({
    required this.title,
    required this.category,
    required this.description,
    required this.url,
    required this.imageUrl,
    this.author = '',
    this.published = '',
    this.source = '',
  });

  /// Crea una instancia de [NoticiaModel] desde un JSON de la API
  ///
  /// Este método maneja de forma segura valores nulos y diferentes
  /// formatos que puede devolver la API de Currents.
  ///
  /// [json] - Mapa JSON con los datos de la noticia
  /// 
  /// Returns: Nueva instancia de [NoticiaModel] con valores seguros
  factory NoticiaModel.fromJson(Map<String, dynamic> json) {
    // Extraer categorías (puede ser lista o string)
    String categoryValue = 'general';
    try {
      if (json['category'] is List && (json['category'] as List).isNotEmpty) {
        final firstCategory = (json['category'] as List).first;
        categoryValue = firstCategory?.toString() ?? 'general';
      } else if (json['category'] is String) {
        categoryValue = json['category'] as String;
      }
    } catch (e) {
      categoryValue = 'general';
    }

    // Función helper para extraer strings de forma segura
    String safeString(dynamic value, [String defaultValue = '']) {
      if (value == null) return defaultValue;
      return value.toString();
    }

    return NoticiaModel(
      title: safeString(json['title'], 'Sin título'),
      category: categoryValue,
      description: safeString(json['description'], 'Sin descripción disponible'),
      url: safeString(json['url']),
      imageUrl: safeString(json['image'], 'https://via.placeholder.com/400x300?text=Sin+Imagen'),
      author: safeString(json['author']),
      published: safeString(json['published']),
      source: _extractSource(json),
    );
  }

  /// Extrae la fuente de la noticia del JSON
  ///
  /// Intenta obtener el nombre de la fuente desde diferentes campos
  /// del JSON de respuesta.
  static String _extractSource(Map<String, dynamic> json) {
    if (json['author'] != null && json['author'].toString().isNotEmpty) {
      return json['author'].toString();
    }
    if (json['language'] != null) {
      return json['language'].toString().toUpperCase();
    }
    return 'News';
  }

  /// Convierte el modelo a un Map JSON para almacenamiento
  ///
  /// Este método es compatible con [fromJson], permitiendo serialización
  /// y deserialización consistente para el sistema de caché.
  ///
  /// Returns: Map con toda la información de la noticia
  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'category': [category],
      'description': description,
      'url': url,
      'image': imageUrl,
      'author': author,
      'published': published,
      'language': source.toLowerCase(),
    };
  }

  /// Crea una copia de esta noticia con algunos campos modificados
  ///
  /// Útil para actualizar inmutablemente instancias de la noticia.
  NoticiaModel copyWith({
    String? title,
    String? category,
    String? description,
    String? url,
    String? imageUrl,
    String? author,
    String? published,
    String? source,
  }) {
    return NoticiaModel(
      title: title ?? this.title,
      category: category ?? this.category,
      description: description ?? this.description,
      url: url ?? this.url,
      imageUrl: imageUrl ?? this.imageUrl,
      author: author ?? this.author,
      published: published ?? this.published,
      source: source ?? this.source,
    );
  }

  @override
  String toString() {
    return 'NoticiaModel(title: $title, category: $category, source: $source)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
  
    return other is NoticiaModel &&
      other.title == title &&
      other.url == url;
  }

  @override
  int get hashCode => title.hashCode ^ url.hashCode;
}
