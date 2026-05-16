#!/bin/bash

#---------------------------------------
#-- DADA2 en QIIME2
#---------------------------------------
# Brenda Martínez Lima
# Mayo 2026

echo "======================================="
echo " EJECUTANDO DADA2 "
echo "======================================="

# Entrada
INPUT="resultados/qiime2/demux-paired-end.qza"

# Validar que exista entrada
if [[ ! -f $INPUT ]]; then

    echo "ERROR: demux.qza no encontrado"

    bash scripts/telegram.sh "ERROR DADA2: demux.qza no encontrado"

    exit 1
fi

# Ejecutar DADA2 en qiime2
#Paramétros dependen de la calidad de lecturas
qiime dada2 denoise-paired \
    --i-demultiplexed-seqs "$INPUT" \
    --p-trim-left-f 0 \
    --p-trim-left-r 0 \
    --p-trunc-len-f 250 \
    --p-trunc-len-r 250 \
    --o-table resultados/qiime2/table.qza \
    --o-representative-sequences resultados/qiime2/rep-seqs.qza \
    --o-denoising-stats resultados/qiime2/denoising-stats.qza

# Verificar éxito de DADA2
if [[ $? -eq 0 ]]; then

    echo "DADA2 finalizado correctamente"

    bash scripts/telegram.sh "DADA2 finalizado correctamente"

else

    echo "ERROR en DADA2"

    bash scripts/telegram.sh "ERROR en DADA2"

    exit 1
fi