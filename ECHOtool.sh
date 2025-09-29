#!/bin/bash

# ECHOtool - Security Toolkit
# Creado por el grupo ECHO
# Compatible con Termux y WSL

# Colores para la interfaz
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
WHITE='\033[1;37m'
BOLD='\033[1m'
RESET='\033[0m'
BRIGHT_GREEN='\033[1;32m'
DIM_GREEN='\033[2;32m'

# Función para detectar el sistema operativo
detect_system() {
    if [[ "$OSTYPE" == "linux-android"* ]]; then
        SYSTEM="termux"
        PKG_MANAGER="pkg"
    elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
        SYSTEM="linux"
        PKG_MANAGER="apt"
    else
        SYSTEM="unknown"
        PKG_MANAGER="apt"
    fi
}

# Función para limpiar pantalla con estilo
clear_screen() {
    clear
    echo -e "${CYAN}"
    echo "████████████████████████████████████████████████████████████"
    echo -e "${RESET}"
}

# Función para generar caracteres Matrix aleatorios
generate_matrix_char() {
    # Caracteres katakana y algunos símbolos para efecto Matrix
    local chars=("ア" "イ" "ウ" "エ" "オ" "カ" "キ" "ク" "ケ" "コ" "サ" "シ" "ス" "セ" "ソ" 
                 "タ" "チ" "ツ" "テ" "ト" "ナ" "ニ" "ヌ" "ネ" "ノ" "ハ" "ヒ" "フ" "ヘ" "ホ" 
                 "マ" "ミ" "ム" "メ" "モ" "ヤ" "ユ" "ヨ" "ラ" "リ" "ル" "レ" "ロ" "ワ" "ヲ" "ン"
                 "0" "1" "2" "3" "4" "5" "6" "7" "8" "9" ":" "." "=" "-" "+" "*" "<" ">" "|" "¦")
    echo "${chars[$((RANDOM % ${#chars[@]}))]}"
}

# Animación Matrix mejorada
show_matrix_animation() {
    clear_screen
    
    # Variables para controlar la animación
    local width=60
    local height=20
    local duration=1  # Reducido de 2 a 1 segundo
    local drops=15
    
    # Crear arrays para las gotas
    declare -a drop_positions
    declare -a drop_speeds
    declare -a drop_chars
    
    # Inicializar las gotas
    for ((i=0; i<drops; i++)); do
        drop_positions[i]=$((RANDOM % height))
        drop_speeds[i]=$((1 + RANDOM % 3))
        drop_chars[i]=""
    done
    
    echo -e "${GREEN}${BOLD}"
    echo "                           INICIANDO ECHOtool..."
    echo ""
    
    # Bucle principal de animación
    for ((frame=0; frame<duration*10; frame++)); do
        clear_screen
        
        # Título Matrix style
        echo -e "${BRIGHT_GREEN}${BOLD}"
        echo "                    █▀▀ ▄▀█ █▀█ █▀▀ ▄▀█ █▄░█ █▀▄ █▀█"
        echo "                    █▄▄ █▀█ █▀▄ █▄█ █▀█ █░▀█ █▄▀ █▄█"
        echo ""
        echo -e "${DIM_GREEN}                        CARGANDO ECHOtool...${RESET}"
        echo ""
        
        # Crear el efecto Matrix
        for ((row=0; row<height; row++)); do
            local line=""
            for ((col=0; col<width; col++)); do
                local char_added=false
                
                # Verificar si hay una gota en esta posición
                for ((drop=0; drop<drops; drop++)); do
                    local drop_col=$((drop * width / drops + (frame * 2) % 10))
                    local drop_row=${drop_positions[drop]}
                    
                    if [[ $col -eq $drop_col && $row -eq $drop_row ]]; then
                        # Carácter principal de la gota (más brillante)
                        line+="${BRIGHT_GREEN}$(generate_matrix_char)${RESET}"
                        char_added=true
                        break
                    elif [[ $col -eq $drop_col && $row -gt $drop_row && $row -lt $((drop_row + 8)) ]]; then
                        # Cola de la gota (más tenue)
                        local intensity=$((8 - (row - drop_row)))
                        if [[ $intensity -gt 4 ]]; then
                            line+="${GREEN}$(generate_matrix_char)${RESET}"
                        else
                            line+="${DIM_GREEN}$(generate_matrix_char)${RESET}"
                        fi
                        char_added=true
                        break
                    fi
                done
                
                # Si no hay gota, agregar espacio o carácter aleatorio ocasional
                if [[ $char_added == false ]]; then
                    if [[ $((RANDOM % 100)) -lt 5 ]]; then
                        line+="${DIM_GREEN}$(generate_matrix_char)${RESET}"
                    else
                        line+=" "
                    fi
                fi
            done
            echo -e "$line"
        done
        
        # Actualizar posiciones de las gotas
        for ((drop=0; drop<drops; drop++)); do
            drop_positions[drop]=$((drop_positions[drop] + drop_speeds[drop]))
            
            # Reiniciar gota si sale de pantalla
            if [[ ${drop_positions[drop]} -gt $((height + 10)) ]]; then
                drop_positions[drop]=$((RANDOM % 5 - 5))
                drop_speeds[drop]=$((1 + RANDOM % 3))
            fi
        done
        
        # Logo ECHOtool en el centro
        if [[ $frame -gt 5 ]]; then  # Cambiado de 10 a 5
            echo ""
            echo -e "${CYAN}                    ████████████████████"
            echo -e "                    ██${WHITE}    ECHOtool    ${CYAN}██"
            echo -e "                    ██${YELLOW} Security Toolkit ${CYAN}██"
            echo -e "                    ████████████████████${RESET}"
        fi
        
        # Información adicional
        if [[ $frame -gt 8 ]]; then  # Cambiado de 15 a 8
            echo ""
            echo -e "${GREEN}                 Creado por el grupo ${WHITE}${BOLD}ECHO${RESET}"
            echo -e "${DIM_GREEN}              [INICIALIZANDO PROTOCOLOS...]${RESET}"
        fi
        
        # Barra de progreso Matrix style
        if [[ $frame -gt 3 ]]; then  # Cambiado de 8 a 3
            echo ""
            local progress=$((frame * 100 / (duration * 10)))
            local filled=$((progress * 40 / 100))
            local empty=$((40 - filled))
            
            echo -n -e "${GREEN}["
            for ((i=0; i<filled; i++)); do
                echo -n -e "${BRIGHT_GREEN}█${RESET}"
            done
            for ((i=0; i<empty; i++)); do
                echo -n -e "${DIM_GREEN}░${RESET}"
            done
            echo -e "${GREEN}] ${progress}%${RESET}"
        fi
        
        sleep 0.05  # Cambiado de 0.08 a 0.05
    done
    
    # Secuencia final de "hackeo"
    clear_screen
    echo -e "${BRIGHT_GREEN}${BOLD}"
    echo "                    ██████╗ ██████╗  ██████╗ ███╗   ██╗███████╗"
    echo "                    ██╔══██╗██╔══██╗██╔═══██╗████╗  ██║██╔════╝"
    echo "                    ██║  ██║██████╔╝██║   ██║██╔██╗ ██║█████╗  "
    echo "                    ██║  ██║██╔══██╗██║   ██║██║╚██╗██║██╔══╝  "
    echo "                    ██████╔╝██║  ██║╚██████╔╝██║ ╚████║███████╗"
    echo -e "                    ╚═════╝ ╚═╝  ╚═╝ ╚═════╝ ╚═╝  ╚═══╝╚══════╝${RESET}"
    echo ""
    
    # Efecto de texto "hackeando"
    local hack_messages=(
        "[ACCEDIENDO A ECHOtool...]"
        "[SISTEMA LISTO]"
    )
    
    for message in "${hack_messages[@]}"; do
        echo -e "${GREEN}                    $message${RESET}"
        sleep 0.2  # Cambiado de 0.3 a 0.2
        
        # Simular texto escribiéndose
        echo -n -e "${DIM_GREEN}.."  # Solo 2 puntos fijos
        echo -e "${RESET}"
    done
    
    echo ""
    echo -e "${CYAN}${BOLD}                    ¡ECHOtool CARGADA EXITOSAMENTE!${RESET}"
    echo -e "${GREEN}                     WELCOME TO THE ECHOSYSTEM${RESET}"
    sleep 0.5  # Reducido de 1 a 0.5 segundos
    
    # Efecto final de limpieza
    for ((i=0; i<3; i++)); do  # Reducido de 5 a 3 iteraciones
        clear_screen
        echo -e "${GREEN}"
        for ((j=0; j<20; j++)); do
            for ((k=0; k<60; k++)); do
                if [[ $((RANDOM % 10)) -lt 2 ]]; then
                    echo -n "$(generate_matrix_char)"
                else
                    echo -n " "
                fi
            done
            echo ""
        done
        echo -e "${RESET}"
        sleep 0.02  # Reducido de 0.03 a 0.02
    done
}

