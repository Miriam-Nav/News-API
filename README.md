# Documentación del Código - News App

## 📁 Estructura del Proyecto

Este proyecto sigue una arquitectura limpia separada en capas:

```
lib/
├── main.dart                 # Punto de entrada de la aplicación
├── core/                     # Funcionalidades compartidas
│   ├── error/               # Manejo de excepciones personalizadas
│   ├── theme/               # Tema, colores, estilos y dimensiones
│   └── utils/               # Utilidades y constantes
├── data/                     # Capa de datos
│   ├── models/              # Modelos de datos (NoticiaModel)
│   └── repositories/        # Repositorios que interactúan con APIs
└── presentation/             # Capa de presentación (UI)
    ├── pages/               # Páginas/Pantallas de la app
    ├── providers/           # Gestión de estado con Provider
    └── widgets/             # Widgets reutilizables
```

## 🎨 Arquitectura

### **Core** - Funcionalidades Compartidas

#### `core/error/`
- **exceptions.dart**: Define excepciones personalizadas
  - `ServerException`: Errores del servidor (5xx)
  - `ClientException`: Errores del cliente (4xx)
  - `NetworkException`: Problemas de conectividad
  - `TimeoutException`: Tiempo de espera excedido
  - `CacheException`: Errores de caché local

#### `core/theme/`
- **app_colors.dart**: Paleta de colores
  - Estética cybersecurity/terminal con colores oscuros
  - Acento cian neón (`#00D4FF`) para elementos primarios
  - Colores por categoría de noticia
  
- **app_text_styles.dart**: Estilos de texto
  - Headlines (Montserrat - negrita)
  - Body (Inter - normal)
  - Labels y títulos con tamaños estandarizados
  
- **app_dimensions.dart**: Dimensiones y espaciados
  - Border radius, padding, margins
  - Tamaños de iconos, botones y tarjetas
  - Duraciones de animaciones
  
- **app_theme.dart**: Configuración del tema
  - Combina colores, estilos y dimensiones
  - Define ThemeData para Material 3

#### `core/utils/`
- **constants.dart**: Constantes de configuración
  - `ApiConstants`: URLs, endpoints, API keys, categorías
  - `CacheConstants`: Configuración de caché (15 min TTL)
  
- **category_colors.dart**: Utilidades de colores para categorías

### **Data** - Capa de Datos

#### `data/models/`
- **noticia_model.dart**: Modelo de noticia
  - Propiedades: title, category, description, url, imageUrl, author, published, source
  - `fromJson()`: Deserialización desde API
  - `toJson()`: Serialización para caché
  - `copyWith()`: Copia inmutable
  - Manejo seguro de valores nulos

#### `data/repositories/`
- **noticia_repository.dart**: Gestiona peticiones HTTP y caché
  - Usa `Dio` para peticiones HTTP con interceptores
  - Sistema de caché automático (SharedPreferences)
  - Métodos públicos:
    - `obtenerNoticiasRecientes()`: Últimas noticias
    - `buscarNoticias(query)`: Búsqueda por palabra clave
    - `obtenerNoticiasPorCategoria(category)`: Filtrar por categoría
    - `limpiarCache()`: Eliminar caché
  - Manejo robusto de errores con excepciones personalizadas

### **Presentation** - Capa de Presentación

#### `presentation/providers/`
- **noticia_provider.dart**: Gestión de estado con ChangeNotifier
  - Estados: inicial, cargando, exitoso, error
  - Propiedades: noticias, mensajeError, categoriaSeleccionada
  - Métodos:
    - `cargarNoticiasRecientes()`
    - `buscarNoticias(query)`
    - `filtrarPorCategoria(category)`
    - `refrescar()`: Limpia caché y recarga
  - Convierte excepciones en mensajes amigables

#### `presentation/pages/`
- **dashboard_page.dart**: Pantalla principal
  - AppBar con logo "NEWSPULSE"
  - Selector de categorías horizontal
  - Grid de noticias (3 columnas)
  - Estados: cargando, error, vacío
  - Pull-to-refresh
  
- **search_page.dart**: Búsqueda de noticias
  - Campo de búsqueda en AppBar
  - Grid de resultados
  - Estados: inicial, cargando, error, sin resultados
  
- **detail_page.dart**: Detalles de noticia
  - Imagen de fondo con blur
  - Badge de categoría
  - Título, autor, fecha
  - Botón para abrir artículo completo (url_launcher)

