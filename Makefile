postgres: down clean kafka-up postgres-up add-pg-connector seed-pg-data
consume-postgres: build start-postgres-consumer
mysql: down clean kafka-up mysql-up add-mysql-connector
consume-mysql: build start-mysql-consumer

down:
	docker-compose down

clean:
	docker container prune --force

build:
	docker build -t consumer .

# =======
#  Kafka
# =======
kafka-up:
	docker-compose up -d kafka zookeeper kafka-connect
	sleep 10

kafka-down:
	docker-compose stop kafka zookeeper kafka-connect

# ==========
#  Postgres
# ==========
postgres-up:
	docker-compose up -d postgres
	sleep 5

postgres-down:
	docker-compose stop postgres

add-pg-connector:
	curl -i -X POST -H "Accept:application/json" -H "Content-Type:application/json" localhost:8083/connectors/ --data "@./conf/postgresql.json"

seed-pg-data:
	docker exec -it  postgres psql -d postgres -U postgres -a -f /sql/ddl.sql
	docker exec -it  postgres psql -d postgres -U postgres -a -f /sql/dml_insert.sql

update-pg-data:
	docker exec -it  postgres psql -d postgres -U postgres -a -f /sql/dml_update.sql

start-postgres-consumer:
	docker run --network debezium-poc_kafka-network --rm --name consumer consumer python consumer.py cdc.postgres.sales.order

# =======
#  MySQL
# =======
mysql-up:
	docker-compose up -d mysql
	sleep 30

mysql-down:
	docker-compose stop mysql

add-mysql-connector:
	curl -i -X POST -H "Accept:application/json" -H "Content-Type:application/json" localhost:8083/connectors/ --data "@./conf/mysql.json"

start-mysql-consumer:
	docker run --network debezium-poc_kafka-network --rm --name consumer consumer python consumer.py cdc.mysql.inventory.orders
