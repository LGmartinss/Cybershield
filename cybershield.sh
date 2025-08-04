#!/bin/bash

# Cores
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Verifica se o Termux está instalado
check_termux() {
    if [ ! -d "/data/data/com.termux/files/usr" ]; then
        echo -e "${RED}[!] Este script requer o Termux. Por favor, execute no Termux.${NC}"
        exit 1
    fi
}

# Atualiza pacotes
update_packages() {
    echo -e "${YELLOW}[*] Atualizando pacotes...${NC}"
    pkg update -y && pkg upgrade -y
    echo -e "${GREEN}[+] Pacotes atualizados com sucesso!${NC}"
}

# Verifica dependências
check_dependencies() {
    echo -e "${YELLOW}[*] Verificando dependências...${NC}"
    dependencies=("curl" "nmap" "git" "python")
    
    for dep in "${dependencies[@]}"; do
        if ! command -v "$dep" &> /dev/null; then
            echo -e "${BLUE}[>] Instalando $dep...${NC}"
            pkg install -y "$dep"
        fi
    done
    echo -e "${GREEN}[+] Todas dependências estão instaladas!${NC}"
}

# Scanner de rede simples
network_scanner() {
    echo -e "${YELLOW}[*] Escaneando rede...${NC}"
    echo -e "${BLUE}Dispositivos na rede local:${NC}"
    
    # Verifica se o nmap está instalado
    if ! command -v nmap &> /dev/null; then
        pkg install -y nmap
    fi
    
    # Obtém o IP local
    ip=$(ip addr show | grep 'inet ' | grep -v '127.0.0.1' | awk '{print $2}' | cut -d'/' -f1)
    subnet=$(echo "$ip" | cut -d'.' -f1-3)
    
    echo -e "${YELLOW}Scanning subnet: ${subnet}.0/24${NC}"
    nmap -sn "${subnet}.0/24" | grep "Nmap scan" | grep -v "host down"
}

# Teste de velocidade
speed_test() {
    echo -e "${YELLOW}[*] Testando velocidade da internet...${NC}"
    
    # Verifica se o speedtest-cli está instalado
    if ! command -v speedtest-cli &> /dev/null; then
        echo -e "${BLUE}[>] Instalando speedtest-cli...${NC}"
        pip install speedtest-cli
    fi
    
    speedtest-cli --simple
}

# Gerador de QR Code
generate_qrcode() {
    echo -e "${YELLOW}[*] Gerador de QR Code${NC}"
    read -p "Digite o texto ou URL: " qrtext
    
    # Verifica se o qrencode está instalado
    if ! command -v qrencode &> /dev/null; then
        echo -e "${BLUE}[>] Instalando qrencode...${NC}"
        pkg install -y qrencode
    fi
    
    qrencode -t ANSIUTF8 "$qrtext"
    echo -e "${GREEN}[+] QR Code gerado acima!${NC}"
}

# Mostra o menu
show_menu() {
    clear
    echo -e "${RED}"
    echo "   ____      _     ____  _     _ _     _     _ "
    echo "  / ___|   _| |__ | __ )| |__ (_) | __| | __| |"
    echo " | |  | | | | '_ \|  _ \| '_ \| | |/ _\` |/ _\` |"
    echo " | |__| |_| | |_) | |_) | | | | | | (_| | (_| |"
    echo "  \____\__,_|_.__/|____/|_| |_|_|_|\__,_|\__,_|"
    echo -e "${NC}"
    echo -e "${BLUE}          FERRAMENTAS AVANÇADAS PARA TERMUX${NC}"
    echo -e "${YELLOW}==============================================${NC}"
    echo -e "${GREEN}[1]${NC} Atualizar pacotes"
    echo -e "${GREEN}[2]${NC} Verificar dependências"
    echo -e "${GREEN}[3]${NC} Scanner de rede"
    echo -e "${GREEN}[4]${NC} Teste de velocidade"
    echo -e "${GREEN}[5]${NC} Gerador de QR Code"
    echo -e "${GREEN}[6]${NC} Ajuda"
    echo -e "${GREEN}[0]${NC} Sair"
    echo -e "${YELLOW}==============================================${NC}"
}

# Mostra ajuda
show_help() {
    clear
    echo -e "${YELLOW}=== AJUDA ===${NC}"
    echo -e "${BLUE}CyberShield - Ferramentas avançadas para Termux${NC}"
    echo ""
    echo -e "${GREEN}Opções disponíveis:${NC}"
    echo "1) Atualiza todos os pacotes do Termux"
    echo "2) Verifica e instala dependências necessárias"
    echo "3) Escaneia dispositivos na rede local"
    echo "4) Testa a velocidade da sua conexão"
    echo "5) Gera QR Codes a partir de texto/URL"
    echo "6) Mostra esta ajuda"
    echo "0) Sai do programa"
    echo ""
    echo -e "${YELLOW}Pressione qualquer tecla para voltar...${NC}"
    read -n 1 -s
}

# Main
check_termux

while true; do
    show_menu
    read -p "Selecione uma opção: " option
    
    case $option in
        1) update_packages ;;
        2) check_dependencies ;;
        3) network_scanner ;;
        4) speed_test ;;
        5) generate_qrcode ;;
        6) show_help ;;
        0) echo -e "${RED}[*] Saindo...${NC}"; exit 0 ;;
        *) echo -e "${RED}[!] Opção inválida!${NC}"; sleep 1 ;;
    esac
    
    echo ""
    echo -e "${YELLOW}Pressione qualquer tecla para continuar...${NC}"
    read -n 1 -s
done