# Función para mostrar el banner principal
show_banner() {
    clear_screen
    echo -e "${GREEN}${BOLD}"
    echo "███████╗ ██████╗██╗  ██╗ ██████╗ ████████╗ ██████╗  ██████╗ ██╗     "
    echo "██╔════╝██╔════╝██║  ██║██╔═══██╗╚══██╔══╝██╔═══██╗██╔═══██╗██║     "
    echo "█████╗  ██║     ███████║██║   ██║   ██║   ██║   ██║██║   ██║██║     "
    echo "██╔══╝  ██║     ██╔══██║██║   ██║   ██║   ██║   ██║██║   ██║██║     "
    echo "███████╗╚██████╗██║  ██║╚██████╔╝   ██║   ╚██████╔╝╚██████╔╝███████╗"
    echo "╚══════╝ ╚═════╝╚═╝  ╚═╝ ╚═════╝    ╚═╝    ╚═════╝  ╚═════╝ ╚══════╝"
    echo -e "${RESET}"
    echo -e "${CYAN}${BOLD}                     Security Toolkit Avanzado${RESET}"
    echo -e "${YELLOW}                      Creado por el grupo ECHO${RESET}"
    echo -e "${WHITE}                  Compatible con Termux y WSL/Linux${RESET}"
    echo -e "${BLUE}             Grupo official de telegram: t.me/+puR3i2xy6h41MDdh${RESET}"
    echo -e "${RED}                             Version: 1.0${RESET}"
    echo ""
    echo -e "${BLUE}════════════════════════════════════════════════════════════════${RESET}"
}

# Función para instalar dependencias con progreso
install_dependencies() {
    clear_screen
    echo -e "${YELLOW}${BOLD}🔧 Instalando dependencias necesarias...${RESET}"
    echo ""
    
    local tools=("nmap" "netcat" "sqlmap" "hydra" "john")
    local total=${#tools[@]}
    local current=0
    
    if [[ "$SYSTEM" == "termux" ]]; then
        pkg update -y > /dev/null 2>&1
        echo -e "${GREEN}✓ Repositorios actualizados${RESET}"
        
        for tool in "${tools[@]}"; do
            current=$((current + 1))
            echo -e "${CYAN}[$current/$total] Instalando $tool...${RESET}"
            
            case $tool in
                "netcat")
                    pkg install -y netcat-openbsd > /dev/null 2>&1 || pkg install -y netcat > /dev/null 2>&1
                    ;;
                "john")
                    pkg install -y john-the-ripper > /dev/null 2>&1
                    ;;
                *)
                    pkg install -y "$tool" > /dev/null 2>&1
                    ;;
            esac
            
            if command -v "$tool" &> /dev/null || [[ "$tool" == "john" && -f "$PREFIX/bin/john" ]]; then
                echo -e "${GREEN}  ✓ $tool instalado correctamente${RESET}"
            else
                echo -e "${RED}  ✗ Error instalando $tool${RESET}"
            fi
            
            # Barra de progreso
            local progress=$((current * 50 / total))
            local bar=$(printf "%-50s" $(printf "%*s" $progress | tr ' ' '█'))
            echo -e "${BLUE}  [$bar] $((current * 100 / total))%${RESET}"
            echo ""
        done
    else
        sudo apt update > /dev/null 2>&1
        echo -e "${GREEN}✓ Repositorios actualizados${RESET}"
        
        for tool in "${tools[@]}"; do
            current=$((current + 1))
            echo -e "${CYAN}[$current/$total] Instalando $tool...${RESET}"
            sudo apt install -y "$tool" > /dev/null 2>&1
            
            if command -v "$tool" &> /dev/null; then
                echo -e "${GREEN}  ✓ $tool instalado correctamente${RESET}"
            else
                echo -e "${RED}  ✗ Error instalando $tool${RESET}"
            fi
            
            # Barra de progreso
            local progress=$((current * 50 / total))
            local bar=$(printf "%-50s" $(printf "%*s" $progress | tr ' ' '█'))
            echo -e "${BLUE}  [$bar] $((current * 100 / total))%${RESET}"
            echo ""
        done
    fi
    
    echo -e "${GREEN}${BOLD}🎉 ¡Instalación completada!${RESET}"
    read -p "Presiona Enter para continuar..."
}

