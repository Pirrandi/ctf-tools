#!/bin/bash


ip=$1
# Número máximo de procesos concurrentes
MAX_PROCS=100

# Función para escanear puertos
scan_port() {
    local port=$1
    timeout 1 bash -c "echo '' > /dev/tcp/$ip/$port" 2>/dev/null && echo "[+] Port $port - OPEN"
}

# Contador de procesos
counter=0

for port in $(seq 1 65535); do
    # Ejecuta la función de escaneo en segundo plano
    scan_port $port &

    # Incrementa el contador
    ((counter++))

    # Si el contador alcanza el máximo, espera a que los procesos terminen
    if [ "$counter" -ge "$MAX_PROCS" ]; then
        wait
        counter=0
    fi
done

# Espera a que todos los procesos restantes terminen
wait