#### `presentation/widgets/`
- **noticia_card.dart**: Tarjeta de noticia
  - Imagen con placeholder y error handling
  - Barra cyan superior
  - Título truncado (3 líneas max)
  - Navegación a DetailPage al hacer clic
  
- **category_selector.dart**: Selector de categorías
  - Lista horizontal scrollable
  - Chips con iconos y texto
  - Estilo diferente para categoría seleccionada

## 🔄 Flujo de Datos

```
UI (Widget) 
    ↓ llama método
Provider (NoticiaProvider)
    ↓ solicita datos
Repository (NoticiaRepository)
    ↓ verifica caché
    ├─→ Caché existe y es válido → devuelve datos
    └─→ Caché no existe o expiró
        ↓ petición HTTP
        API (Currents)
        ↓ respuesta JSON
        ↓ mapeo a modelo
        ↓ guarda en caché
        ↓ devuelve datos
Provider notifica cambios
    ↓ rebuild
UI actualizada
```

## 📚 Convenciones de Documentación

### DartDoc
Todos los archivos usan comentarios DartDoc (`///`) para documentación:

```dart
/// Descripción breve de la clase/método
///
/// Descripción detallada con contexto adicional.
///
/// [parametro] - Descripción del parámetro
///
/// Returns: Descripción del valor de retorno
///
/// Throws:
/// - [TipoExcepcion] si ocurre X
class MiClase { ... }
```

### Comentarios en Código
- `//` para comentarios de una línea
- Secciones marcadas con `// ========== Sección ==========`
- Comentarios explicativos antes de lógica compleja

## 🛠️ Tecnologías Utilizadas

### Dependencias Principales
- **flutter**: Framework de UI
- **provider**: Gestión de estado
- **dio**: Cliente HTTP con interceptores
- **shared_preferences**: Almacenamiento local para caché
- **cached_network_image**: Caché de imágenes
- **url_launcher**: Abrir URLs externas
- **flutter_dotenv**: Variables de entorno

### API Externa
- **Currents API**: `https://api.currentsapi.services/v1`
- Autenticación con API Key en header `Authorization`
- Endpoints:
  - `/latest-news`: Noticias recientes
  - `/search`: Búsqueda por keywords

## 🎯 Características Clave

### Sistema de Caché
- Duración: 15 minutos
- Almacenamiento: SharedPreferences
- Keys con prefijo: `news_cache_`
- Caché por: noticias recientes, categorías, búsquedas

### Manejo de Errores
- Excepciones personalizadas tipadas
- Mensajes amigables para el usuario
- Logs detallados para debugging
- Retry automático en errores de red

### Rendimiento
- Caché automático reduce peticiones API
- Lazy loading de imágenes
- Interceptores Dio para logging
- Timeouts configurables (30s)

### UX/UI
- Tema oscuro con estilo cyberpunk
- Animaciones suaves
- Pull-to-refresh
- Estados de carga, error y vacío bien definidos
- Navegación intuitiva

## 📝 Ejemplo de Uso

```dart
// En un widget
final provider = context.read<NoticiaProvider>();

// Cargar noticias recientes
await provider.cargarNoticiasRecientes();

// Buscar noticias
await provider.buscarNoticias('tecnología');

// Filtrar por categoría
await provider.filtrarPorCategoria('technology');

// Refrescar (limpia caché)
await provider.refrescar();

// Acceder a datos
final noticias = provider.noticias;
final estado = provider.estado;
final error = provider.mensajeError;
```

## 🧪 Testing

Los tests están organizados en:
- `test/modelo_test.dart`: Tests del modelo NoticiaModel
- `test/modelo_noticia_test.dart`: Tests de serialización JSON
- `test/constantes_test.dart`: Tests de constantes y categorías
- `test/widgets_basicos_test.dart`: Tests de widgets
- `test/widget_test.dart`: Test básico de la app

Ejecutar tests:
```bash
flutter test
```

## 🚀 Ejecución

```bash
# Instalar dependencias
flutter pub get

# Ejecutar en Chrome
flutter run -d chrome

# Ejecutar tests
flutter test

# Generar documentación
dart doc .
```

## 📖 Generar Documentación HTML

Para generar documentación HTML completa:

```bash
# Instalar dart doc (si no está instalado)
dart pub global activate dartdoc

# Generar docs
dartdoc

```

---

**Autor**: Maria Emilia Navalón
**Fecha**: Febrero 2026  
**Versión**: 3.0
