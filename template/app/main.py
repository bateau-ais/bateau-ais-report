"""Point d'entrée principal du module AIS."""

import logging
from typing import Optional

from almanach import Almanach, publish
from almanach.types import AISPacket
from pydantic import BaseModel

# Configuration du logging
logging.basicConfig(
    level=logging.INFO,
    format="%(asctime)s - %(name)s - %(levelname)s - %(message)s"
)
logger = logging.getLogger(__name__)


# Initialisation d'Almanach avec métadonnées du package
try:
    from importlib.metadata import metadata
    meta = metadata(__package__ or __name__.split(".")[0])
    almanach = Almanach(meta["Name"], meta["Version"])
except Exception:
    # Fallback si les métadonnées ne sont pas disponibles
    almanach = Almanach("bateau-ais-module", "0.1.0")


# ============================================================================
# Exemple de fonction subscribe
# ============================================================================
@almanach.subscribe("tcp://127.0.0.1:4222/ais.raw.*")
def handle_raw_ais(message: AISPacket) -> None:
    """
    Traite les messages AIS bruts reçus sur le topic ais.raw.*.

    Args:
        message: Paquet AIS reçu depuis NATS
    """
    logger.info(f"Message AIS reçu: MMSI={message.mmsi}")

    # Exemple de traitement métier
    processed_message = process_ais_message(message)

    # Publication du message traité
    if processed_message:
        publish(processed_message, topic="ais.processed")


@almanach.subscribe("tcp://127.0.0.1:4222/ais.processed.*")
def handle_processed_ais(message: AISPacket) -> None:
    """
    Traite les messages AIS déjà traités.

    Args:
        message: Paquet AIS traité
    """
    logger.info(f"Message AIS traité reçu: MMSI={message.mmsi}")

    # Logique métier supplémentaire (détection d'anomalies, etc.)
    detect_anomalies(message)


# ============================================================================
# Logique métier
# ============================================================================
def process_ais_message(message: AISPacket) -> Optional[AISPacket]:
    """
    Traite un message AIS brut.

    Args:
        message: Message AIS brut

    Returns:
        Message AIS traité ou None si le message est invalide
    """
    try:
        # TODO: Implémenter la logique de traitement
        # Exemple: validation, enrichissement, calcul de vitesse, etc.

        logger.debug(f"Traitement du message MMSI={message.mmsi}")

        # Pour l'instant, on retourne le message tel quel
        return message

    except Exception as e:
        logger.error(f"Erreur lors du traitement du message: {e}")
        return None


def detect_anomalies(message: AISPacket) -> None:
    """
    Détecte les anomalies dans les messages AIS.

    Args:
        message: Message AIS à analyser
    """
    try:
        # TODO: Implémenter la logique de détection d'anomalies
        # Exemple: vitesse anormale, changement de cap suspect, etc.

        logger.debug(f"Analyse du message MMSI={message.mmsi} pour anomalies")

        # Exemple basique: vérifier si la vitesse est réaliste
        # if message.speed > 50:  # Plus de 50 nœuds
        #     logger.warning(f"Vitesse anormale détectée: {message.speed} nœuds")
        #     publish(create_alert(message), topic="alerts.speed")

    except Exception as e:
        logger.error(f"Erreur lors de la détection d'anomalies: {e}")


def create_alert(message: AISPacket) -> BaseModel:
    """
    Crée une alerte à partir d'un message AIS.

    Args:
        message: Message AIS source

    Returns:
        Alerte formatée
    """
    # TODO: Définir le schéma d'alerte et l'implémenter
    # Pour l'instant, retourne le message tel quel
    return message


# ============================================================================
# Point d'entrée
# ============================================================================
def main() -> None:
    """Point d'entrée principal du module."""
    logger.info("Démarrage du module AIS")

    try:
        # Démarrer l'écoute des messages
        # Note: almanach.subscribe est un décorateur, l'écoute démarre
        # automatiquement quand les fonctions sont définies

        logger.info("Module AIS démarré avec succès")
        logger.info("En attente de messages...")

        # Garder le processus actif
        # TODO: Implémenter une boucle d'événements appropriée
        # ou utiliser la méthode fournie par Almanach pour bloquer
        import time
        while True:
            time.sleep(1)

    except KeyboardInterrupt:
        logger.info("Arrêt du module AIS (KeyboardInterrupt)")
    except Exception as e:
        logger.error(f"Erreur fatale: {e}", exc_info=True)
        raise


if __name__ == "__main__":
    main()
