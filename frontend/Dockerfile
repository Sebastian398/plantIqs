FROM ubuntu:22.04

RUN apt-get update && apt-get install -y \
    curl git unzip xz-utils zip libglu1-mesa

# Instalar Flutter 3.32 estable (que incluye Dart 3.8)
RUN git clone https://github.com/flutter/flutter.git -b stable /usr/local/flutter
ENV PATH="/usr/local/flutter/bin:/usr/local/flutter/bin/cache/dart-sdk/bin:${PATH}"

# Activar canal estable y actualizar Flutter
RUN flutter channel stable
RUN flutter upgrade

WORKDIR /app

COPY . .

RUN flutter pub get
RUN flutter build web

CMD ["flutter", "run", "-d", "web-server", "--web-port", "5000"]
EXPOSE 5000
