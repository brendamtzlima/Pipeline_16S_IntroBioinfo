# Análisis de secuencias de amplicones 16S con Bash y QIIME2

## Introducción

El presente proyecto contiene un pipeline automatizado en Bash para el análisis de secuencias metagenómicas dirigidas a amplicones del 16S utilizando QIIME2. 
El trabajo permite validar los archivos FASTQ, genera automáticamente archivos de manifest y sample-metadata, ejecuta el análisis de QIIME2 desde la importación hasta la clasificación taxonómica y finalmente exporta los archivos compatibles para su posterior análisis en Phyloseq. 

El flujo del pipeline permite validar cada etapa del análisis, verificando la correcta finalización de cada proceso y notificando posibles errores mediante un bot de Telegram. 

##
## Objetivo 

Automatizar el procesamiento inicial de datos de amplicones 16S en QIIME2 generando los archivos compatibles con análisis posteriores en Phyloseq.

##
## Flujo de trabajo 

El pipeline realiza de manera automática los siguientes pasos:
1. Verificación de QIIME2.
2. Validación de archivos FASTQ.
3. Generación de manifest para QIIME2.
4. Importación de secuencias a QIIME2. 
5. Denoising con DADA2.
6. Generación de árbol filogenético. 
7. Clasificación taxonómica con SILVA y filtrado de mitocondria y cloroplasto. 
8. Exportación de archivos desde QIIME2. 
9. Limpieza de tablas para Phyloseq. 
10. Generación de sample-metadata. 
11. Notificaciones automáticas a Telegram. 

##
## Estructura del repositorio 
```bash
├── config
│   ├── README_config.md
├── datos
│   ├── se-33
│   └── vacios
├── metadatos
│   └── manifest.csv
├── programas_contenedores
│   └── SILVA138.2_SSURef_NR99_uniform_classifier_V4-515f-806r.qza
├── resultados
│   ├── exportados
│   ├── phyloseq
│   └── qiime2
├── README.md
└── scripts
    ├── activar_ambiente.sh
    ├── clasificacion_taxonomica.sh
    ├── crear_manifest.sh
    ├── crear_metadata.sh
    ├── dada2_qiime2.sh
    ├── exportar_archivos.sh
    ├── filogenia_qiime2.sh
    ├── importar_qiime2.sh
    ├── limpiar_tablas.sh
    ├── pipeline.sh
    ├── telegram.sh
    └── validacion_fastq.sh
```

### Descripción de carpetas

