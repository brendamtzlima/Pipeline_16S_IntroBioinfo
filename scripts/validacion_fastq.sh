#!/bin/bash

#---------------------------------------
#-- Script para validar archivos FASTQ -
#---------------------------------------
# Brenda Martínez Lima
# Mayo 2026

echo "======================================="
echo " VALIDACIÓN DE ARCHIVOS FASTQ "
echo "======================================="

# Carpeta para archivos vacíos
mkdir -p datos/vacios

# Revisión de archivos FASTQ
for archivo in datos/se-33/*.fastq.gz
do

    echo ""
    echo "Procesando archivo: $archivo"

    # Validar existencia de archivos
    if [[ ! -f $archivo ]]; then

        echo "ERROR: archivos no encontrados"

        bash scripts/telegram.sh "ERROR: archivos no encontrados"

        continue
    fi

    # Validar que archivos no esten vacíos
    if [[ ! -s $archivo ]]; then

        echo "ERROR: archivo vacío"

        mv "$archivo" datos/vacios/

        echo "Archivo movido a datos/vacios"

        bash scripts/telegram.sh "Archivo vacío movido: $(basename $archivo)"

        continue
    fi

    ## Validar estructura FASTQ 
    # variables
    i=0
    idx=1
    b=0
    fasta=()

    # Leer archivo línea por línea
    zcat "$archivo" | while IFS= read -r line
    do

        # Guardar línea en arreglo
        fasta[idx]=$line

        ((i=i+1))
        ((idx=idx+1))

        # Procesar bloques FASTQ
        if [[ $((i % 4)) == 0 ]]; then

            ((b=b+1))

            # Guardar variables
            v1=${fasta[1]}
            v2=${fasta[2]}
            v3=${fasta[3]}
            v4=${fasta[4]}

                # Validar encabezado de fastq
                if ! [[ $v1 = @* ]]; then

                    echo "ERROR: la línea $i no inicia con @"

                    bash scripts/telegram.sh "ERROR FASTQ encabezado: $(basename $archivo)"

                    continue
                fi

                # Validar secuencia de fastq
                if ! [[ "$v2" =~ ^[ACGTN]+$ ]]; then

                    echo "ERROR: secuencia inválida en línea $i"

                    bash scripts/telegram.sh "ERROR FASTQ secuencia: $(basename $archivo)"

                    continue
                fi

                # Validar longitud secuencia/calidad de fastq
                if ! [[ "${#v2}" -eq "${#v4}" ]]; then

                    echo "ERROR: secuencia y calidad con diferente longitud"

                    bash scripts/telegram.sh "ERROR FASTQ calidad: $(basename $archivo)"

                    continue
                fi

            # Reiniciar arreglo
            fasta=()
            idx=1

        fi

    done

    # Validar múltiplo de 4
    if ! [[ $((i % 4)) == 0 ]]; then

        echo "ERROR: número incorrecto de líneas"

        bash scripts/telegram.sh "ERROR FASTQ líneas: $(basename $archivo)"

        continue
    fi

    echo "Archivo FASTQ válido"
    echo "Bloques FASTQ encontrados: $b"

    bash scripts/telegram.sh "FASTQ validado correctamente: $(basename $archivo)"

done

echo ""
echo "VALIDACIÓN FINALIZADA"