```markdown
# PG Replication Project

This project demonstrates a PostgreSQL logical replication pipeline using Docker, Debezium, Kafka, and a file consumer. The goal is to capture changes from a **publisher database** and synchronize them with a **subscriber database**, while also exporting CDC data to files for further processing.

## Project Structure

```

D:/pg-replication-project
│   application.properties
│   consumer-script.sh
│   docker-compose.yml
│   load_actor.sh
│   pagila-insert-data.sql
│   pagila-schema.sql
│
+---cdc_output
|       actor_cdc.json
|       film_cdc.json
|
---pgadmin_files
pgadmin4.db
...

````

### Key Components

1. **PostgreSQL Publisher (`pg_publisher`)**
   - Hosts the `pagila` database.
   - Configured with logical replication enabled (`wal_level=logical`).

2. **PostgreSQL Subscriber (`pg_subscriber`)**
   - Receives replicated changes from the publisher.
   - Can load CDC JSON data from Kafka consumer.

3. **Kafka & Zookeeper**
   - Kafka broker for streaming CDC events.
   - Zookeeper for Kafka coordination.

4. **Debezium Server**
   - Captures CDC events from PostgreSQL publisher.
   - Publishes changes to Kafka topics.

5. **Kafka Consumer → File Writer (`kafka_to_file`)**
   - Consumes messages from Kafka topics.
   - Writes JSON change events to `/cdc_output` folder.

6. **Shell Scripts**
   - `consumer-script.sh`: Kafka consumer script.
   - `load_actor.sh`: Loads actor JSON events into subscriber database.

7. **PGAdmin**
   - Web UI for managing PostgreSQL databases.
   - Accessible at port 5050.

8. **Application Properties**
   - Configures Debezium source connector for PostgreSQL.
   - Specifies tables to monitor (`actor`, `film`, `customer`).

## How to Run

1. Start all services with Docker Compose:
```bash
docker-compose up -d
````

2. Verify that CDC events are being captured:

```bash
docker exec -it kafka_to_file bash
cat /output/actor_cdc.json
```

3. Load actor changes to the subscriber:

```bash
./load_actor.sh
```

4. Check subscriber database:

```sql
SELECT * FROM actor WHERE actor_id IN (1, 999);
```

5. Access PGAdmin UI:

```
http://localhost:5050
```

Login: `admin@admin.com`
Password: `admin`

## Notes

* Debezium captures inserts, updates, and deletes in real-time.
* JSON files in `/cdc_output` can later be pushed to S3 or other data sinks.
* `pagila-schema.sql` and `pagila-insert-data.sql` initialize the database with sample data.
