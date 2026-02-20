import 'package:flutter_test/flutter_test.dart';
import 'package:news_app/data/models/noticia_model.dart';

/// Tests simples para el modelo de Noticia
void main() {
  group('Modelo de Noticia', () {
    
    // Test 1: Crear una noticia desde JSON
    test('Debe crear una noticia desde JSON correctamente', () {
      // Datos de ejemplo en JSON
      final json = {
        'title': 'Noticia de prueba',
        'description': 'Esta es una descripción',
        'url': 'https://ejemplo.com',
        'author': 'Juan Pérez',
        'image': 'https://ejemplo.com/imagen.jpg',
        'category': ['general'],
        'published': '2024-01-01 10:00:00 +0000',
      };

      // Crear la noticia
      final noticia = NoticiaModel.fromJson(json);

      // Verificar que los datos sean correctos
      expect(noticia.title, 'Noticia de prueba');
      expect(noticia.description, 'Esta es una descripción');
      expect(noticia.author, 'Juan Pérez');
    });

    // Test 2: Verificar que el título no sea vacío
    test('El título de la noticia no debe estar vacío', () {
      final json = {
        'id': '456',
        'title': 'Título importante',
        'description': 'Descripción',
        'url': 'https://ejemplo.com',
        'author': 'María López',
        'image': 'https://ejemplo.com/img.jpg',
        'language': 'es',
        'category': ['technology'],
        'published': '2024-01-01 10:00:00 +0000',
      };

      final noticia = NoticiaModel.fromJson(json);

      expect(noticia.title, isNotEmpty);
      expect(noticia.title.length, greaterThan(0));
    });

    // Test 3: Verificar la categoría
    test('Debe tener una categoría válida', () {
      final json = {
        'id': '789',
        'title': 'Noticia tecnología',
        'description': 'Nueva app',
        'url': 'https://ejemplo.com',
        'author': 'Pedro García',
        'image': null,
        'language': 'es',
        'category': ['technology'],
        'published': '2024-01-01 10:00:00 +0000',
      };

      final noticia = NoticiaModel.fromJson(json);

      expect(noticia.category, 'technology');
    });

    // Test 4: Manejar imagen nula
    test('Debe manejar correctamente cuando no hay imagen', () {
      final json = {
        'title': 'Sin imagen',
        'description': 'Noticia sin foto',
        'url': 'https://ejemplo.com',
        'author': 'Ana Ruiz',
        'image': null,
        'category': ['general'],
        'published': '2024-01-01 10:00:00 +0000',
      };

      final noticia = NoticiaModel.fromJson(json);

      // El modelo siempre pone una imagen por defecto
      expect(noticia.imageUrl, isNotEmpty); 
    });
  });
}
