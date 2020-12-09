# Image
FROM mysql:8.0.22

# Default values 
ARG MYSQL_DATABASE=CSC4710
ARG MYSQL_USER=csc4710
ARG MYSQL_PASSWORD=password
ARG MYSQL_ROOT_PASSWORD=my-secret-pw

# Runtime
ENV MYSQL_DATABASE=${MYSQL_DATABASE}
ENV MYSQL_USER=${MYSQL_USER}
ENV MYSQL_PASSWORD=${MYSQL_PASSWORD}
ENV MYSQL_ROOT_PASSWORD=${MYSQL_ROOT_PASSWORD}

# Custom scripts
COPY create.sql /docker-entrypoint-initdb.d/
COPY insert.sql /docker-entrypoint-initdb.d/