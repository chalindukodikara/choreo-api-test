#!/bin/bash

# This bash script file is only used to spin up a local PostgreSQL Server DB for local development.

echo "Checking if the container exists..."
if docker ps -a --format '{{.Names}}' | grep -q "^postgres-container40$"; then
    echo "PostgreSQL container already exists. Starting..."
    docker start postgres-container40
else
    echo "Pulling PostgreSQL latest docker image..."
    docker pull postgres
    
    echo "PostgreSQL container does not exist. Creating..."
    docker run --name postgres-container40 \
    -e POSTGRES_PASSWORD=Admin@1234 \
    -e POSTGRES_DB=choreo_declarative_api_db40 \
    -p 5440:5432 \
    -v postgres-data40:/var/lib/postgresql/data \
    -d postgres

    sleep 10

    echo "Creating table 'kind'..."
    PGPASSWORD=Admin@1234 psql -h localhost -p 5440 -U postgres -d choreo_declarative_api_db40 -c "create table kind (payload JSONB);"

    echo "Setup completed successfully."
fi

