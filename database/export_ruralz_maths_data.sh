#!/usr/bin/env bash
set -euo pipefail

# Export the complete Ruralz Maths PostgreSQL/Supabase data.
# Usage:
#   SUPABASE_DB_URL='postgresql://USER:PASSWORD@HOST:5432/postgres' \
#     ./database/export_ruralz_maths_data.sh

: "${SUPABASE_DB_URL:?Set SUPABASE_DB_URL before running this script}"

mkdir -p database/export

pg_dump "$SUPABASE_DB_URL" \
  --data-only \
  --inserts \
  --column-inserts \
  --no-owner \
  --no-privileges \
  --table=public.topics \
  --table=public.tests \
  --table=public.questions \
  --table=public.profiles \
  --table=public.attempts \
  --table=public.attempt_answers \
  > database/export/ruralz_maths_data.sql

printf 'Export completed: database/export/ruralz_maths_data.sql\n'
