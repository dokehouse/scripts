#!/bin/bash
set -euo pipefail

# validate ssh public key
validate_ssh_key() {
    local key="$1"
    ssh-keygen -l -f <(echo "$key") &>/dev/null
    return $?
}

# setup ssh directory
SSH_DIR="/root/.ssh"
mkdir -p "$SSH_DIR"
chmod 700 "$SSH_DIR"

# get ssh key from user
gum style --foreground 212 "enter your ssh public key:"
SSH_KEY=$(gum input --width 80 --placeholder "ssh-rsa AAAA...")

# validate key
if ! validate_ssh_key "$SSH_KEY"; then
    gum log --level error "invalid ssh public key"
    exit 1
fi

# add key to authorized_keys
echo "$SSH_KEY" >> "$SSH_DIR/authorized_keys"
chmod 600 "$SSH_DIR/authorized_keys"

# download and apply sshd config
gum spin --spinner dot --title "applying ssh configuration..." -- \
    curl -sSL "https://scripts.doke.house/config/sshd_config" -o "/etc/ssh/sshd_config"

chmod 600 /etc/ssh/sshd_config

# restart ssh service
gum spin --spinner dot --title "restarting ssh service..." -- \
    systemctl restart ssh.service

gum style --foreground 212 "ssh configuration complete!"

