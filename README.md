# Attack Framework

> ⚠️ **Development Status**: This framework is in early development. Expect breaking changes and partial functionality while this banner is present.

This framework will establish a modular ecosystem for integrating offensive security tools with modern AI and data infrastructure.

---

## Table of Contents

- [Quick Start](#quick-start)
  - [Clone the repo](#clone-the-repo)
  - [Review or adjust environment config](#review-or-adjust-environment-config)
  - [Ensure prereqs are installed](#ensure-prereqs-are-installed)
  - [View Make options and start the Docker stack](#view-make-options-and-start-the-docker-stack)
- [Ideas and Feedback](#ideas-and-feedback)
- [License](#license)

---


## Quick Start

### Clone the repo

```
git clone https://github.com/attackframework/attackframework.git
cd attackframework
```

### Review or adjust environment config

- View and edit the .env file.
- Ensure to update DATA_VOLUME_ROOT. This is where persistent data and logs will be stored. Keep it outside of this repo's root.

### Ensure prereqs are installed

#### Docker

Ubuntu/Debian:
- Docs: https://docs.docker.com/engine/install/ubuntu/
- Note testing is done using the Official packages below, not Ubuntu/Debian releases.
```shell
# Remove distro-provided Docker packages if present (safe if not installed)
sudo apt-get remove -y docker docker-engine docker.io containerd runc 2>/dev/null || true
sudo apt-get autoremove -y

# Prereqs
sudo apt-get update
sudo apt-get install -y ca-certificates curl gnupg

# Add Docker’s official GPG key
sudo install -m 0755 -d /etc/apt/keyrings
sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
sudo chmod a+r /etc/apt/keyrings/docker.asc

# Add Docker’s official apt repo
echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
$(. /etc/os-release && echo "$VERSION_CODENAME") stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

# Install Docker Engine + Compose v2 plugin
sudo apt-get update
sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

# Verify
sudo docker --version
sudo docker compose version
```

Linux: https://docs.docker.com/desktop/setup/install/linux/

Windows: https://docs.docker.com/desktop/setup/install/windows-install/

#### Make 

Nix

```shell
# Ubuntu/Debian
sudo apt update
sudo apt install make

# Fedora/RHEL
sudo dnf install make

# Arch Linux
sudo pacman -S make

# macOS
xcode-select --install make
```

Windows

https://chocolatey.org/install

Install choco via admin PowerShell
```powershell
Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))
```

https://community.chocolatey.org/packages/make

```powershell
choco install make
```

### Configure the environment
1. Edit .env file.
2. Likely, you'll want to modify the DATA_VOLUME_ROOT variable. This is where persistent data and logs will be stored.
3. Consider adjusting the OPENSEARCH_JAVA_OPTS variable to manage heap size.
4. The remaining defaults should be fine in most cases.

### View Make options and start the Docker stack

```
cd attackframework
make
sudo make docker-up
```

## Ideas and Feedback

We welcome ideas, feedback, and pull requests. Feel free to open a discussion, issue, or submit a PR.

## License

This project is licensed under the [MIT License](LICENSE).