# Función para mostrar el menú principal
show_main_menu() {
    show_banner
    echo ""
    echo -e "${WHITE}${BOLD}┌─────────────────────────────────────────────────────────────┐${RESET}"
    echo -e "${WHITE}${BOLD}│                     MENÚ PRINCIPAL                          │${RESET}"
    echo -e "${WHITE}${BOLD}├─────────────────────────────────────────────────────────────┤${RESET}"
    echo -e "${WHITE}│ ${GREEN}1.${RESET} ${CYAN}🌐 Nmap${RESET}           - Exploración de red y puertos    ${WHITE}│${RESET}"
    echo -e "${WHITE}│ ${GREEN}2.${RESET} ${CYAN}📡 Netcat${RESET}         - Conexiones TCP/UDP              ${WHITE}│${RESET}"
    echo -e "${WHITE}│ ${GREEN}3.${RESET} ${CYAN}💉 SQLMap${RESET}         - Detección SQL Injection        ${WHITE}│${RESET}"
    echo -e "${WHITE}│ ${GREEN}4.${RESET} ${CYAN}🔓 Hydra${RESET}          - Ataques de fuerza bruta        ${WHITE}│${RESET}"
    echo -e "${WHITE}│ ${GREEN}5.${RESET} ${CYAN}🔑 John the Ripper${RESET} - Crackeo de contraseñas         ${WHITE}│${RESET}"
    echo -e "${WHITE}│ ${GREEN}6.${RESET} ${YELLOW}⚙️  Instalar dependencias${RESET}                          ${WHITE}│${RESET}"
    echo -e "${WHITE}│ ${GREEN}0.${RESET} ${RED}❌ Salir${RESET}                                             ${WHITE}│${RESET}"
    echo -e "${WHITE}${BOLD}└─────────────────────────────────────────────────────────────┘${RESET}"
    echo ""
    echo -e "${PURPLE}Sistema detectado: ${BOLD}$SYSTEM${RESET}"
    echo ""
}

# Función para mostrar información de herramienta
show_tool_info() {
    local tool=$1
    local description=$2
    
    echo -e "${CYAN}${BOLD}"
    echo "╔══════════════════════════════════════════════════════════════╗"
    echo "║                        $tool"
    echo "╠══════════════════════════════════════════════════════════════╣"
    echo -e "║ ${WHITE}$description${CYAN}"
    echo "╚══════════════════════════════════════════════════════════════╝"
    echo -e "${RESET}"
}

# Función para mostrar el menú de Nmap
show_nmap_menu() {
    clear_screen
    show_tool_info "NMAP - NETWORK MAPPER" "Herramienta de exploración de red y auditoría de seguridad"
    echo ""
    echo -e "${WHITE}${BOLD}┌─────────────────────────────────────────────────────────────┐${RESET}"
    echo -e "${WHITE}${BOLD}│                      MENÚ NMAP                              │${RESET}"
    echo -e "${WHITE}${BOLD}├─────────────────────────────────────────────────────────────┤${RESET}"
    echo -e "${WHITE}│ ${GREEN}1.${RESET} ${YELLOW}🚪 Escanear puertos${RESET}    - Detecta puertos abiertos    ${WHITE}│${RESET}"
    echo -e "${WHITE}│ ${GREEN}2.${RESET} ${YELLOW}🔍 Escanear servicios${RESET}  - Identifica servicios        ${WHITE}│${RESET}"
    echo -e "${WHITE}│ ${GREEN}3.${RESET} ${YELLOW}💻 Detectar OS${RESET}         - Sistema operativo           ${WHITE}│${RESET}"
    echo -e "${WHITE}│ ${GREEN}4.${RESET} ${YELLOW}📋 Detectar versiones${RESET}  - Versiones de servicios      ${WHITE}│${RESET}"
    echo -e "${WHITE}│ ${GREEN}5.${RESET} ${YELLOW}🎯 Escaneo completo${RESET}    - Análisis exhaustivo         ${WHITE}│${RESET}"
    echo -e "${WHITE}│ ${GREEN}0.${RESET} ${RED}⬅️  Volver al menú principal${RESET}                          ${WHITE}│${RESET}"
    echo -e "${WHITE}${BOLD}└─────────────────────────────────────────────────────────────┘${RESET}"
    echo ""
}

# Función para escanear con progreso
run_with_progress() {
    local command="$1"
    local description="$2"
    
    echo -e "${CYAN}${BOLD}🔄 $description${RESET}"
    echo -e "${YELLOW}Ejecutando: $command${RESET}"
    echo ""
    
    # Animación de progreso
    {
        for i in {1..20}; do
            echo -n -e "${GREEN}█${RESET}"
            sleep 0.1
        done
    } &
    
    # Ejecutar comando
    eval "$command" > /tmp/echoutil_output.log 2>&1
    local exit_code=$?
    
    wait
    echo ""
    
    if [[ $exit_code -eq 0 ]]; then
        echo -e "${GREEN}${BOLD}✅ Comando ejecutado exitosamente${RESET}"
        echo ""
        echo -e "${CYAN}${BOLD}📋 RESULTADOS:${RESET}"
        echo -e "${WHITE}$(cat /tmp/echoutil_output.log)${RESET}"
    else
        echo -e "${RED}${BOLD}❌ Error al ejecutar el comando${RESET}"
        echo -e "${YELLOW}Salida de error:${RESET}"
        echo -e "${RED}$(cat /tmp/echoutil_output.log)${RESET}"
    fi
    
    echo ""
    read -p "Presiona Enter para continuar..."
}

# Funciones mejoradas para Nmap
scan_ports_with_nmap() {
    clear_screen
    show_tool_info "NMAP - ESCANEO DE PUERTOS" "Detecta puertos TCP abiertos usando escaneo SYN"
    echo ""
    echo -e "${YELLOW}Ingresa el objetivo a escanear:${RESET}"
    echo -e "${CYAN}Ejemplos: 192.168.1.1, example.com, 192.168.1.0/24${RESET}"
    read -p "🎯 Objetivo: " target
    
    if [[ -z "$target" ]]; then
        echo -e "${RED}❌ Debes especificar un objetivo${RESET}"
        sleep 2
        return
    fi
    
    run_with_progress "nmap -sS -T4 $target" "Escaneando puertos en $target"
}

