# syntax=docker/dockerfile:1

# ============================================================================
# Stage de développement
# ============================================================================
FROM debian:bookworm-slim as dev

WORKDIR /app

# Installation de uv
COPY --from=ghcr.io/astral-sh/uv:latest /uv /usr/local/bin/uv

# Installation des dépendances système
RUN apt-get update && apt-get install -y \
    ca-certificates \
    gcc \
    git \
    && rm -rf /var/lib/apt/lists/*

# Copier les fichiers de configuration Python
COPY pyproject.toml uv.lock* .python-version* ./

# uv gère l'installation de Python et des dépendances
RUN uv sync --all-extras

# Copier le reste du code
COPY . .

# Exposer le port par défaut (à ajuster selon les besoins)
EXPOSE 8080

# Commande par défaut pour le développement
CMD ["uv", "run", "python", "-m", "app.main"]

# ============================================================================
# Stage de production
# ============================================================================
FROM debian:bookworm-slim as prod

WORKDIR /app

# Installation de uv
COPY --from=ghcr.io/astral-sh/uv:latest /uv /usr/local/bin/uv

# Installation des dépendances système minimales
RUN apt-get update && apt-get install -y \
    --no-install-recommends \
    ca-certificates \
    && rm -rf /var/lib/apt/lists/*

# Créer un utilisateur non-root pour la sécurité
RUN useradd -m -u 1000 appuser

# Copier les fichiers de configuration Python
COPY pyproject.toml uv.lock* .python-version* ./

# uv gère l'installation de Python et des dépendances (sans dev)
RUN uv sync --no-dev

# Copier le code applicatif
COPY app ./app

# Changer les permissions
RUN chown -R appuser:appuser /app

# Basculer vers l'utilisateur non-root
USER appuser

# Exposer le port par défaut
EXPOSE 8080

# Commande par défaut pour la production
CMD ["uv", "run", "python", "-m", "app.main"]
