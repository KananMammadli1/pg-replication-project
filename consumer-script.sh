kafka-console-consumer \
  --bootstrap-server kafka:9092 \
  --topic pgcdc.public.actor \
  --from-beginning \
  --property print.key=false \
  --property print.timestamp=false \
  >> /output/actor_cdc.json &

tail -f /dev/null
