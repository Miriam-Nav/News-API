import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dio/dio.dart';
import 'core/theme/app_theme.dart';
import 'data/repositories/noticia_repository.dart';
import 'presentation/providers/noticia_provider.dart';
import 'presentation/pages/dashboard_page.dart';

/// Punto de entrada de la aplicación
///
/// Configura:
/// - Variables de entorno (.env)
/// - Dependencias (SharedPreferences, Dio)
/// - Provider para gestión de estado
/// - Tema de la aplicación
void main() async {
  // Asegurar inicialización de Flutter
  WidgetsFlutterBinding.ensureInitialized();

  // Cargar variables de entorno
  try {
    await dotenv.load(fileName: ".env");
  } catch (e) {
    if (kDebugMode) {
      print('Error cargando .env: $e');
      print('Usando configuración por defecto');
    }
    // Para web, configurar las variables manualmente
    dotenv.env['API_KEY'] = 'p1lD3E1zDwH6GIei2HYZflDkjEdHyAd8ZvJu44SSbrQyaXSB';
    dotenv.env['BASE_URL'] = 'https://api.currentsapi.services/v1';
  }

  // Inicializar SharedPreferences
  final sharedPreferences = await SharedPreferences.getInstance();

  // Crear instancia de Dio
  final dio = Dio();

  // Crear repositorio
  final repository = NoticiaRepository(dio: dio, prefs: sharedPreferences);

  // Ejecutar aplicación
  runApp(NewsApp(repository: repository));
}

/// Widget raíz de la aplicación
class NewsApp extends StatelessWidget {
  final NoticiaRepository repository;

  const NewsApp({super.key, required this.repository});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => NoticiaProvider(repository: repository),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'News App - Currents API',
        theme: AppTheme.darkTheme,
        themeMode: ThemeMode.dark,
        home: const DashboardPage(),
      ),
    );
  }
}
