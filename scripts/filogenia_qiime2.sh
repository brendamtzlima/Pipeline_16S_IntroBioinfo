#!/bin/bash

#---------------------------------------
#-- Filogenia en QIIME2
#---------------------------------------
# Brenda Martínez Lima
# Mayo 2026

echo "======================================="
echo " GENERANDO ÁRBOL FILOGENÉTICO "
echo "======================================="

# Secuencias representativas de entrada
INPUT="resultados/qiime2/rep-seqs.qza"

# Validar entrada
if [[ ! -f $INPUT ]]; then

    echo "ERROR: rep-seqs.qza no encontrado"

    bash scripts/telegram.sh "ERROR filogenia: rep-seqs.qza no encontrado"

    exit 1
fi

# Generar alineamiento y árbol filogenético en Qiime2
qiime phylogeny align-to-tree-mafft-fasttree \
    --i-sequences "$INPUT" \
    --o-alignment resultados/qiime2/aligned-rep-seqs.qza \
    --o-masked-alignment resultados/qiime2/masked-aligned-rep-seqs.qza \
    --o-tree resultados/qiime2/unrooted-tree.qza \
    --o-rooted-tree resultados/qiime2/rooted-tree.qza

# Verificar generación de árbol
if [[ $? -eq 0 ]]; then

    echo "Árbol filogenético generado correctamente"

    bash scripts/telegram.sh "Árbol filogenético generado correctamente"

else

    echo "ERROR en filogenia"

    bash scripts/telegram.sh "ERROR en filogenia"

    exit 1
fi
