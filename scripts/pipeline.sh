#!/bin/bash

#---------------------------------------
#-- Pipeline principal microbioma 16S
#---------------------------------------
# Brenda Martínez Lima
# Mayo 2026

echo "======================================="
echo " INICIANDO PIPELINE 16S "
echo "======================================="

# Mensaje inicio
bash scripts/telegram.sh "Pipeline 16S iniciado"

# Verificar QIIME2
echo ""
echo "Verificando ambiente..."

bash scripts/activar_ambiente.sh

# Validar FASTQ
echo ""
echo "Validando FASTQ..."

bash scripts/validacion_fastq.sh

# Crear manifest
echo ""
echo "Creando manifest..."

bash scripts/crear_manifest.sh

# Importar QIIME2
echo ""
echo "Importando FASTQ..."

bash scripts/importar_qiime2.sh

# DADA2 QIIME2
echo ""
echo "Ejecutando DADA2..."

bash scripts/dada2_qiime2.sh

# Filogenia
echo ""
echo "Generando árbol filogenético..."

bash scripts/filogenia_qiime2.sh

# Taxonomía
echo ""
echo "Clasificando taxonomía..."

bash scripts/clasificacion_taxonomica.sh

# Exportar
echo ""
echo "Exportando archivos..."

bash scripts/exportar_archivos.sh

# Limpiar tablas
echo ""
echo "Limpiando tablas para Phyloseq..."

bash scripts/limpiar_tablas.sh

# Crear metadata
echo ""
echo "Creando sample metadata..."

bash scripts/crear_metadata.sh

# Mensaje final
bash scripts/telegram.sh "Pipeline 16S finalizado correctamente"

echo ""
echo "PIPELINE FINALIZADO"