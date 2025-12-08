# Template de Module NOVA

Ce template fournit une base pour créer un nouveau module Python dans le système NOVA de traitement AIS.

## Structure du Template

```
.
├── app/
│   ├── __init__.py          # Métadonnées du package
│   └── main.py              # Point d'entrée avec exemples subscribe/publish
├── Dockerfile               # Multi-stage Docker (dev + prod)
├── pyproject.toml           # Configuration Python avec almanach
├── docker-compose.yml       # Configuration NATS + module
├── .dockerignore            # Fichiers à exclure du build Docker
└── .gitignore               # Fichiers à exclure de Git
```

## Prérequis

- Python 3.12+
- Docker et Docker Compose
- Bibliothèque `almanach` (dépendance du projet NOVA)

## Démarrage Rapide

### 1. Créer un nouveau module

Copiez ce template dans un nouveau répertoire :

```bash
cp -r template/ mon-nouveau-module/
cd mon-nouveau-module/
```

### 2. Personnaliser le module

Éditez `pyproject.toml` pour changer le nom et la description :

```toml
[project]
name = "mon-nouveau-module"
description = "Description de mon module"
```

### 3. Développement local

#### Option A: Avec Docker Compose (recommandé)

```bash
# Démarre NATS et le module en mode développement
docker compose up
```

#### Option B: Sans Docker

```bash
# Installer les dépendances
pip install -e .[dev]

# Lancer NATS séparément (voir section NATS ci-dessous)

# Lancer le module
python -m app.main
```

### 4. Build production

```bash
# Build de l'image de production
docker build --target prod -t mon-module:latest .

# Lancer le conteneur
docker run -e NATS_URL=nats://localhost:4222 mon-module:latest
```

## Utilisation d'Almanach

### Initialisation

```python
from almanach import Almanach
from importlib.metadata import metadata

meta = metadata(__package__)
almanach = Almanach(meta["Name"], meta["Version"])
```

### Subscribe à un topic

```python
@almanach.subscribe("tcp://127.0.0.1:4222/mon.topic.*")
def handle_message(message: AISPacket) -> None:
    """Traite les messages reçus."""
    print(f"Message reçu: {message}")
```

Formats d'URL supportés :
- `tcp://host:port/topic.pattern`
- `unix:///path/to/socket/topic.pattern` (NotImplementedError pour l'instant)

**Important**: Ne pas appeler `subscribe` deux fois sur la même fonction !

### Publish un message

```python
from almanach import publish
from almanach.types import AISPacket

# Créer un message (doit être un BaseModel Pydantic)
message = AISPacket(mmsi=123456789, ...)

# Publier sur un topic
publish(message, topic="mon.topic.output")
```

### Sérialisation

Les messages sont automatiquement sérialisés en MessagePack :

```python
from almanach import serialize
from pydantic import BaseModel

class MonMessage(BaseModel):
    data: str

# Sérialise en bytes (MessagePack)
serialized = serialize(MonMessage(data="test"))
```

## Configuration NATS

Le fichier `docker-compose.yml` lance NATS avec JetStream activé :

```yaml
services:
  nats:
    image: nats:2.10-alpine
    ports:
      - "4222:4222"  # Connexions clients
      - "8222:8222"  # Monitoring HTTP
```

URL de connexion par défaut : `tcp://127.0.0.1:4222`

### NATS en standalone

```bash
# Installation
docker pull nats:2.10-alpine

# Lancement avec JetStream
docker run -p 4222:4222 -p 8222:8222 nats:2.10-alpine -js -m 8222
```

## Développement

### Tests

```bash
# Installer avec les dépendances de développement
pip install -e .[dev]

# Lancer les tests
pytest

# Avec couverture
pytest --cov=app --cov-report=html
```

### Linting et formatage

```bash
# Formatage avec Black
black app/

# Linting avec Ruff
ruff check app/

# Type checking avec mypy
mypy app/
```

## Architecture du Module

Chaque module suit l'architecture générique NOVA :

1. **Ingestion** : Réception des messages via `@almanach.subscribe`
2. **Traitement** : Logique métier dans les fonctions de traitement
3. **Publication** : Envoi des résultats via `publish()`

```
NATS Topic -> subscribe() -> Traitement -> publish() -> NATS Topic
```

## Exemples de Topics

Conventions de nommage recommandées :

- `ais.raw.*` : Messages AIS bruts
- `ais.processed.*` : Messages traités
- `ais.enriched.*` : Messages enrichis
- `alerts.*` : Alertes détectées
- `analytics.*` : Résultats d'analyse

## Dépannage

### Le module ne reçoit pas de messages

1. Vérifier que NATS est accessible : `curl http://localhost:8222/varz`
2. Vérifier les topics avec `nats` CLI
3. Vérifier les logs du module

### Erreurs de sérialisation

Les messages doivent être des instances de `BaseModel` (Pydantic) pour être sérialisés correctement.

### NotImplementedError pour unix://

Les sockets Unix ne sont pas encore implémentés dans almanach. Utilisez `tcp://` pour l'instant.

## Intégration dans NOVA

Ce module est conçu pour être intégré dans le système NOVA :

1. Ajouter le module comme sous-module Git dans le dépôt NOVA
2. Référencer le module dans le `docker-compose.yml` principal de NOVA
3. Configurer les topics appropriés selon l'architecture globale

## Licence

À définir selon le projet NOVA.
