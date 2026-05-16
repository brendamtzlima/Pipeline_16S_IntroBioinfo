#!/bin/bash

#---------------------------------------
#-- Exportar archivos para Phyloseq
#---------------------------------------
# Brenda Martínez Lima
# Mayo 2026

echo "======================================="
echo " EXPORTANDO ARCHIVOS PHYLOSEQ "
echo "======================================="

# crear carpeta  de archivos exportados
mkdir -p resultados/exportados

# Exportar tabla filtrada
qiime tools export \
    --input-path resultados/qiime2/table-no-org.qza \
    --output-path resultados/exportados/

# Convertir biom a tsv
biom convert \
    -i resultados/exportados/feature-table.biom \
    -o resultados/exportados/feature-table.tsv \
    --to-tsv

# Exportar taxonomía
qiime tools export \
    --input-path resultados/qiime2/taxonomy.qza \
    --output-path resultados/exportados/taxonomy

# Exportar árbol
qiime tools export \
    --input-path resultados/qiime2/rooted-tree.qza \
    --output-path resultados/exportados/tree

# Copiar árbol filogenético a carpeta phyloseq (documentos que van a phyloseq)
mkdir -p resultados/phyloseq

cp resultados/exportados/tree/tree.nwk \
resultados/phyloseq/tree.nwk

# Verificar exportación
if [[ -f resultados/exportados/feature-table.tsv ]]; then

    echo ""
    echo "Archivos exportados correctamente"

    bash scripts/telegram.sh "Archivos exportados para Phyloseq"

else

    echo ""
    echo "ERROR: exportación fallida"

    bash scripts/telegram.sh "ERROR exportación"

fi