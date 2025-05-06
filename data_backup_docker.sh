#!/bin/sh
# Backup de volúmenes Docker compatible con sh

BACKUP_DIR="/opt/backups/docker"
DATE=$(date +"%Y-%m-%d")
mkdir -p "$BACKUP_DIR/$DATE"

# Volúmenes a respaldar (separados por espacio)
VOLUMENES="n8n_data supabase_db_data supabase_kong_data supabase_pgadmin_data supabase_storage_data localai_ollama_storage localai_open-webui localai_qdrant_storage localai_valkey-data"

echo "🔐 Iniciando backup de volúmenes Docker..."

for VOLUMEN in $VOLUMENES; do
  echo "📦 Respaldando: $VOLUMEN"
  docker run --rm \
    -v $VOLUMEN:/volume \
    -v "$BACKUP_DIR/$DATE":/backup \
    alpine \
    tar -czf "/backup/${VOLUMEN}.tar.gz" -C /volume .
done

# Borrar backups con más de 30 días
find "$BACKUP_DIR" -maxdepth 1 -type d -mtime +30 -exec rm -rf {} \;

echo "✅ Backup completo en: $BACKUP_DIR/$DATE"
