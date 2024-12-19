#!/bin/bash
set -euo pipefail

# check if running as root
if [ "$EUID" -ne 0 ]; then
    echo "please run as root"
    exit 1
fi

# install gum if not present
install_gum() {
    gum style --border double --padding "1 2" "installing gum..."
    
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

# script directory
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/src"

# get available scripts
SCRIPTS=$(find "$SCRIPT_DIR" -name "*.sh" -exec basename {} \;)

# show header
gum style \
    --foreground 212 --border-foreground 212 --border double \
    --align center --width 50 --margin "1 2" --padding "2 4" \
    'dokehouse setup' 'select scripts to run'

# let user choose scripts
CHOSEN_SCRIPTS=$(echo "$SCRIPTS" | gum choose --no-limit)

# run each chosen script
for script in $CHOSEN_SCRIPTS; do
    gum spin --spinner dot --title "running $script..." -- bash "$SCRIPT_DIR/$script"
done

gum style --foreground 212 "setup complete! 🎉"