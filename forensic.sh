#!/data/data/com.termux/files/usr/bin/bash

# Colores Profesionales
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
NC='\033[0m'

banner() {
    clear
    echo -e "${CYAN}========================================================="
    echo -e "   🛡️  TERMUX FORENSIC & SECURITY SUITE PRO v2.0  🛡️"
    echo -e "=========================================================${NC}"
}

# --- FUNCIONES DE SEGURIDAD LOCAL ---
local_scan() {
    echo -e "${YELLOW}[+] Iniciando Auditoría Local...${NC}"
    # Aquí llamamos a tu script de auditoría de permisos
    bash ~/termux-forensic-analyzer/auditor_permisos.sh
}

# --- FUNCIONES DE ANÁLISIS REMOTO (NUEVO) ---
remote_audit() {
    echo -e "${BLUE}[+] Iniciando Auditoría Remota vía ADB...${NC}"
    if command -v analizar_pro &> /dev/null; then
        analizar_pro
    else
        echo -e "${RED}[!] Error: El script analizar_pro no está instalado en el sistema.${NC}"
    fi
}

# --- PROTOCOLOS DE CONTROL (BOTONES DE PÁNICO) ---
panic_control() {
    echo -e "${RED}=== CENTRO DE CONTROL DE EMERGENCIA ===${NC}"
    echo "1. Ejecutar PROTOCOLO SEGURO (Cerrar todo)"
    echo "2. Ejecutar ACTIVACIÓN (Abrir servicios)"
    read -p "Seleccione: " p_choice
    case $p_choice in
        1) seguro ;;
        2) encender ;;
    esac
}

# --- MENÚ PRINCIPAL ---
while true; do
    banner
    echo -e "${CYAN}1.${NC} Auditoría de Seguridad Local"
    echo -e "${CYAN}2.${NC} Análisis Remoto (ADB) para Clientes"
    echo -e "${CYAN}3.${NC} Protocolos de Emergencia (Seguro/Encender)"
    echo -e "${CYAN}4.${NC} Generar Reporte Profesional"
    echo -e "${CYAN}5.${NC} Limpiar Historial y Rastros"
    echo -e "${CYAN}0.${NC} Salir"
    echo
    read -p "Seleccione una opción: " opt

    case $opt in
        1) local_scan ;;
        2) remote_audit ;;
        3) panic_control ;;
        4) analizar_pro ;; # Reutiliza la lógica del reporte pro
        5) history -c && rm -f ~/.bash_history && echo -e "${GREEN}Historial borrado.${NC}" ;;
        0) exit 0 ;;
        *) echo -e "${RED}Opción no válida.${NC}" ;;
    esac
    read -p "Presiona Enter para continuar..."
done