scan_services_with_nmap() {
    clear_screen
    show_tool_info "NMAP - DETECCIÓN DE SERVICIOS" "Identifica servicios y versiones en puertos abiertos"
    echo ""
    read -p "🎯 Objetivo: " target
    
    if [[ -z "$target" ]]; then
        echo -e "${RED}❌ Debes especificar un objetivo${RESET}"
        sleep 2
        return
    fi
    
    run_with_progress "nmap -sV -T4 $target" "Detectando servicios en $target"
}

scan_os_with_nmap() {
    clear_screen
    show_tool_info "NMAP - DETECCIÓN DE OS" "Intenta identificar el sistema operativo objetivo"
    echo ""
    echo -e "${YELLOW}⚠️  Nota: Requiere permisos de root/sudo${RESET}"
    read -p "🎯 Objetivo: " target
    
    if [[ -z "$target" ]]; then
        echo -e "${RED}❌ Debes especificar un objetivo${RESET}"
        sleep 2
        return
    fi
    
    if [[ $EUID -ne 0 && "$SYSTEM" != "termux" ]]; then
        run_with_progress "sudo nmap -O -T4 $target" "Detectando OS en $target"
    else
        run_with_progress "nmap -O -T4 $target" "Detectando OS en $target"
    fi
}

scan_version_with_nmap() {
    clear_screen
    show_tool_info "NMAP - DETECCIÓN DE VERSIONES" "Identifica versiones específicas de servicios"
    echo ""
    read -p "🎯 Objetivo: " target
    
    if [[ -z "$target" ]]; then
        echo -e "${RED}❌ Debes especificar un objetivo${RESET}"
        sleep 2
        return
    fi
    
    run_with_progress "nmap -sV -sC -T4 $target" "Detectando versiones en $target"
}

comprehensive_scan_nmap() {
    clear_screen
    show_tool_info "NMAP - ESCANEO COMPLETO" "Análisis exhaustivo con detección de OS, servicios y scripts"
    echo ""
    echo -e "${YELLOW}⚠️  Este escaneo puede tomar varios minutos${RESET}"
    read -p "🎯 Objetivo: " target
    
    if [[ -z "$target" ]]; then
        echo -e "${RED}❌ Debes especificar un objetivo${RESET}"
        sleep 2
        return
    fi
    
    if [[ $EUID -ne 0 && "$SYSTEM" != "termux" ]]; then
        run_with_progress "sudo nmap -A -T4 -v $target" "Realizando escaneo completo de $target"
    else
        run_with_progress "nmap -A -T4 -v $target" "Realizando escaneo completo de $target"
    fi
}

# Función para mostrar el menú de Netcat
show_netcat_menu() {
    clear_screen
    show_tool_info "NETCAT - LA NAVAJA SUIZA TCP/IP" "Herramienta versátil para conexiones de red"
    echo ""
    echo -e "${WHITE}${BOLD}┌─────────────────────────────────────────────────────────────┐${RESET}"
    echo -e "${WHITE}${BOLD}│                     MENÚ NETCAT                             │${RESET}"
    echo -e "${WHITE}${BOLD}├─────────────────────────────────────────────────────────────┤${RESET}"
    echo -e "${WHITE}│ ${GREEN}1.${RESET} ${YELLOW}🔗 Conectar a host${RESET}     - Cliente TCP/UDP             ${WHITE}│${RESET}"
    echo -e "${WHITE}│ ${GREEN}2.${RESET} ${YELLOW}👂 Escuchar puerto${RESET}     - Servidor TCP/UDP            ${WHITE}│${RESET}"
    echo -e "${WHITE}│ ${GREEN}3.${RESET} ${YELLOW}📁 Transferir archivo${RESET}  - Envío de archivos           ${WHITE}│${RESET}"
    echo -e "${WHITE}│ ${GREEN}4.${RESET} ${YELLOW}🔍 Port scanning${RESET}       - Escaneo básico de puertos   ${WHITE}│${RESET}"
    echo -e "${WHITE}│ ${GREEN}0.${RESET} ${RED}⬅️  Volver al menú principal${RESET}                          ${WHITE}│${RESET}"
    echo -e "${WHITE}${BOLD}└─────────────────────────────────────────────────────────────┘${RESET}"
    echo ""
}

connect_with_netcat() {
    clear_screen
    show_tool_info "NETCAT - CONEXIÓN CLIENTE" "Conecta a un servidor TCP/UDP específico"
    echo ""
    read -p "🌐 Host/IP: " host
    read -p "🚪 Puerto: " port
    read -p "🔄 Protocolo (tcp/udp) [tcp]: " protocol
    
    protocol=${protocol:-tcp}
    
    if [[ -z "$host" || -z "$port" ]]; then
        echo -e "${RED}❌ Debes especificar host y puerto${RESET}"
        sleep 2
        return
    fi
    
    echo -e "${CYAN}🔗 Conectando a $host:$port usando $protocol${RESET}"
    echo -e "${YELLOW}Escribe 'quit' para salir${RESET}"
    echo ""
    
    if [[ "$protocol" == "udp" ]]; then
        nc -u "$host" "$port"
    else
        nc "$host" "$port"
    fi
}

listen_with_netcat() {
    clear_screen
    show_tool_info "NETCAT - MODO SERVIDOR" "Escucha conexiones entrantes en un puerto específico"
    echo ""
    read -p "🚪 Puerto a escuchar: " port
    read -p "🔄 Protocolo (tcp/udp) [tcp]: " protocol
    
    protocol=${protocol:-tcp}
    
    if [[ -z "$port" ]]; then
        echo -e "${RED}❌ Debes especificar un puerto${RESET}"
        sleep 2
        return
    fi
    
    echo -e "${CYAN}👂 Escuchando en puerto $port usando $protocol${RESET}"
    echo -e "${YELLOW}Presiona Ctrl+C para detener${RESET}"
    echo ""
    
    if [[ "$protocol" == "udp" ]]; then
        nc -u -l -p "$port"
    else
        nc -l -p "$port"
    fi
}

