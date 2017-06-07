#!/usr/bin/env bash
# Merge one sqlite event database into another
sqlite3 "$1" <<EOF
ATTACH '$2' AS src;
BEGIN;
INSERT INTO sources
SELECT *
FROM src.sources
WHERE
  name NOT IN sources;
INSERT INTO events
  (type, experiment, src, addr, time, payload)
SELECT
  type, experiment, src, addr, time, payload
FROM src.events;
COMMIT;
DETACH src;
EOF
