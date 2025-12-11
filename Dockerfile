# ================================
# Imagen base
FROM ubuntu:22.04
ENV DEBIAN_FRONTEND=noninteractive

# ================================
# Instalar dependencias del sistema
RUN apt-get update && apt-get install -y \
    curl \
    wget \
    gnupg \
    software-properties-common \
    libjemalloc2 \
    tzdata \
    sudo \
    ca-certificates \
    && rm -rf /var/lib/apt/lists/*

# ================================
# Instalar MongoDB 7.0
RUN wget -qO - https://www.mongodb.org/static/pgp/server-7.0.asc | apt-key add - \
    && echo "deb [ arch=amd64 ] https://repo.mongodb.org/apt/ubuntu jammy/mongodb-org/7.0 multiverse" | tee /etc/apt/sources.list.d/mongodb-org-7.0.list \
    && apt-get update \
    && apt-get install -y mongodb-org

# ================================
# Crear carpeta de datos persistente
RUN mkdir -p /data/db

# ================================
# Instalar Swift 6.1
RUN wget https://swift.org/builds/swift-6.1.0-release/ubuntu2204/swift-6.1.0-RELEASE/swift-6.1.0-RELEASE-ubuntu22.04.tar.gz \
    && tar xzf swift-6.1.0-RELEASE-ubuntu2204.tar.gz -C /usr/local/ \
    && rm swift-6.1.0-RELEASE-ubuntu2204.tar.gz \
    && ln -s /usr/local/swift-6.1.0-RELEASE-ubuntu22.04/usr/bin/swift /usr/bin/swift

# ================================
# Crear usuario "vapor"
RUN useradd --user-group --create-home --system --home-dir /app vapor
WORKDIR /app
USER vapor

# ================================
# Copiar proyecto y construir
COPY --chown=vapor:vapor . .
RUN swift build -c release --product LocationRegisterAPI

# ================================
# Variables de entorno
ENV MONGODB_URI="mongodb://localhost:27017/LocationRegisterDB"
ENV PORT=8080
ENV SWIFT_BACKTRACE=enable=yes,sanitize=yes,threads=all,images=all,interactive=no,swift-backtrace=./swift-backtrace-static

# ================================
# Exponer puerto
EXPOSE 8080

# ================================
# Volumen persistente para la DB
VOLUME /data/db

# ================================
# Arrancar Mongo + API
CMD mongod --dbpath /data/db --bind_ip 127.0.0.1 --logpath /data/mongo.log --fork \
    && ./.build/release/LocationRegisterAPI serve --env production --hostname 0.0.0.0 --port 8080