# Función para mostrar el menú de SQLMap
show_sqlmap_menu() {
    clear_screen
    show_tool_info "SQLMAP - SQL INJECTION TESTER" "Herramienta automática para detectar y explotar SQL Injection"
    echo ""
    echo -e "${WHITE}${BOLD}┌─────────────────────────────────────────────────────────────┐${RESET}"
    echo -e "${WHITE}${BOLD}│                     MENÚ SQLMAP                             │${RESET}"
    echo -e "${WHITE}${BOLD}├─────────────────────────────────────────────────────────────┤${RESET}"
    echo -e "${WHITE}│ ${GREEN}1.${RESET} ${YELLOW}🗄️  Enumerar bases de datos${RESET} - Lista todas las DBs      ${WHITE}│${RESET}"
    echo -e "${WHITE}│ ${GREEN}2.${RESET} ${YELLOW}📋 Enumerar tablas${RESET}       - Lista tablas de una DB     ${WHITE}│${RESET}"
    echo -e "${WHITE}│ ${GREEN}3.${RESET} ${YELLOW}📊 Enumerar columnas${RESET}     - Lista columnas de tabla    ${WHITE}│${RESET}"
    echo -e "${WHITE}│ ${GREEN}4.${RESET} ${YELLOW}💾 Dump de datos${RESET}         - Extrae datos de tabla      ${WHITE}│${RESET}"
    echo -e "${WHITE}│ ${GREEN}5.${RESET} ${YELLOW}🔍 Detección básica${RESET}      - Solo detecta vulnerabilidad${WHITE}│${RESET}"
    echo -e "${WHITE}│ ${GREEN}0.${RESET} ${RED}⬅️  Volver al menú principal${RESET}                          ${WHITE}│${RESET}"
    echo -e "${WHITE}${BOLD}└─────────────────────────────────────────────────────────────┘${RESET}"
    echo ""
}

# Funciones mejoradas para SQLMap
basic_sqlmap_detection() {
    clear_screen
    show_tool_info "SQLMAP - DETECCIÓN BÁSICA" "Detecta vulnerabilidades SQL Injection sin explotarlas"
    echo ""
    echo -e "${YELLOW}Ejemplos de URL:${RESET}"
    echo -e "${CYAN}  http://example.com/page.php?id=1${RESET}"
    echo -e "${CYAN}  http://example.com/login.php${RESET}"
    echo ""
    read -p "🌐 URL objetivo: " url
    
    if [[ -z "$url" ]]; then
        echo -e "${RED}❌ Debes especificar una URL${RESET}"
        sleep 2
        return
    fi
    
    run_with_progress "sqlmap -u '$url' --batch --level=1 --risk=1" "Detectando SQL Injection en $url"
}

# Función para mostrar el menú de Hydra
show_hydra_menu() {
    clear_screen
    show_tool_info "HYDRA - BRUTE FORCE ATTACK TOOL" "Crackeador de logins para múltiples protocolos de red"
    echo ""
    echo -e "${WHITE}${BOLD}┌─────────────────────────────────────────────────────────────┐${RESET}"
    echo -e "${WHITE}${BOLD}│                     MENÚ HYDRA                              │${RESET}"
    echo -e "${WHITE}${BOLD}├─────────────────────────────────────────────────────────────┤${RESET}"
    echo -e "${WHITE}│ ${GREEN}1.${RESET} ${YELLOW}🔑 Fuerza bruta SSH${RESET}      - Ataque contra SSH          ${WHITE}│${RESET}"
    echo -e "${WHITE}│ ${GREEN}2.${RESET} ${YELLOW}📁 Fuerza bruta FTP${RESET}      - Ataque contra FTP          ${WHITE}│${RESET}"
    echo -e "${WHITE}│ ${GREEN}3.${RESET} ${YELLOW}🌐 Fuerza bruta HTTP${RESET}     - Formularios web login      ${WHITE}│${RESET}"
    echo -e "${WHITE}│ ${GREEN}4.${RESET} ${YELLOW}💾 Generar wordlist${RESET}      - Crea diccionario básico    ${WHITE}│${RESET}"
    echo -e "${WHITE}│ ${GREEN}0.${RESET} ${RED}⬅️  Volver al menú principal${RESET}                          ${WHITE}│${RESET}"
    echo -e "${WHITE}${BOLD}└─────────────────────────────────────────────────────────────┘${RESET}"
    echo ""
}

# Función para generar wordlist básica
generate_wordlist() {
    clear_screen
    show_tool_info "GENERADOR DE WORDLIST" "Crea un diccionario básico para ataques de fuerza bruta"
    echo ""
    
    local wordlist_file="/tmp/echoutil_wordlist.txt"
    
    echo -e "${CYAN}📝 Generando wordlist básica...${RESET}"
    
    # Crear wordlist básica
    cat > "$wordlist_file" << EOF
admin
administrator
root
user
guest
password
123456
password123
admin123
root123
qwerty
abc123
letmein
welcome
monkey
dragon
EOF

    echo -e "${GREEN}✅ Wordlist generada: $wordlist_file${RESET}"
    echo ""
    echo -e "${YELLOW}Contenido:${RESET}"
    cat "$wordlist_file"
    echo ""
    read -p "Presiona Enter para continuar..."
}

# Función para mostrar el menú de John the Ripper
show_john_menu() {
    clear_screen
    show_tool_info "JOHN THE RIPPER - PASSWORD CRACKER" "Crackeador de contraseñas rápido y potente"
    echo ""
    echo -e "${WHITE}${BOLD}┌─────────────────────────────────────────────────────────────┐${RESET}"
    echo -e "${WHITE}${BOLD}│                  MENÚ JOHN THE RIPPER                       │${RESET}"
    echo -e "${WHITE}${BOLD}├─────────────────────────────────────────────────────────────┤${RESET}"
    echo -e "${WHITE}│ ${GREEN}1.${RESET} ${YELLOW}🔓 Crackear hashes${RESET}       - Rompe hashes de contraseñas${WHITE}│${RESET}"
    echo -e "${WHITE}│ ${GREEN}2.${RESET} ${YELLOW}📋 Mostrar crackeadas${RESET}    - Ve contraseñas encontradas ${WHITE}│${RESET}"
    echo -e "${WHITE}│ ${GREEN}3.${RESET} ${YELLOW}🎯 Generar hashes test${RESET}   - Crea hashes para pruebas   ${WHITE}│${RESET}"
    echo -e "${WHITE}│ ${GREEN}0.${RESET} ${RED}⬅️  Volver al menú principal${RESET}                          ${WHITE}│${RESET}"
    echo -e "${WHITE}${BOLD}└─────────────────────────────────────────────────────────────┘${RESET}"
    echo ""
}

