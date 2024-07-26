#!/bin/bash


ip=$1
MAX_PROCS=100

scan_port() {
    local port=$1
    timeout 1 bash -c "echo '' > /dev/tcp/$ip/$port" 2>/dev/null && echo "[+] Port $port - OPEN"
}

counter=0

for port in $(seq 1 65535); do
    scan_port $port &
    
    ((counter++))

    if [ "$counter" -ge "$MAX_PROCS" ]; then
        wait
        counter=0
    fi
done

wait

