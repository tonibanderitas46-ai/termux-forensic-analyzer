#!/bin/bash

# Colores
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
NC='\033[0m'

# Banner
banner() {
    clear
    echo -e "${PURPLE}"
    echo " ███████ ██████  ███████ ███████ ██████  ███████  ██████ ███████"
    echo " ██      ██   ██ ██      ██      ██   ██ ██      ██      ██     "
    echo " █████   ██████  █████   █████   ██████  █████   ██      █████  "
    echo " ██      ██   ██ ██      ██      ██   ██ ██      ██      ██     "
    echo " ██      ██   ██ ███████ ███████ ██   ██ ███████  ██████ ███████"
    echo -e "${NC}"
    echo -e "${CYAN}          Termux Forensic & Security Analyzer v1.0${NC}"
    echo -e "${BLUE}=========================================================${NC}"
}

# Verificar root
check_root() {
    if [ "$(whoami)" != "root" ]; then
        echo -e "${YELLOW}[!] Algunas funciones requieren root para mejor análisis${NC}"
        return 1
    fi
    return 0
}

# Analizador de Seguridad del Sistema
system_security_scan() {
    echo -e "${YELLOW}[+] Analizando Seguridad del Sistema...${NC}"
    
    echo -e "${CYAN}=== INFORMACIÓN DEL SISTEMA ===${NC}"
    echo -e "Sistema: $(uname -a)"
    echo -e "Usuario: $(whoami)"
    echo -e "Directorio actual: $(pwd)"
    
    echo -e "${CYAN}=== PERMISOS DE ARCHIVOS SENSIBLES ===${NC}"
    sensitive_files=("/etc/passwd" "/etc/shadow" "/system/etc" "/data/data" "$HOME/.bashrc")
    for file in "${sensitive_files[@]}"; do
        if [ -e "$file" ]; then
            perms=$(ls -la "$file" 2>/dev/null | awk '{print $1}')
            echo -e "$file: $perms"
        fi
    done
    
    echo -e "${CYAN}=== VARIABLES DE ENTORNO ===${NC}"
    env | grep -E "PATH|HOME|USER|SHELL" | head -10
}

# Analizador de Procesos y Conexiones
process_analyzer() {
    echo -e "${YELLOW}[+] Analizando Procesos y Conexiones...${NC}"
    
    echo -e "${CYAN}=== PROCESOS ACTIVOS ===${NC}"
    ps aux | head -15
    
    echo -e "${CYAN}=== CONEXIONES DE RED ===${NC}"
    netstat -tuln 2>/dev/null | grep -E "LISTEN|ESTABLISHED"
    
    echo -e "${CYAN}=== APLICACIONES INSTALADAS ===${NC}"
    pm list packages 2>/dev/null | head -20 || echo "No se pudo obtener lista de paquetes"
}

# Auditor de Contraseñas y Hashes
password_auditor() {
    echo -e "${YELLOW}[+] Auditor de Seguridad de Contraseñas...${NC}"
    
    echo -e "${CYAN}=== VERIFICANDO ARCHIVOS DE CONTRASEÑAS ===${NC}"
    if [ -f "/etc/passwd" ]; then
        echo -e "Usuarios del sistema:"
        cat /etc/passwd | cut -d: -f1 | head -10
    fi
    
    echo -e "${CYAN}=== GENERADOR DE CONTRASEÑAS SEGURAS ===${NC}"
    echo -e "Aquí tienes algunas contraseñas seguras generadas:"
    for i in {1..5}; do
        password=$(openssl rand -base64 12 2>/dev/null || date +%s | sha256sum | base64 | head -c 16)
        echo -e "${GREEN}Contraseña $i: $password${NC}"
    done
    
    echo -e "${CYAN}=== CONSEJOS DE SEGURIDAD ===${NC}"
    echo -e "1. Usa contraseñas de al menos 12 caracteres"
    echo -e "2. Combina mayúsculas, minúsculas, números y símbolos"
    echo -e "3. No reutilices contraseñas entre servicios"
    echo -e "4. Considera usar un gestor de contraseñas"
}