# Función para generar hashes de prueba
generate_test_hashes() {
    clear_screen
    show_tool_info "GENERADOR DE HASHES TEST" "Crea hashes de ejemplo para probar John the Ripper"
    echo ""
    
    local hash_file="/tmp/echoutil_hashes.txt"
    
    echo -e "${CYAN}📝 Generando hashes de prueba...${RESET}"
    
    # Crear algunos hashes MD5 de ejemplo
    echo "admin:5e884898da28047151d0e56f8dc6292773603d0d6aabbdd62a11ef721d1542d8" > "$hash_file"
    echo "user:ef92b778bafe771e89245b89ecbc08a44a4e166c06659911881f383d4473e94f" >> "$hash_file"
    echo "test:9f86d081884c7d659a2feaa0c55ad015a3bf4f1b2b0b822cd15d6c15b0f00a08" >> "$hash_file"
    
    echo -e "${GREEN}✅ Archivo de hashes creado: $hash_file${RESET}"
    echo ""
    echo -e "${YELLOW}Contraseñas correspondientes:${RESET}"
    echo -e "${CYAN}  admin -> hello${RESET}"
    echo -e "${CYAN}  user -> secret${RESET}"
    echo -e "${CYAN}  test -> test${RESET}"
    echo ""
    echo -e "${PURPLE}💡 Tip: Usa estos hashes para probar John the Ripper${RESET}"
    echo ""
    read -p "Presiona Enter para continuar..."
}

# Función mejorada para crackear contraseñas
crack_passwords_with_john() {
    clear_screen
    show_tool_info "JOHN THE RIPPER - CRACKEO" "Rompe hashes de contraseñas usando diccionarios y fuerza bruta"
    echo ""
    
    echo -e "${YELLOW}Opciones disponibles:${RESET}"
    echo -e "${CYAN}1. Usar archivo de hashes de prueba${RESET}"
    echo -e "${CYAN}2. Especificar archivo personalizado${RESET}"
    echo ""
    read -p "🔢 Selecciona opción [1]: " option
    
    option=${option:-1}
    local hash_file
    
    if [[ "$option" == "1" ]]; then
        hash_file="/tmp/echoutil_hashes.txt"
        if [[ ! -f "$hash_file" ]]; then
            echo -e "${YELLOW}⚠️  Archivo de prueba no existe, generándolo...${RESET}"
            generate_test_hashes
            return
        fi
    else
        read -p "📁 Ruta al archivo de hashes: " hash_file
        if [[ ! -f "$hash_file" ]]; then
            echo -e "${RED}❌ Archivo no encontrado: $hash_file${RESET}"
            sleep 2
            return
        fi
    fi
    
    echo ""
    echo -e "${YELLOW}Modos de crackeo:${RESET}"
    echo -e "${CYAN}1. Wordlist (rápido)${RESET}"
    echo -e "${CYAN}2. Incremental (lento pero exhaustivo)${RESET}"
    echo ""
    read -p "🎯 Modo [1]: " mode
    
    mode=${mode:-1}
    
    if [[ "$mode" == "1" ]]; then
        run_with_progress "john --wordlist=/tmp/echoutil_wordlist.txt '$hash_file'" "Crackeando con wordlist"
    else
        run_with_progress "john --incremental '$hash_file'" "Crackeando modo incremental"
    fi
}

# Función para mostrar contraseñas crackeadas
show_cracked_passwords() {
    clear_screen
    show_tool_info "CONTRASEÑAS CRACKEADAS" "Muestra las contraseñas descifradas por John"
    echo ""
    
    if command -v john &> /dev/null; then
        echo -e "${CYAN}🔓 Contraseñas encontradas:${RESET}"
        echo ""
        john --show /tmp/echoutil_hashes.txt 2>/dev/null || echo -e "${YELLOW}⚠️  No hay contraseñas crackeadas aún${RESET}"
    else
        echo -e "${RED}❌ John the Ripper no está instalado${RESET}"
    fi
    
    echo ""
    read -p "Presiona Enter para continuar..."
}

# Funciones mejoradas para SQLMap
scan_dbs_with_sqlmap() {
    clear_screen
    show_tool_info "SQLMAP - ENUMERAR BASES DE DATOS" "Lista todas las bases de datos disponibles"
    echo ""
    read -p "🌐 URL objetivo: " url
    
    if [[ -z "$url" ]]; then
        echo -e "${RED}❌ Debes especificar una URL${RESET}"
        sleep 2
        return
    fi
    
    run_with_progress "sqlmap -u '$url' --dbs --batch" "Enumerando bases de datos"
}

scan_tables_with_sqlmap() {
    clear_screen
    show_tool_info "SQLMAP - ENUMERAR TABLAS" "Lista todas las tablas de una base de datos específica"
    echo ""
    read -p "🌐 URL objetivo: " url
    read -p "🗄️  Base de datos: " db
    
    if [[ -z "$url" || -z "$db" ]]; then
        echo -e "${RED}❌ Debes especificar URL y base de datos${RESET}"
        sleep 2
        return
    fi
    
    run_with_progress "sqlmap -u '$url' -D '$db' --tables --batch" "Enumerando tablas de $db"
}

scan_columns_with_sqlmap() {
    clear_screen
    show_tool_info "SQLMAP - ENUMERAR COLUMNAS" "Lista todas las columnas de una tabla específica"
    echo ""
    read -p "🌐 URL objetivo: " url
    read -p "🗄️  Base de datos: " db
    read -p "📋 Tabla: " table
    
    if [[ -z "$url" || -z "$db" || -z "$table" ]]; then
        echo -e "${RED}❌ Debes especificar URL, base de datos y tabla${RESET}"
        sleep 2
        return
    fi
    
    run_with_progress "sqlmap -u '$url' -D '$db' -T '$table' --columns --batch" "Enumerando columnas de $table"
}

dump_data_with_sqlmap() {
    clear_screen
    show_tool_info "SQLMAP - DUMP DE DATOS" "Extrae todos los datos de una tabla específica"
    echo ""
    echo -e "${RED}⚠️  ADVERTENCIA: Esta operación puede ser destructiva${RESET}"
    echo -e "${YELLOW}Solo úsala en sistemas que tengas autorización para probar${RESET}"
    echo ""
    read -p "🌐 URL objetivo: " url
    read -p "🗄️  Base de datos: " db
    read -p "📋 Tabla: " table
    
    if [[ -z "$url" || -z "$db" || -z "$table" ]]; then
        echo -e "${RED}❌ Debes especificar URL, base de datos y tabla${RESET}"
        sleep 2
        return
    fi
    
    echo ""
    read -p "¿Estás seguro? (s/N): " confirm
    
    if [[ "$confirm" =~ ^[Ss]$ ]]; then
        run_with_progress "sqlmap -u '$url' -D '$db' -T '$table' --dump --batch" "Extrayendo datos de $table"
    else
        echo -e "${YELLOW}Operación cancelada${RESET}"
        sleep 1
    fi
}

