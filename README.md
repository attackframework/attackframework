# Attack Framework

This project sets up a local stack for use by the Attack Framework. A modular ecosystem for integrating offensive security tools with modern AI and data infrastructure.

---

## Quick Start

### Clone the repo

```
git clone https://github.com/attackframework/attackframework.git
cd attackframework
```

### Review or adjust environment config

- View and edit the .env file.
- Ensure to update DATA_VOLUME_ROOT. This is where persistent data and logs will be stored.

### Ensure prereqs are installed

#### Make

Nix

```shell
# Ubuntu/Debian
sudo apt update && sudo apt install make

# Fedora/RHEL
sudo dnf install make

# Arch Linux
sudo pacman -S make

# macOS
xcode-select --install
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

### View Make options and start the Docker stack

```
cd attackframework
make
make docker-up
```

## License

This project is licensed under the [MIT License](LICENSE).