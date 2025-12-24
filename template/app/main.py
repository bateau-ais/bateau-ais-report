"""Point d'entrée principal du module AIS."""

import logging
import os
import time
from typing import Optional

from dotenv import load_dotenv
from pydantic import BaseModel

from almanach import Almanach, publish
from almanach.types import AISPacket

# Configuration
load_dotenv()
NATS_URL = os.getenv("NATS_URL", "tcp://127.0.0.1:4222")
LOG_LEVEL = os.getenv("LOG_LEVEL", "INFO")
TOPIC_INPUT = os.getenv("TOPIC_INPUT", "ais.raw.*")
TOPIC_OUTPUT = os.getenv("TOPIC_OUTPUT", "ais.processed")

# Logging
logging.basicConfig(
    level=getattr(logging, LOG_LEVEL.upper()),
    format="%(asctime)s - %(name)s - %(levelname)s - %(message)s",
)
logger = logging.getLogger(__name__)

# Almanach
try:
    from importlib.metadata import metadata

    meta = metadata(__package__ or __name__.split(".")[0])
    almanach = Almanach(meta["Name"], meta["Version"])
except Exception:
    almanach = Almanach("bateau-ais-module", "0.1.0")


# ============================================================================
# Handlers
# ============================================================================
def handle_raw_ais(message: AISPacket) -> None:
    """Traite les messages AIS bruts."""
    logger.info(f"Message AIS reçu: MMSI={message.mmsi}")

    # TODO: Implémenter votre logique métier ici
    processed = process_message(message)

    if processed:
        publish(processed, topic=TOPIC_OUTPUT)


def process_message(message: AISPacket) -> Optional[AISPacket]:
    """Traite un message AIS."""
    # TODO: Implémenter votre logique de traitement
    return message


# ============================================================================
# Setup
# ============================================================================
def setup_subscribers() -> None:
    """Configure les abonnements NATS."""
    input_url = f"{NATS_URL}/{TOPIC_INPUT}"
    logger.info(f"Abonnement: {input_url}")
    almanach.subscribe(input_url)(handle_raw_ais)


def main() -> None:
    """Point d'entrée principal."""
    logger.info("=" * 60)
    logger.info(f"Démarrage - NATS: {NATS_URL}")
    logger.info("=" * 60)

    setup_subscribers()
    logger.info("En attente de messages...")

    try:
        while True:
            time.sleep(1)
    except KeyboardInterrupt:
        logger.info("\nArrêt du module")


if __name__ == "__main__":
    main()