# Funciones mejoradas para Hydra
brute_force_ssh_with_hydra() {
    clear_screen
    show_tool_info "HYDRA - FUERZA BRUTA SSH" "Ataque de fuerza bruta contra servicio SSH"
    echo ""
    echo -e "${RED}⚠️  ADVERTENCIA: Uso solo con autorización explícita${RESET}"
    echo ""
    read -p "🌐 IP objetivo: " target
    read -p "👤 Usuario objetivo [admin]: " user
    read -p "📝 Archivo wordlist [/tmp/echoutil_wordlist.txt]: " wordlist
    
    user=${user:-admin}
    wordlist=${wordlist:-/tmp/echoutil_wordlist.txt}
    
    if [[ -z "$target" ]]; then
        echo -e "${RED}❌ Debes especificar un objetivo${RESET}"
        sleep 2
        return
    fi
    
    if [[ ! -f "$wordlist" ]]; then
        echo -e "${YELLOW}⚠️  Wordlist no encontrada, generando una básica...${RESET}"
        generate_wordlist
        wordlist="/tmp/echoutil_wordlist.txt"
    fi
    
    run_with_progress "hydra -l '$user' -P '$wordlist' -t 4 ssh://'$target'" "Atacando SSH en $target"
}

brute_force_ftp_with_hydra() {
    clear_screen
    show_tool_info "HYDRA - FUERZA BRUTA FTP" "Ataque de fuerza bruta contra servicio FTP"
    echo ""
    echo -e "${RED}⚠️  ADVERTENCIA: Uso solo con autorización explícita${RESET}"
    echo ""
    read -p "🌐 IP objetivo: " target
    read -p "👤 Usuario objetivo [admin]: " user
    read -p "📝 Archivo wordlist [/tmp/echoutil_wordlist.txt]: " wordlist
    
    user=${user:-admin}
    wordlist=${wordlist:-/tmp/echoutil_wordlist.txt}
    
    if [[ -z "$target" ]]; then
        echo -e "${RED}❌ Debes especificar un objetivo${RESET}"
        sleep 2
        return
    fi
    
    if [[ ! -f "$wordlist" ]]; then
        echo -e "${YELLOW}⚠️  Wordlist no encontrada, generando una básica...${RESET}"
        generate_wordlist
        wordlist="/tmp/echoutil_wordlist.txt"
    fi
    
    run_with_progress "hydra -l '$user' -P '$wordlist' -t 4 ftp://'$target'" "Atacando FTP en $target"
}

brute_force_http_with_hydra() {
    clear_screen
    show_tool_info "HYDRA - FUERZA BRUTA HTTP" "Ataque de fuerza bruta contra formularios web"
    echo ""
    echo -e "${RED}⚠️  ADVERTENCIA: Uso solo con autorización explícita${RESET}"
    echo ""
    read -p "🌐 IP/URL objetivo: " target
    read -p "📄 Ruta del formulario [/login]: " path
    read -p "👤 Usuario objetivo [admin]: " user
    read -p "📝 Archivo wordlist [/tmp/echoutil_wordlist.txt]: " wordlist
    
    path=${path:-/login}
    user=${user:-admin}
    wordlist=${wordlist:-/tmp/echoutil_wordlist.txt}
    
    if [[ -z "$target" ]]; then
        echo -e "${RED}❌ Debes especificar un objetivo${RESET}"
        sleep 2
        return
    fi
    
    if [[ ! -f "$wordlist" ]]; then
        echo -e "${YELLOW}⚠️  Wordlist no encontrada, generando una básica...${RESET}"
        generate_wordlist
        wordlist="/tmp/echoutil_wordlist.txt"
    fi
    
    run_with_progress "hydra -l '$user' -P '$wordlist' -t 4 '$target' http-post-form '$path:username=^USER^&password=^PASS^:F=incorrect'" "Atacando formulario HTTP en $target$path"
}

# Funciones adicionales para Netcat
transfer_file_with_netcat() {
    clear_screen
    show_tool_info "NETCAT - TRANSFERENCIA DE ARCHIVOS" "Envía o recibe archivos a través de la red"
    echo ""
    echo -e "${YELLOW}Opciones:${RESET}"
    echo -e "${CYAN}1. Enviar archivo${RESET}"
    echo -e "${CYAN}2. Recibir archivo${RESET}"
    echo ""
    read -p "🔢 Selecciona opción [1]: " option
    
    option=${option:-1}
    
    if [[ "$option" == "1" ]]; then
        read -p "📁 Archivo a enviar: " file
        read -p "🌐 IP destino: " host
        read -p "🚪 Puerto: " port
        
        if [[ ! -f "$file" ]]; then
            echo -e "${RED}❌ Archivo no encontrado: $file${RESET}"
            sleep 2
            return
        fi
        
        echo -e "${CYAN}📤 Enviando $file a $host:$port${RESET}"
        echo -e "${YELLOW}El receptor debe estar escuchando con: nc -l -p $port > archivo_recibido${RESET}"
        echo ""
        nc "$host" "$port" < "$file"
        
    else
        read -p "🚪 Puerto para escuchar: " port
        read -p "📁 Archivo donde guardar: " output_file
        
        echo -e "${CYAN}📥 Esperando archivo en puerto $port${RESET}"
        echo -e "${YELLOW}El emisor debe enviar con: nc $HOSTNAME $port < archivo${RESET}"
        echo ""
        nc -l -p "$port" > "$output_file"
        echo -e "${GREEN}✅ Archivo guardado como: $output_file${RESET}"
    fi
    
    echo ""
    read -p "Presiona Enter para continuar..."
}

