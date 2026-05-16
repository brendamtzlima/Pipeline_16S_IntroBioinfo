#!/bin/bash

#---------------------------------------
#-- Limpiar tablas para Phyloseq -------
#---------------------------------------
# Brenda Martínez Lima
# Mayo 2026

echo "======================================="
echo " LIMPIANDO TABLAS PARA PHYLOSEQ "
echo "======================================="

# Crear carpeta para archivos phyloseq
mkdir -p resultados/phyloseq


# LIMPIAR FEATURE TABLE

echo "Limpiando feature-table..."

sed '1d' resultados/exportados/feature-table.tsv | \
sed 's/#OTU ID/OTUID/' | \
tr '\t' ',' \
> resultados/phyloseq/feature-table.csv


# LIMPIAR TAXONOMY

echo "Limpiando taxonomy..."

awk '
BEGIN{
FS="\t";
OFS=",";
print "OTUID,Domain,Phylum,Class,Order,Family,Genus"
}

NR>1{

split($2,tax,";");

domain=tax[1];
phylum=tax[2];
class=tax[3];
order=tax[4];
family=tax[5];
genus=tax[6];

gsub("d__","",domain);
gsub("p__","",phylum);
gsub("c__","",class);
gsub("o__","",order);
gsub("f__","",family);
gsub("g__","",genus);

print $1,domain,phylum,class,order,family,genus
}
' resultados/exportados/taxonomy/taxonomy.tsv \
> resultados/phyloseq/taxonomy.csv

# Verificar tablas phyloseq
if [[ -f resultados/phyloseq/feature-table.csv ]]; then

    echo ""
    echo "Tablas listas para Phyloseq"

    bash scripts/telegram.sh "Tablas listas para Phyloseq"

else

    echo ""
    echo "ERROR: limpieza para Phyloseq fallida"

    bash scripts/telegram.sh "ERROR tablas Phyloseq"

fi