#!/bin/bash
# Script pour créer le template NOVA
# Usage: ./create-template.sh

echo "🚀 Création du template NOVA..."

# Créer les dossiers
mkdir -p app tests

# app/__init__.py
cat > app/__init__.py << 'EOF'
"""Module de traitement AIS pour le système NOVA."""

__version__ = "0.1.0"
EOF

# app/main.py (première partie - à cause de la limite de taille)
cat > app/main.py << 'MAINPY'
"""
Point d'entrée principal du module AIS.

Ce module illustre comment créer un service de traitement de messages AIS
utilisant Almanach pour la communication via NATS.
"""

import logging
import os
import time
from typing import Optional

# python-dotenv charge les variables depuis le fichier .env
from dotenv import load_dotenv
from pydantic import BaseModel

# Almanach fournit l'abstraction pour NATS + MessagePack
from almanach import Almanach, publish
from almanach.types import AISPacket

# ============================================================================
# Configuration depuis variables d'environnement
# ============================================================================
# Charge les variables depuis .env s'il existe
load_dotenv()

# URL du serveur NATS (format: tcp://host:port)
NATS_URL = os.getenv("NATS_URL", "tcp://127.0.0.1:4222")

# Niveau de logging (DEBUG, INFO, WARNING, ERROR)
LOG_LEVEL = os.getenv("LOG_LEVEL", "INFO")

# Pattern de topic NATS pour les messages entrants (ex: ais.raw.*)
TOPIC_INPUT = os.getenv("TOPIC_INPUT", "ais.raw.*")

# Topic NATS pour les messages sortants (ex: ais.processed)
TOPIC_OUTPUT = os.getenv("TOPIC_OUTPUT", "ais.processed")

# ============================================================================
# Configuration du système de logging
# ============================================================================
logging.basicConfig(
    level=getattr(logging, LOG_LEVEL.upper()),  # Convertit "INFO" -> logging.INFO
    format="%(asctime)s - %(name)s - %(levelname)s - %(message)s",
)
logger = logging.getLogger(__name__)

# ============================================================================
# Initialisation d'Almanach
# ============================================================================
# Almanach nécessite le nom et la version du module
try:
    # Récupère les métadonnées depuis pyproject.toml via importlib
    from importlib.metadata import metadata

    meta = metadata(__package__ or __name__.split(".")[0])
    almanach = Almanach(meta["Name"], meta["Version"])
except Exception:
    # Fallback si les métadonnées ne sont pas disponibles
    almanach = Almanach("bateau-ais-module", "0.1.0")


# ============================================================================
# Handlers - Fonctions appelées lors de la réception de messages
# ============================================================================
def handle_raw_ais(message: AISPacket) -> None:
    """
    Handler appelé automatiquement quand un message arrive sur TOPIC_INPUT.

    Ce handler est enregistré via almanach.subscribe() dans setup_subscribers().
    Almanach désérialise automatiquement le message MessagePack en AISPacket.

    Args:
        message: Message AIS désérialisé par Almanach
    """
    logger.info(f"Message AIS reçu: MMSI={message.mmsi}")

    # Traitement métier du message
    processed = process_message(message)

    # Si le traitement a réussi, publier le résultat
    if processed:
        # publish() sérialise automatiquement en MessagePack et envoie via NATS
        publish(processed, topic=TOPIC_OUTPUT)


def process_message(message: AISPacket) -> Optional[AISPacket]:
    """
    Traite un message AIS brut.

    C'est ici que vous implémentez votre logique métier :
    - Validation des données
    - Enrichissement (calcul de vitesse, distance, etc.)
    - Détection d'anomalies
    - Transformation des données

    Args:
        message: Message AIS brut

    Returns:
        Message traité, ou None si invalide/à rejeter
    """
    # TODO: Implémenter votre logique de traitement
    # Exemples possibles :
    # - Valider que message.mmsi est valide
    # - Calculer la vitesse si position a changé
    # - Détecter des anomalies (vitesse > 50 nœuds)
    # - Enrichir avec des données externes

    # Pour l'instant, on retourne le message tel quel
    return message


# ============================================================================
# Setup - Configuration des abonnements NATS
# ============================================================================
def setup_subscribers() -> None:
    """
    Configure les abonnements NATS.

    Construit les URLs complètes et enregistre les handlers.
    Format URL: tcp://host:port/topic.pattern

    Note: On applique le décorateur programmatiquement pour utiliser
    les variables d'environnement (pas possible avec @decorator statique).
    """
    # Construire l'URL complète : tcp://127.0.0.1:4222/ais.raw.*
    input_url = f"{NATS_URL}/{TOPIC_INPUT}"
    logger.info(f"Abonnement: {input_url}")

    # Enregistre handle_raw_ais pour recevoir les messages de input_url
    # Équivalent à: @almanach.subscribe(input_url)
    almanach.subscribe(input_url)(handle_raw_ais)

    # Vous pouvez ajouter d'autres abonnements ici :
    # almanach.subscribe(f"{NATS_URL}/autre.topic")(autre_handler)


# ============================================================================
# Point d'entrée principal
# ============================================================================
def main() -> None:
    """
    Point d'entrée principal du module.

    Workflow:
    1. Afficher la configuration
    2. Configurer les abonnements NATS
    3. Boucle infinie pour garder le processus actif
    4. Gérer l'arrêt propre (Ctrl+C)
    """
    logger.info("=" * 60)
    logger.info(f"Démarrage - NATS: {NATS_URL}")
    logger.info("=" * 60)

    # Enregistrer les handlers NATS
    setup_subscribers()

    logger.info("En attente de messages...")

    try:
        # Boucle infinie pour garder le processus actif
        # Les messages arrivent de manière asynchrone via Almanach
        while True:
            time.sleep(1)
    except KeyboardInterrupt:
        # Arrêt propre quand l'utilisateur fait Ctrl+C
        logger.info("\nArrêt du module")


# Si ce fichier est exécuté directement (pas importé)
if __name__ == "__main__":
    main()
MAINPY

echo "✅ app/main.py créé"
echo ""
echo "📝 Continuez avec les autres fichiers..."
echo "Voulez-vous que je génère le reste ? (Dockerfile, docker-compose.yml, etc.)"