port_scan_with_netcat() {
    clear_screen
    show_tool_info "NETCAT - PORT SCANNER" "Escaneo básico de puertos usando Netcat"
    echo ""
    read -p "🌐 IP objetivo: " target
    read -p "🚪 Puerto inicial [1]: " start_port
    read -p "🚪 Puerto final [1000]: " end_port
    
    start_port=${start_port:-1}
    end_port=${end_port:-1000}
    
    if [[ -z "$target" ]]; then
        echo -e "${RED}❌ Debes especificar un objetivo${RESET}"
        sleep 2
        return
    fi
    
    echo -e "${CYAN}🔍 Escaneando puertos $start_port-$end_port en $target${RESET}"
    echo ""
    
    local open_ports=()
    for port in $(seq "$start_port" "$end_port"); do
        if nc -z -v -w1 "$target" "$port" 2>/dev/null; then
            echo -e "${GREEN}✅ Puerto $port abierto${RESET}"
            open_ports+=("$port")
        else
            echo -n -e "${RED}.${RESET}"
        fi
        
        # Mostrar progreso cada 50 puertos
        if (( port % 50 == 0 )); then
            echo -e " ${YELLOW}[$port/$end_port]${RESET}"
        fi
    done
    
    echo ""
    echo -e "${CYAN}${BOLD}📋 RESUMEN:${RESET}"
    if [[ ${#open_ports[@]} -eq 0 ]]; then
        echo -e "${YELLOW}No se encontraron puertos abiertos${RESET}"
    else
        echo -e "${GREEN}Puertos abiertos: ${open_ports[*]}${RESET}"
    fi
    
    echo ""
    read -p "Presiona Enter para continuar..."
}

# Función para mostrar información del sistema
show_system_info() {
    clear_screen
    echo -e "${GREEN}${BOLD}"
    echo "╔══════════════════════════════════════════════════════════════╗"
    echo "║                    INFORMACIÓN DEL SISTEMA                   ║"
    echo "╚══════════════════════════════════════════════════════════════╝"
    echo -e "${RESET}"
    echo ""
    
    echo -e "${CYAN}🖥️  Sistema operativo:${RESET} $(uname -o 2>/dev/null || echo "Desconocido")"
    echo -e "${CYAN}🏗️  Arquitectura:${RESET} $(uname -m)"
    echo -e "${CYAN}🐧 Kernel:${RESET} $(uname -r)"
    echo -e "${CYAN}👤 Usuario actual:${RESET} $(whoami)"
    echo -e "${CYAN}🏠 Directorio home:${RESET} $HOME"
    echo -e "${CYAN}🌐 IP local:${RESET} $(hostname -I 2>/dev/null | awk '{print $1}' || echo "No disponible")"
    
    if [[ "$SYSTEM" == "termux" ]]; then
        echo -e "${CYAN}📱 Entorno:${RESET} Termux (Android)"
        echo -e "${CYAN}📦 Gestor de paquetes:${RESET} pkg"
    else
        echo -e "${CYAN}💻 Entorno:${RESET} Linux/WSL"
        echo -e "${CYAN}📦 Gestor de paquetes:${RESET} apt"
    fi
    
    echo ""
    echo -e "${YELLOW}🔧 Herramientas instaladas:${RESET}"
    
    local tools=("nmap" "nc" "sqlmap" "hydra" "john")
    for tool in "${tools[@]}"; do
        if command -v "$tool" &> /dev/null; then
            echo -e "${GREEN}  ✅ $tool${RESET}"
        else
            echo -e "${RED}  ❌ $tool${RESET}"
        fi
    done
    
    echo ""
    read -p "Presiona Enter para continuar..."
}

# Función principal mejorada
main() {
    detect_system
    show_matrix_animation
    
    while true; do
        show_main_menu
        echo -e "${GREEN}${BOLD}┌─────────────────────────────────────────────────────────────┐${RESET}"
        echo -e "${GREEN}${BOLD}│ ${WHITE}Selecciona una opción: ${RESET}                                  ${GREEN}${BOLD}│${RESET}"
        echo -e "${GREEN}${BOLD}└─────────────────────────────────────────────────────────────┘${RESET}"
        read -p "🎯 Opción: " choice

        case $choice in
            1)
                while true; do
                    show_nmap_menu
                    read -p "🎯 Opción: " nmap_choice

                    case $nmap_choice in
                        1) scan_ports_with_nmap ;;
                        2) scan_services_with_nmap ;;
                        3) scan_os_with_nmap ;;
                        4) scan_version_with_nmap ;;
                        5) comprehensive_scan_nmap ;;
                        0) break ;;
                        *) 
                            echo -e "${RED}❌ Opción no válida${RESET}"
                            sleep 1
                            ;;
                    esac
                done
                ;;
            2)
                while true; do
                    show_netcat_menu
                    read -p "🎯 Opción: " netcat_choice

                    case $netcat_choice in
                        1) connect_with_netcat ;;
                        2) listen_with_netcat ;;
                        3) transfer_file_with_netcat ;;
                        4) port_scan_with_netcat ;;
                        0) break ;;
                        *) 
                            echo -e "${RED}❌ Opción no válida${RESET}"
                            sleep 1
                            ;;
                    esac
                done
                ;;
            3)
                while true; do
                    show_sqlmap_menu
                    read -p "🎯 Opción: " sqlmap_choice

                    case $sqlmap_choice in
                        1) scan_dbs_with_sqlmap ;;
                        2) scan_tables_with_sqlmap ;;
                        3) scan_columns_with_sqlmap ;;
                        4) dump_data_with_sqlmap ;;
                        5) basic_sqlmap_detection ;;
                        0) break ;;
                        *) 
                            echo -e "${RED}❌ Opción no válida${RESET}"
                            sleep 1
                            ;;
                    esac
                done
                ;;
            4)
                while true; do
                    show_hydra_menu
                    read -p "🎯 Opción: " hydra_choice

                    case $hydra_choice in
                        1) brute_force_ssh_with_hydra ;;
                        2) brute_force_ftp_with_hydra ;;
                        3) brute_force_http_with_hydra ;;
                        4) generate_wordlist ;;
                        0) break ;;
                        *) 
                            echo -e "${RED}❌ Opción no válida${RESET}"
                            sleep 1
                            ;;
                    esac
                done
                ;;
            5)
                while true; do
                    show_john_menu
                    read -p "🎯 Opción: " john_choice

                    case $john_choice in
                        1) crack_passwords_with_john ;;
                        2) show_cracked_passwords ;;
                        3) generate_test_hashes ;;
                        0) break ;;
                        *) 
                            echo -e "${RED}❌ Opción no válida${RESET}"
                            sleep 1
                            ;;
                    esac
                done
                ;;
            6) install_dependencies ;;
            9) show_system_info ;;
            0) 
                clear_screen
                echo -e "${GREEN}${BOLD}"
                echo "╔══════════════════════════════════════════════════════════════╗"
                echo "║                        ¡HASTA LUEGO!                        ║"
                echo "║                                                              ║"
                echo "║              Gracias por usar ECHOtool                      ║"
                echo "║                Creado por el grupo ECHO   V1.0                  ║"
                echo "║                                                              ║"
                echo "║            🔒 Úsalo de manera ética y responsable 🔒        ║"
                echo "╚══════════════════════════════════════════════════════════════╝"
                echo -e "${RESET}"
                exit 0 
                ;;
            *) 
                echo -e "${RED}❌ Opción no válida. Inténtalo de nuevo.${RESET}"
                sleep 1
                ;;
        esac
    done
}

# Ejecutar función principal
main "$@"