# Analizador de Archivos Sospechosos
file_analyzer() {
    echo -e "${YELLOW}[+] Analizador de Archivos Sospechosos...${NC}"
    read -p "Ingresa la ruta del archivo a analizar: " file_path
    
    if [ ! -f "$file_path" ]; then
        echo -e "${RED}[-] Archivo no encontrado${NC}"
        return
    fi
    
    echo -e "${CYAN}=== INFORMACIÓN DEL ARCHIVO ===${NC}"
    file "$file_path"
    echo -e "Tamaño: $(du -h "$file_path" | cut -f1)"
    echo -e "Permisos: $(ls -la "$file_path" | awk '{print $1}')"
    echo -e "Hash MD5: $(md5sum "$file_path" | cut -d' ' -f1)"
    
    echo -e "${CYAN}=== STRINGS ENCONTRADAS ===${NC}"
    strings "$file_path" 2>/dev/null | grep -E "http|https|password|key|token" | head -10
    
    echo -e "${CYAN}=== METADATOS (si es imagen o documento) ===${NC}"
    if command -v exiftool &> /dev/null; then
        exiftool "$file_path" 2>/dev/null | head -10
    else
        echo "Instala exiftool para análisis de metadatos: pkg install exiftool"
    fi
}

# Generador de Reporte de Seguridad
security_report() {
    echo -e "${YELLOW}[+] Generando Reporte de Seguridad...${NC}"
    
    report_file="security_report_$(date +%Y%m%d_%H%M%S).txt"
    
    {
        echo "=== REPORTE DE SEGURIDAD TERMUX ==="
        echo "Fecha: $(date)"
        echo "Sistema: $(uname -a)"
        echo "==================================="
        echo ""
        echo "=== INFORMACIÓN DEL SISTEMA ==="
        uname -a
        echo ""
        echo "=== USUARIOS ==="
        whoami
        echo ""
        echo "=== PROCESOS ACTIVOS ==="
        ps aux 2>/dev/null | head -20
        echo ""
        echo "=== CONEXIONES DE RED ==="
        netstat -tuln 2>/dev/null
        echo ""
        echo "=== ARCHIVOS SENSIBLES ==="
        ls -la /etc/passwd /etc/shadow 2>/dev/null
    } > "$report_file"
    
    echo -e "${GREEN}[+] Reporte generado: $report_file${NC}"
}

# Herramienta de Cifrado/Descifrado Básico
crypto_tool() {
    echo -e "${YELLOW}[+] Herramienta de Cifrado Básico...${NC}"
    
    echo -e "${CYAN}1. Cifrar archivo con AES-256${NC}"
    echo -e "${CYAN}2. Descifrar archivo${NC}"
    echo -e "${CYAN}3. Generar hash de archivo${NC}"
    read -p "Selecciona opción [1-3]: " crypto_choice
    
    case $crypto_choice in
        1)
            read -p "Archivo a cifrar: " file_to_encrypt
            if [ -f "$file_to_encrypt" ]; then
                openssl aes-256-cbc -salt -in "$file_to_encrypt" -out "${file_to_encrypt}.encrypted" 2>/dev/null
                if [ $? -eq 0 ]; then
                    echo -e "${GREEN}[+] Archivo cifrado: ${file_to_encrypt}.encrypted${NC}"
                else
                    echo -e "${RED}[-] Error al cifrar${NC}"
                fi
            fi
            ;;
        2)
            read -p "Archivo a descifrar: " file_to_decrypt
            if [ -f "$file_to_decrypt" ]; then
                openssl aes-256-cbc -d -in "$file_to_decrypt" -out "${file_to_decrypt%.encrypted}.decrypted" 2>/dev/null
                if [ $? -eq 0 ]; then
                    echo -e "${GREEN}[+] Archivo descifrado: ${file_to_decrypt%.encrypted}.decrypted${NC}"
                else
                    echo -e "${RED}[-] Error al descifrar (¿contraseña incorrecta?)${NC}"
                fi
            fi
            ;;
        3)
            read -p "Archivo para generar hash: " file_to_hash
            if [ -f "$file_to_hash" ]; then
                echo -e "${GREEN}MD5: $(md5sum "$file_to_hash" | cut -d' ' -f1)${NC}"
                echo -e "${GREEN}SHA256: $(sha256sum "$file_to_hash" | cut -d' ' -f1)${NC}"
            fi
            ;;
        *)
            echo -e "${RED}[-] Opción inválida${NC}"
            ;;
    esac
}