**scripts/**

Contiene los scripts desarrollados para automatizar el pipeline. 

**datos/**

La carpeta se-33/ contiene los archivos FASTQ de entrada que se desean analizar. 

Si hay archivos vacíos se moverán a la carpeta vacíos/

**resultados/**

En esta carpeta se almacenarán los resultados generados por el pipeline. 

Se dividen en las siguientes subcarpetas:
* qiime2/
* exportados/
* phyloseq/

**metadatos/**

Contiene archivos auxiliares para el análisis. 

Archivos incluidos:
* Manifest.csv

**programas_contenedores/**

Contiene los archivos requeridos para reproducibilidad del ambiente.

Archivos incluidos:
* Clasificador SILVA para QIIME2

**config/**

Contiene archivos de configuración y documentación de parámetros utilizados en el pipeline.

Incluye:
- Parámetros de truncamiento de DADA2;
- Especificaciones de sample metadata;
- Instrucciones para adaptar el pipeline a secuencias single-end.

##
## Requisitos de software

Programas requeridos:
* Bash 5.1.4
* QIIME2 2025.7
* Python 3.10.14
* biom-format 2.1.16
* GNU awk 5.3.1
* GNU sed 4.9
* GNU grep 3.6 
* zcat
* realpath 

##
## Reproducibilidad

Se utiliza el clasificador SILVA138.2 vigente a la fecha. 

El pipeline fue ejecutado utilizando un ambiente de QIIME2 previamente instalado mediante micromamba. 

### Activación del ambiente
```bash
micromamba activate qiime2-amplicon-2025.7
```

### Configuración de Telegram
El pipeline utiliza un bot de Telegram para enviar notificaciones automáticas sobre la ejecución y posibles errores.

Antes de ejecutar el pipeline debe crearse un archivo `.env` en la raíz del proyecto con las siguientes variables:

```bash
TOKEN=TU_TOKEN_TELEGRAM
CHAT_ID=TU_CHAT_ID
```

##
## Instrucciones de uso
### 1. Clonar repositorio 
```bash
git clone https://github.com/usuario/proyecto_final.git
```
### 2. Entrar al proyecto
```bash
cd proyecto_final
```
### 3. Activar ambiente
```bash
micromamba activate qiime2-amplicon-2025.7
```
### 4. Limpiar resultados y archivos de entrada previos
```bash
rm -r resultados/*
rm -r datos/*
```
### 4. Colocar archivos FASTQ
Copiar archivos FASTQ paired-end en:
```bash
cp ../RUTA/*fastq.gz ./datos/se-33/
```
### 5. Ejecutar pipeline
```bash
bash scripts/pipeline.sh
```
### 7. Manejo de errores
El pipeline incluye validaciones automáticas para:

- archivos FASTQ vacíos,
- archivos paired-end incompletos,
- ausencia de FASTQ,
- errores de importación en QIIME2,
- ausencia de archivos generados,
- errores en exportación,
- errores en limpieza de tablas.

Además, el pipeline envía notificaciones automáticas mediante Telegram. En caso de recibir notificación de algún error se recomienda revisar los archivos de entrada. 

##
## Entradas y salidas

### Entradas 
Archivos FASTQ paired-end comprimidos:
datos/se-33/*.fastq.gz

### Salidas
**QIIME2**
Incluye los resultados generales del análisis de QIIME2.
```bash
resultados
   └── qiime2
       ├── aligned-rep-seqs.qza
       ├── demux-paired-end.qza
       ├── denoising-stats.qza
       ├── masked-aligned-rep-seqs.qza
       ├── rep-seqs-no-org.qza
       ├── rep-seqs.qza
       ├── rooted-tree.qza
       ├── table-no-org.qza
       ├── table.qza
       ├── taxonomy.qza
       └── unrooted-tree.qza
```

**Archivos exportados**

Exporta los resultados que se requieren modificar para utilizar en Phyloseq.
```bash
resultados
   ├── exportados
      ├── feature-table.biom
      ├── feature-table.tsv
      ├── taxonomy
      │   └── taxonomy.tsv
      └── tree
          └── tree.nwk
```

**Archivos compatibles con Phyloseq**

Incluye los archivos principales en el formato requerido para su análisis en Phyloseq.
```bash
resultados
   ├── phyloseq
      ├── feature-table.csv
      ├── sample-metadata.tsv
      ├── taxonomy.csv
      └── tree.nwk
```

##
## Información del sistema
Este proyecto fue probado en el siguiente equipo:

- Tipo de equipo: servidor HPC (Tlaloc)
- Sistema operativo: Debian GNU/Linux 11 (bullseye)
- CPU: Intel Xeon E5-2630 v4 @ 2.20GHz
- Núcleos / hilos: 10 núcleos / 20 hilos
- RAM: 125 GB
- GPU: no utilizada
- Arquitectura: x86_64

Tiempo aproximado de ejecución:

- Validación FASTQ: ~5 minutos
- Importación QIIME2: ~3 minutos
- DADA2: variable según número y tamaño de muestras
- Pipeline completo: varios minutos a horas

##
## Autor
**Brenda Martínez Lima**

**Tema de investigación:** Bacterias transportadas por el aire mezcladas y libres de partículas de quema de biomasa en una región del Amazonas, Colombia. 