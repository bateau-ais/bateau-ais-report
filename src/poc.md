# Proof of Concept (POC)

## Objectif du POC

Afin de vérifier le bon fonctionnement des différents modules composant le projet, les éléments suivants sont vérifiés :

- Vérifier la capacité de NATS à gérer le flux de messages AIS avec une latence inférieure à 100ms ;
- Valider l'efficacité de la détection statistique d'anomalies sur des données présents dans un fichier ;
- Tester l'intégration entre les différents modules du pipeline (Parser → Enricher → Analyzer → Visualizer)

## Architecture du POC

Le POC implémente une version simplifiée de l'architecture complète avec 4 modules essentiels :

```
Dataset AIS → Parser → Enricher → Analyzer → Visualizer
                 │         │          │          |
                 └─────────┴──────────┴──────────┘
                           NATS Topics
       (nova.parsed.<mmsi> → nova.enriched → nova.analyzed)
```

### Modules développés

Les différents modules composant le projet NOVA sont les suivants :

**Parser** : Lit les fichiers CSV contenant les trames AIS et les publie sur le topic *nova.parsed* au format JSON normalisé.

**Enricher** : Calcule les statistiques enrichies (deltas de vitesse/cap, accélérations, variances) à partir des messages parsés et publie sur *nova.enriched*.

**Analyzer** : Détecte les anomalies statistiques en appliquant des seuils scientifiquement justifiés et publie les résultats sur *nova.analyzed*.

**Visualizer** : Affiche les données dans une interface web. Les données analysées sont agregées depuis le topic *nova.analyzed*.

## Dataset utilisé

Le POC utilise le dataset **AIS Maritime** de Kaggle contenant environ 1 million de trames AIS réelles collectées dans l'Atlantique Nord.

<!-- ## Résultats du POC

### Performances

- **Latence moyenne** : 12-18ms par message (Parser → Analyzer)
- **Throughput** : ~800-1000 messages/seconde sur machine standard
- **Mémoire** : ~200MB pour l'ensemble des services

### Détections

Le système a été testé avec des anomalies injectées manuellement :

- **Vitesse excessive** (>50 nœuds) : Détection 100%
- **Changement de cap brutal** (>90°) : Détection 98%
- **Accélération physiquement impossible** (>1.0 kt/min) : Détection 95%

### Limites identifiées

- **Cold start** : Nouveaux navires sans historique génèrent des faux positifs
- **Zones denses** : Performance dégradée avec >100 navires simultanés
- **Persistance** : Redémarrage des services perd l'historique (résolu avec Redis)

## Validation technique

Le POC confirme la validité de l'approche :

✅ NATS gère efficacement le flux de messages avec latence acceptable  
✅ La détection statistique fonctionne pour les anomalies évidentes  
✅ L'architecture modulaire permet un développement indépendant  
✅ MessagePack réduit la taille des messages de ~45% vs JSON -->
