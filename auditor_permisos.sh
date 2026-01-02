#!/data/data/com.termux/files/usr/bin/bash

echo "=== AUDITORÍA DE SEGURIDAD LOCAL ==="
echo "Buscando debilidades en: $HOME"
echo "-----------------------------------"

echo "[1] Archivos con permisos totales (777):"
find $HOME -type f -perm 0777
echo ""

echo "[2] Archivos que otros usuarios pueden modificar (World-Writable):"
find $HOME -type f -perm -o+w
echo ""

echo "[3] Directorios con permisos de escritura para otros:"
find $HOME -type d -perm -o+w
echo ""

echo "[4] Verificando estado de SELinux:"
getenforce 2>/dev/null || echo "No se puede determinar (posible restricción)"

echo "-----------------------------------"
echo "Auditoría completada."
