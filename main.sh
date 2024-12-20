#!/bin/bash
set -euo pipefail

# check if running as root
if [ "$EUID" -ne 0 ]; then
    echo "please run as root"
    exit 1
fi

# install gum if not present
install_gum() {
    echo "installing gum..."
    
    # add charm repository
    mkdir -p /etc/apt/keyrings
    curl -fsSL https://repo.charm.sh/apt/gpg.key | gpg --dearmor -o /etc/apt/keyrings/charm.gpg
    echo "deb [signed-by=/etc/apt/keyrings/charm.gpg] https://repo.charm.sh/apt/ * *" > /etc/apt/sources.list.d/charm.list
    
    # install gum
    apt update && apt install -y gum
}

# check for gum
if ! command -v gum &> /dev/null; then
    install_gum
fi

# create temp directory and download scripts
TEMP_DIR=$(mktemp -d)
trap 'rm -rf "$TEMP_DIR"' EXIT

echo "downloading scripts..."
curl -sSL "https://scripts.doke.house/src/ssh.sh" -o "$TEMP_DIR/ssh.sh"
chmod +x "$TEMP_DIR/ssh.sh"

# now we can use gum for the ui
gum style \
    --foreground 212 --border-foreground 212 --border double \
    --align center --width 50 --margin "1 0" --padding "1 0" \
    'dokehouse scripts' 'scripts.doke.house'

# let user choose scripts
SCRIPTS=$(find "$TEMP_DIR" -name "*.sh" -exec basename {} \;)
CHOSEN_SCRIPTS=$(echo "$SCRIPTS" | gum choose --no-limit --header "select scripts to run")

# run each chosen script
for script in $CHOSEN_SCRIPTS; do
    echo "Running $script..."
    # ensure output is flushed before running script
    exec 1>&1
    bash "$TEMP_DIR/$script"
    
    # check if script failed
    if [ $? -ne 0 ]; then
        gum style --foreground "#f7768e" "❌ $script failed"
        exit 1
    fi
done

# ensure output is flushed before final message
exec 1>&1
gum style --foreground 212 "setup complete! 🎉"