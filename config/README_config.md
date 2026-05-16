# Configuración del pipeline

## Parámetros DADA2

Actualmente el pipeline utiliza:

- trunc-len-f = 250
- trunc-len-r = 250

Estos parámetros deben ajustarse según la calidad de las lecturas FASTQ.

## Tipo de muestras

El sample metadata generado automáticamente utiliza:

- sample-type = PM10
- matrix = Aire

Estos valores pueden modificarse manualmente en:

scripts/crear_metadata.sh

## Tipo de secuenciación

El pipeline está diseñado para datos paired-end:

*_1.fastq.gz
*_2.fastq.gz

Para utilizar secuencias single-end se requiere:

- modificar crear_manifest.sh
- modificar importar_qiime2.sh
- cambiar dada2 denoise-paired por dada2 denoise-single