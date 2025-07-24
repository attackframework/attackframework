# Attack Framework

This project sets up a local stack for use by the Attack Framework. A modular ecosystem for integrating offensive security tools with modern AI and data infrastructure.

---

## Quick Start

### Clone the repo

```
git clone https://github.com/attackframework/attackframework.git
cd attackframework
```

### For Git Bash, PowerShell, or WSL users

#### Review or adjust environment config

```
cat .env
vi .env
```

#### Start the stack

```
make up
```

#### Utility commands

```
make down       # Stop all containers
make restart    # Stop then start
make logs       # Tail container logs
make ps         # Show container status
make health     # Check OpenSearch cluster health
make env        # Print environment variables
```

### For Windows cmd.exe users

#### Review the .env file if needed

```
type .env
notepad .env
```

#### Start the stack (OpenSearch + Dashboards)

```
scripts\start.cmd
```

#### To stop the stack

```
docker compose -f opensearch\docker-compose.yml -f opensearch-dashboards\docker-compose.yml down
```

## License

This project is licensed under the [MIT License](LICENSE).