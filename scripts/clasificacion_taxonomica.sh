#!/bin/bash

#---------------------------------------
#-- Clasificación taxonómica QIIME2
#---------------------------------------
# Brenda Martínez Lima
# Mayo 2026

echo "======================================="
echo " CLASIFICACIÓN TAXONÓMICA "
echo "======================================="

# Leer classifier
CLASSIFIER="programas_contenedores/SILVA138.2_SSURef_NR99_uniform_classifier_V4-515f-806r.qza"

# Leer secuencias
READS="resultados/qiime2/rep-seqs.qza"

# Validar existencia de classifier taxonómico 
if [[ ! -f $CLASSIFIER ]]; then

    echo "ERROR: classifier no encontrado"

    bash scripts/telegram.sh "ERROR taxonomy: classifier no encontrado"

    exit 1
fi

# Validar existencia de secuencias representativas
if [[ ! -f $READS ]]; then

    echo "ERROR: rep-seqs.qza no encontrado"

    bash scripts/telegram.sh "ERROR taxonomy: rep-seqs.qza no encontrado"

    exit 1
fi

# Clasificación taxonómica en qiime2
qiime feature-classifier classify-sklearn \
    --i-classifier "$CLASSIFIER" \
    --i-reads "$READS" \
    --o-classification resultados/qiime2/taxonomy.qza

# Filtrar mitocondria y cloroplasto en qiime2
qiime taxa filter-table \
    --i-table resultados/qiime2/table.qza \
    --i-taxonomy resultados/qiime2/taxonomy.qza \
    --p-exclude mitochondria,chloroplast \
    --o-filtered-table resultados/qiime2/table-no-org.qza

qiime taxa filter-seqs \
    --i-sequences resultados/qiime2/rep-seqs.qza \
    --i-taxonomy resultados/qiime2/taxonomy.qza \
    --p-exclude mitochondria,chloroplast \
    --o-filtered-sequences resultados/qiime2/rep-seqs-no-org.qza

# Verificar clasificación completada
if [[ $? -eq 0 ]]; then

    echo "Clasificación taxonómica finalizada"

    bash scripts/telegram.sh "Clasificación taxonómica finalizada"

else

    echo "ERROR en clasificación taxonómica"

    bash scripts/telegram.sh "ERROR clasificación taxonómica"

    exit 1
fi

