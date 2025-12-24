# Template Module NOVA

Template pour créer un module Python de traitement AIS avec Almanach et NATS.

## Structure

```
├── app/
│   ├── __init__.py
│   └── main.py              # Point d'entrée
├── tests/
├── Dockerfile               # Multi-stage (dev + prod)
├── pyproject.toml
├── .python-version          # Python 3.12
├── docker-compose.yml
└── Makefile
```

## Démarrage Rapide

```bash
# 1. Copier le template
cp -r template/ mon-module/
cd mon-module/

# 2. Installer uv
curl -LsSf https://astral.sh/uv/install.sh | sh

# 3. Configurer
cp .env.example .env

# 4. Lancer avec Docker
docker compose up

# Ou en local
uv sync --all-extras
uv run bateau-ais-module
```

## Configuration

Variables d'environnement (`.env`) :

- `NATS_URL` : Serveur NATS (ex: `tcp://127.0.0.1:4222`)
- `LOG_LEVEL` : `DEBUG`, `INFO`, `WARNING`, `ERROR`
- `TOPIC_INPUT` : Pattern de souscription (ex: `ais.raw.*`)
- `TOPIC_OUTPUT` : Topic de publication (ex: `ais.processed`)

## Utilisation d'Almanach

### Subscribe

```python
NATS_URL = os.getenv("NATS_URL", "tcp://127.0.0.1:4222")
TOPIC = os.getenv("TOPIC_INPUT", "ais.raw.*")

def setup_subscribers():
    url = f"{NATS_URL}/{TOPIC}"
    almanach.subscribe(url)(handle_message)

def handle_message(message: AISPacket):
    logger.info(f"Message: {message.mmsi}")
```

### Publish

```python
from almanach import publish

publish(message, topic="ais.processed")
```

## Développement

```bash
# Installation
uv sync --all-extras

# Tests
make test

# Linting
make lint
make format

# Lancer
make run
uv run bateau-ais-module
```

## Commandes Make

```bash
make sync          # Installer dépendances dev
make install       # Installer dépendances prod
make test          # Tests
make lint          # Linting (ruff + mypy)
make format        # Formatage (ruff)
make run           # Lancer le module
make docker-up     # Docker compose up
```

## Production

```bash
# Build
docker build --target prod -t mon-module .

# Run
docker run -e NATS_URL=tcp://nats:4222 mon-module
```

## Dépendances dev

- **ruff** : Linter & formatteur
- **mypy** : Type checking
- **ipython** : REPL
- **pytest** : Tests
