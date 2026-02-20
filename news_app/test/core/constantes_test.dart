import 'package:flutter_test/flutter_test.dart';
import 'package:news_app/core/utils/constants.dart';

/// Tests simples para las constantes de la aplicación
void main() {
  group('Constantes de la API - Tests Básicos', () {
    
    // Test 1: Verificar que las categorías no estén vacías
    test('Debe tener categorías definidas', () {
      expect(ApiConstants.categorias, isNotEmpty);
      expect(ApiConstants.categorias.length, greaterThan(0));
    });

    // Test 2: Verificar iconos de categorías
    test('Cada categoría debe tener un icono asignado', () {
      for (final categoria in ApiConstants.categorias) {
        final icono = ApiConstants.getCategoryIcon(categoria);
        expect(icono, isNotNull);
      }
    });

    // Test 3: Verificar timeout
    test('El timeout debe ser mayor a 0', () {
      expect(ApiConstants.timeout, greaterThan(0));
    });

    // Test 4: Verificar límite de noticias
    test('El límite de noticias debe ser positivo', () {
      expect(ApiConstants.defaultLimit, greaterThan(0));
    });
  });

  group('Constantes de Caché - Tests Básicos', () {
    
    // Test 1: Verificar duración del caché
    test('La duración del caché debe ser mayor a 0', () {
      expect(CacheConstants.cacheDuration, greaterThan(0));
    });

    // Test 2: Verificar prefijo del caché
    test('El prefijo del caché no debe estar vacío', () {
      expect(CacheConstants.cachePrefix, isNotEmpty);
    });
  });
}
