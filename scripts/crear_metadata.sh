#!/bin/bash

#---------------------------------------
#-- Crear sample metadata
#---------------------------------------
# Brenda Martínez Lima
# Mayo 2026

echo "======================================="
echo " CREANDO SAMPLE METADATA "
echo "======================================="

# Verificar existencia de FASTQ
if ! ls datos/se-33/*_1.fastq.gz 1> /dev/null 2>&1; then

    echo "ERROR: no se encontraron archivos FASTQ"

    bash scripts/telegram.sh "ERROR metadata: no hay FASTQ"

    exit 1
fi

# Archivo de salida
OUTPUT="resultados/phyloseq/sample-metadata.tsv"

# Encabezado
printf "sample-id\tsample-type\tmatrix\n" > "$OUTPUT"

# Recorrer muestras forward
for R1 in datos/se-33/*_1.fastq.gz
do

    # nombre muestra
    sample=$(basename "$R1" _1.fastq.gz)

    # Escribir metadata 
    # CAMBIAR A TIPO DE MUESTRAS
    # CAMBIAR MATRIZ
    printf "%s\t%s\t%s\n" \
    "$sample" \
    "PM10" \
    "Aire" \
    >> "$OUTPUT"

    echo "Metadata agregada: $sample"

done

echo ""
echo "Sample metadata creado correctamente"

bash scripts/telegram.sh "Sample metadata creado correctamente"
