# Utilizar la imagen oficial de Debian como base
FROM debian:latest

# Metadatos como el mantenedor del Dockerfile
LABEL maintainer="your-email@example.com"

# Configurar variables de entorno, como la zona horaria
ENV TZ=America/New_York

# Actualizar el sistema e instalar paquetes básicos
RUN apt-get update \
    && apt-get install -y \
    curl \
    wget \
    vim \
    && rm -rf /var/lib/apt/lists/*

# Establecer el directorio de trabajo
WORKDIR /app

# Copiar el archivo local my-app.sh al contenedor (opcional)
COPY my-app.sh /app

# Ejecutar un comando cuando el contenedor se inicie
CMD [ "bash", "./my-app.sh" ]
