#!/bin/bash
#Primero se le asigna un argumento a $1. En este caso se le debe asignar un directorio.
echo "Directorio: $1"
# Luego, se valida que se haya proporcionado un argumento. Aquí el -z verifica si el argumento tiene longitud cero.
if [ -z "$1" ]; then
    echo "Error: Debes proporcionar un directorio como argumento."
    echo "Uso: $0 <directorio>"
    exit 1
fi
#Después, se verifica que el argumento sea un directorio existente. El -d verifica si el argumento introducido es un directorio.
if [ ! -d "$1" ]; then
    echo "El directorio $1 no existe."
    exit 1
fi
# Si el directorio existe luego se crea un array que va a detectar todos los archivos .txt dentro del directorio y los va a contar en caso de que hayan y si no hay mostrará:No hay archivos.txt
archivos=( "$1"/*.txt )
if [ ! -e "${archivos[0]}" ] && [ "${archivos[0]}" = "$1/*.txt" ]; then
    total=0
else
    total=${#archivos[@]}
fi
#Ahora en la variable fecha se guarda la fecha actual y en la variable backup_dir se crea una carpeta llamada backup_$fecha dentro del argumento (en este caso un directorio) $1. 
fecha=$(date +%Y-%m-%d)
backup_dir="$1/backup_$fecha"
mkdir -p "$backup_dir"
echo "Carpeta backup_dir creada."
#En esta parte del código para cada archivo .txt que se encuentre en el argumento se tomará su nombre y se copiará en la carpeta $backup_$fecha bajo el nombre de copia_$nombre.
copiados=()
for archivo in "$1"/*.txt; do
    if [ -f "$archivo" ]; then
    nombre=$(basename "$archivo")
    cp "$archivo" "$backup_dir/copia_$nombre"
    copiados+=("$nombre -> copia_$nombre")
    fi
done

{
    echo "Resumen de archivos .txt"
    echo "========================"
    echo "Total: $total"
    echo "Listado:"
    for item in "${copiados[@]}"; do
        echo "  $item"
done
} > "$backup_dir/resumen.log"
echo "Resumen guardado en $backup_dir/resumen.log"

