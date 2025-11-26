
FILE="/output/actor_cdc.json"

while IFS= read -r line; do
    ACTOR_JSON=$(echo "$line" | jq -c '.payload.after')
    
    if [ "$ACTOR_JSON" != "null" ]; then
        ACTOR_ID=$(echo "$ACTOR_JSON" | jq '.actor_id')
        FIRST_NAME=$(echo "$ACTOR_JSON" | jq -r '.first_name')
        LAST_NAME=$(echo "$ACTOR_JSON" | jq -r '.last_name')
        LAST_UPDATE=$(echo "$ACTOR_JSON" | jq -r '.last_update')

        docker exec -i pg_subscriber psql -U admin -d pagila -c \
        "INSERT INTO actor (actor_id, first_name, last_name, last_update) 
         VALUES ($ACTOR_ID, '$FIRST_NAME', '$LAST_NAME', '$LAST_UPDATE')
         ON CONFLICT (actor_id) 
         DO UPDATE SET first_name=EXCLUDED.first_name, last_name=EXCLUDED.last_name, last_update=EXCLUDED.last_update;"
    fi
done < "$FILE"
