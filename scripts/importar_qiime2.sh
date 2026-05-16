#!/bin/bash

#---------------------------------------
#-- Importar FASTQ a QIIME2
#---------------------------------------
# Brenda Martínez Lima
# Mayo 2026

echo "======================================="
echo " IMPORTANDO FASTQ A QIIME2 "
echo "======================================="

# Crear carpeta de salida
mkdir -p resultados/qiime2

# Manifest de entrada
MANIFEST="metadatos/manifest.csv"

# Salida
OUTPUT="resultados/qiime2/demux-paired-end.qza"

# Validar existencia de manifest
if [[ ! -f $MANIFEST ]]; then

    echo "ERROR: manifest no encontrado"

    bash scripts/telegram.sh "ERROR QIIME2: manifest no encontrado"

    exit 1
fi

# Importar secuencias
qiime tools import \
    --type 'SampleData[PairedEndSequencesWithQuality]' \
    --input-path "$MANIFEST" \
    --output-path "$OUTPUT" \
    --input-format PairedEndFastqManifestPhred33

# Verificar importación de secuencias completada
if [[ $? -eq 0 ]]; then

    echo "Importación completada correctamente"

    bash scripts/telegram.sh "QIIME2 importación completada"

else

    echo "ERROR durante importación"

    bash scripts/telegram.sh "ERROR QIIME2 importación"

    exit 1
fi
