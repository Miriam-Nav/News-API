# Usa una imagen que ya tiene Flutter instalado
FROM ghcr.io/cirruslabs/flutter:stable

# Cambia el directorio de trabajo a la subcarpeta
WORKDIR /app/news_app

# Copia específicamente el contenido de news_app
COPY news_app/ .

# Instalar dependencias
RUN flutter pub get

# Habilitar web
RUN flutter config --enable-web

EXPOSE 8080
# Usar el servidor de desarrollo de Flutter especificando el archivo main.dart
CMD ["flutter", "run", "-d", "web-server", "--web-port=8080", "--web-hostname=0.0.0.0", "-t", "lib/main.dart"]