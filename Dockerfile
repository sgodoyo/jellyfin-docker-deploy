# Utilizr la imagen oficial de Debian como base
FROM debian:latest

# Metadatos como el mantenedor del Dockerfile
LABEL maintainer="shackleton@riseup.net"

# Actualizar el sistema e instalar paquetes básicos
RUN apt-get update \
    && apt-get install -y \
    curl \
    wget \
    emacs \
    git \
    && rm -rf /var/lib/apt/lists/*

# Establecer el directorio de trabajo
WORKDIR /app

# Copiar el archivo local my-app.sh al contenedor (opcional)
COPY install-jellyfin.sh /app

# Ejecutar un comando cuando el contenedor se inicie
CMD [ "bash", "./my-app.sh" ]
