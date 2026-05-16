#!/bin/bash

#---------------------------------------
#-- Crear manifest para QIIME2
#---------------------------------------
# Brenda Martínez Lima
# Mayo 2026

echo "======================================="
echo " CREANDO MANIFEST "
echo "======================================="

# Archivo de salida
OUTPUT="metadatos/manifest.csv"

# Encabezado de manifest
printf "sample-id,absolute-filepath,direction\n" > "$OUTPUT"

# Verificar existencia de FASTQ
if ! ls datos/se-33/*_1.fastq.gz 1> /dev/null 2>&1; then

    echo "ERROR: no se encontraron archivos FASTQ"

    bash scripts/telegram.sh "ERROR manifest: no hay FASTQ"

    exit 1
fi

# Recorrer archivos forward
for R1 in datos/se-33/*_1.fastq.gz
do

    # Nombre de muestra
    sample=$(basename "$R1" _1.fastq.gz)

    # Archivo reverse
    R2="datos/se-33/${sample}_2.fastq.gz"

    # Validar reverse
    if [[ ! -f $R2 ]]; then

        echo "ERROR: no existe archivo reverse para $sample"

        bash scripts/telegram.sh "ERROR manifest: falta reverse para $sample"

        continue
    fi

    # Rutas absolutas
    abs_R1=$(realpath "$R1")
    abs_R2=$(realpath "$R2")

    # Escribir forward
    printf "%s,%s,%s\n" "$sample" "$abs_R1" "forward" >> "$OUTPUT"

    # Escribir reverse
    printf "%s,%s,%s\n" "$sample" "$abs_R2" "reverse" >> "$OUTPUT"

    echo "Muestra agregada: $sample"

done

echo ""
echo "Manifest creado correctamente"

bash scripts/telegram.sh "Manifest creado correctamente"