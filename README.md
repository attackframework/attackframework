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

## Ideas and Feedback

We welcome ideas, feedback, and pull requests. Feel free to open a discussion, issue, or submit a PR.

## License

This project is licensed under the [MIT License](LICENSE).