# dokehouse

A collection of scripts and utilities for my homelab and servers.

## Usage

```bash
curl -fsSL scripts.doke.house/main.sh | bash
# or
wget -qO- scripts.doke.house/main.sh | bash
```

`scripts.doke.house` is a simple static Cloudflare Pages site that correlates to the root of the repo.

## Scripts

- `main.sh` is the main script that will run all the other scripts.
- `src/ssh.sh` adds inputted public keys to the authorized_keys file and applies `/config/sshd_config`
