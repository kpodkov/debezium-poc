# Description
Proof-of-concept for the Debezium Kafka Connect connector with PostgreSQL and MySQL examples.

Includes local kafka, kafka-connect and database components via `docker-compose.yml`

# How to Run
Generally see `Makefile` for details

## MySQL
```shell
# Start all necessary services
make mysql

# Start consumer
make consume-mysql
```

## Postgresql
```shell
# Start all necessary services
make postgres

# Start consumer
make consume-postgres
```