# Analizador de Logs
log_analyzer() {
    echo -e "${YELLOW}[+] Analizador de Logs del Sistema...${NC}"
    
    echo -e "${CYAN}=== ÚLTIMOS LOGINS ===${NC}"
    last 2>/dev/null | head -10 || echo "Comando 'last' no disponible"
    
    echo -e "${CYAN}=== LOGS RECIENTES ===${NC}"
    log_files=("/var/log/messages" "/var/log/syslog" "/data/data/com.termux/files/usr/var/log")
    for log_file in "${log_files[@]}"; do
        if [ -f "$log_file" ]; then
            echo -e "Log: $log_file"
            tail -20 "$log_file" 2>/dev/null | head -5
        fi
    done
}

# Escáner de Vulnerabilidades Básico
vulnerability_scanner() {
    echo -e "${YELLOW}[+] Escáner Básico de Vulnerabilidades...${NC}"
    
    echo -e "${CYAN}=== VERSIONES DE SOFTWARE ===${NC}"
    tools=("bash" "openssl" "python" "nmap")
    for tool in "${tools[@]}"; do
        if command -v $tool &> /dev/null; then
            version=$($tool --version 2>/dev/null | head -1)
            echo -e "$tool: $version"
        fi
    done
    
    echo -e "${CYAN}=== CONFIGURACIONES INSEGURAS COMUNES ===${NC}"
    # Verificar permisos de .bashrc
    if [ -f "$HOME/.bashrc" ]; then
        perms=$(stat -c "%a" "$HOME/.bashrc")
        if [ "$perms" -gt 644 ]; then
            echo -e "${RED}[!] .bashrc tiene permisos muy abiertos: $perms${NC}"
        fi
    fi
    
    echo -e "${CYAN}=== SERVICIOS EXPUESTOS ===${NC}"
    netstat -tuln 2>/dev/null | grep "0.0.0.0" || echo "No se encontraron servicios expuestos"
}

# Menú Principal
main_menu() {
    while true; do
        echo
        echo -e "${PURPLE}=== TERMUX FORENSIC ANALYZER ===${NC}"
        echo -e "${CYAN}1. ${NC}Análisis de Seguridad del Sistema"
        echo -e "${CYAN}2. ${NC}Analizador de Procesos y Conexiones"
        echo -e "${CYAN}3. ${NC}Auditor de Contraseñas"
        echo -e "${CYAN}4. ${NC}Analizador de Archivos Sospechosos"
        echo -e "${CYAN}5. ${NC}Herramienta de Cifrado/Descifrado"
        echo -e "${CYAN}6. ${NC}Analizador de Logs"
        echo -e "${CYAN}7. ${NC}Escáner de Vulnerabilidades"
        echo -e "${CYAN}8. ${NC}Generar Reporte Completo"
        echo -e "${CYAN}9. ${NC}Instalar Dependencias"
        echo -e "${CYAN}0. ${NC}Salir"
        echo
        
        read -p "Selecciona una opción [0-9]: " choice
        
        case $choice in
            1) system_security_scan ;;
            2) process_analyzer ;;
            3) password_auditor ;;
            4) file_analyzer ;;
            5) crypto_tool ;;
            6) log_analyzer ;;
            7) vulnerability_scanner ;;
            8) security_report ;;
            9) install_dependencies ;;
            0) echo -e "${GREEN}[+] ¡Hasta luego!${NC}"; exit 0 ;;
            *) echo -e "${RED}[-] Opción inválida${NC}" ;;
        esac
        
        echo
        read -p "Presiona Enter para continuar..."
        banner
    done
}

# Instalar Dependencias
install_dependencies() {
    echo -e "${YELLOW}[+] Instalando dependencias forenses...${NC}"
    
    pkg update && pkg upgrade -y
    
    forensic_tools=("file" "openssl" "net-tools" "procps" "exiftool" "strings")
    
    for tool in "${forensic_tools[@]}"; do
        if ! command -v $tool &> /dev/null; then
            echo -e "${BLUE}[+] Instalando $tool...${NC}"
            pkg install -y $tool 2>/dev/null
        else
            echo -e "${GREEN}[+] $tool ya está instalado${NC}"
        fi
    done
    
    echo -e "${GREEN}[+] Instalación completada${NC}"
}

# Inicialización
init() {
    banner
    check_root
    main_menu
}

# Manejar interrupciones
trap 'echo -e "${RED}\n[!] Script interrumpido${NC}"; exit 1' SIGINT

# Ejecutar
init
