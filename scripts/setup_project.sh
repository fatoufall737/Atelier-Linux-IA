#!/bin/bash
read -p "Entrez le nom du projet : " PROJECT_NAME
BASE_DIR="$HOME/$PROJECT_NAME"
echo "=========================================="
echo "Création du projet : $PROJECT_NAME"
echo "=========================================="
mkdir -p "$BASE_DIR"/{datasets/brut,datasets/clean,config,logs,scripts,models,api,backup,documentation,shared}
if [ -d "$BASE_DIR" ]; then ARBO_STATUS="OK"; else ARBO_STATUS="ECHEC"; fi
cat > "$BASE_DIR/config/settings.conf" << EOF
PROJECT_NAME=$PROJECT_NAME
DATA_PATH=datasets/brut
MODEL_PATH=models
LOG_LEVEL=INFO
API_PORT=8000
AUTHOR=Equipe IA
EOF
if [ -f "$BASE_DIR/config/settings.conf" ]; then CONFIG_STATUS="OK"; else CONFIG_STATUS="ECHEC"; fi
echo "Installation des logiciels nécessaires..."
apt update -y > /dev/null 2>&1
apt install -y git curl wget htop tree python3 python3-pip unzip > /dev/null 2>&1
TOOLS="git curl wget htop tree python3 pip3 unzip"
LOGICIELS_STATUS="OK"
for tool in $TOOLS; do
    if ! command -v $tool > /dev/null 2>&1; then LOGICIELS_STATUS="ECHEC ($tool manquant)"; fi
done
DATASET_URL="https://raw.githubusercontent.com/mwaskom/seaborn-data/master/iris.csv"
wget -q "$DATASET_URL" -O "$BASE_DIR/datasets/brut/iris.csv"
if [ -s "$BASE_DIR/datasets/brut/iris.csv" ]; then DATASET_STATUS="OK"; else DATASET_STATUS="ECHEC"; fi
tar -czf "$BASE_DIR/backup/${PROJECT_NAME}.tar.gz" -C "$HOME" "$PROJECT_NAME" 2>/dev/null
ARCHIVE_PATH="backup/${PROJECT_NAME}.tar.gz"
echo "=========================================="
echo "Projet créé"
echo "Nom : $PROJECT_NAME"
echo "Arborescence : $ARBO_STATUS"
echo "Fichier de config : $CONFIG_STATUS"
echo "Logiciels : $LOGICIELS_STATUS"
echo "Datasets : $DATASET_STATUS"
echo "Archive : $ARCHIVE_PATH"
echo "Installation terminée."
echo "=========================================="
