# Travaux futurs envisageables

## 1. Détection LSTM de trajectoires anormales

### Motivation

L'approche actuelle (statistique + détection de spoofing basique) fonctionne bien pour les anomalies **évidentes** (téléportation, vitesses impossibles), mais échoue sur des patterns **subtils** :

- Spoofing GPS sophistiqué qui respecte les contraintes physiques
- Comportements légèrement déviants mais statistiquement normaux
- Patterns temporels complexes (trajectoires en spirale, loitering)

### Approche proposée

**Principe** : Entraîner un LSTM encoder-decoder sur trajectoires **normales** uniquement. Les trajectoires anormales auraient une haute erreur de reconstruction.

```
Séquence 20 msg AIS → LSTM Encoder → Latent → LSTM Decoder → Reconstruction
                                         ↓
                            Erreur > seuil ? → Anomalie
```

### Architecture technique

- **Input** : Séquence de 20 messages AIS (lon, lat, sog, cog, timestamp)
- **Encoder** : 2 couches LSTM (128 units) → Latent vector (64D)
- **Decoder** : 2 couches LSTM (128 units) → Reconstruction de la séquence
- **Loss** : MSE (Mean Squared Error) entre input et reconstruction
- **Seuil d'anomalie** : 95e percentile de l'erreur sur dataset de validation

### Dataset d'entraînement

- **Taille nécessaire** : >10,000 trajectoires normales (validation manuelle)
- **Prétraitement** : Normalisation des coordonnées, interpolation temporelle
- **Validation** : Cross-validation 80/20 pour calibrer seuil

### Intégration dans NOVA

Créer un module **Analyzer-LSTM** parallèle à **Analyzer-Stat** :

```
                     ┌→ Analyzer-Stat → nova.analyzed.stat
Enricher → Enriched ─┤
                     └→ Analyzer-LSTM → nova.analyzed.lstm
                                              ↓
                          Fusioner corrèle via data_id
```

### Avantages / Inconvénients

**Avantages** :
- Détecte spoofing sophistiqué (respecte contraintes physiques mais anormal)
- Apprend patterns temporels complexes
- Adaptable par type de navire (modèles spécialisés)

**Inconvénients** :
- Nécessite large dataset validé (\u003e10k trajectoires)
- Coût computationnel (~10-50ms inference vs <5ms statistique)
- Maintenance (ré-entraînement périodique)

**Effort estimé** : 1-2 semaines (hors scope actuel)

**Références** :
- Liu et al. (2019) - "Deep Learning for AIS Trajectory Prediction"
- Zhou et al. (2020) - "Fishing Vessel Behaviour Prediction using LSTM"

---

## 2. Seuils adaptatifs par type de navire

### Problème actuel

Les seuils sont **fixes** et ne tiennent pas compte du type de navire :

- Un cargo à 25 nœuds est anormal
- Une vedette rapide à 35 nœuds est normal
- Un tanker à 18 nœuds est à sa vitesse max

→ **Résultat** : Faux positifs sur navires rapides, faux négatifs sur navires lents

### Solution proposée

Utiliser le champ `vessel_type` (AIS type code) pour appliquer des seuils adaptés :

| Type navire | Code AIS | Vitesse max | Seuil accélération |
|-------------|----------|-------------|-------------------|
| Cargo | 70-79 | 25 kt | 0.8 kt/min |
| Tanker | 80-89 | 18 kt | 0.6 kt/min |
| Passenger | 60-69 | 35 kt | 1.2 kt/min |
| High-speed craft | 40-49 | 50 kt | 1.5 kt/min |
| Fishing | 30 | 20 kt | 1.0 kt/min |

### Implémentation

Modifier `analyzer/constants.py` :

```python
VESSEL_TYPE_THRESHOLDS = {
    "cargo": {"max_speed": 25.0, "max_accel": 0.8},
    "tanker": {"max_speed": 18.0, "max_accel": 0.6},
    # ...
}
```

Adapter `statistical_model.py` pour sélectionner seuils dynamiquement :

```python
vessel_category = get_vessel_category(msg.vessel_type)
threshold = VESSEL_TYPE_THRESHOLDS[vessel_category]
```

**Effort estimé** : 2-3 jours

---

## 3. Intégration données météorologiques

### Problème actuel

Les **conditions météo** ne sont pas prises en compte :

- Tempête → vitesse erratique légitime
- Fort courant → cap dévié normal
- Vent de travers → accélération apparente

→ **Résultat** : Faux positifs en conditions météo extrêmes

### Solution proposée

Enrichir les trames AIS avec données météo en temps réel (API OpenWeather, Météo France) :

- **Vitesse du vent** (nœuds)
- **État de la mer** (Douglas scale 0-9)
- **Courants marins** (vitesse/direction)

### Ajustement des seuils

Modifier les seuils en fonction des conditions :

```python
if wind_speed > 30:  # Tempête
    heading_variance_threshold *= 1.5  # Tolérer plus de zigzag
    acceleration_threshold *= 1.3
```

### Architecture

Ajouter un module **Weather-Enricher** entre Parser et Enricher :

```
Parser → Weather-Enricher → Enricher → Analyzer
           ↓
      API Météo
```

**Effort estimé** : 1 semaine

---

## 4. Optimisation performances zones denses

### Problème actuel

Performance dégradée avec \u003e100 navires simultanés :
- Latence monte à 80-120ms
- Throughput chute à ~400 msg/s

**Cause** : Enricher maintient historique de tous les navires en cache

### Solutions proposées

#### A. Sharding Redis par zone géographique

Partitionner Redis en zones :

```
Zone Atlantique Nord → Redis:6379
Zone Méditerranée   → Redis:6380
Zone Manche         → Redis:6381
```

→ Chaque Enricher ne gère qu'une zone

**Effort estimé** : 3-4 jours

#### B. Compression historique

Au lieu de stocker toutes les trames, stocker uniquement :
- Moyenne glissante
- Variance
- N dernières trames (ex: 10)

→ Réduit mémoire de ~70%

**Effort estimé** : 2 jours

#### C. Parallel processing avec NATS JetStream

Activer JetStream pour paralléliser le traitement :

```
Enricher-1 (workers 1-4) ─┐
Enricher-2 (workers 5-8) ─┼→ NATS JetStream → Load balancing
Enricher-3 (workers 9-12)─┘
```

**Effort estimé** : 1 semaine

---

## 5. Interface de visualisation avancée

### État actuel

Le module Visualizer est en cours de développement avec une interface web basique.

### Fonctionnalités à développer

**Carte interactive** :
- Affichage temps réel des positions navires
- Heatmap des anomalies par zone
- Trajectoires historiques avec replay
- Filtres par type de navire / sévérité

**Tableau de bord** :
- Alertes en temps réel par sévérité (high/medium/low)
- Métriques système (latence, throughput, taux d'anomalie)
- Graphiques tendances (anomalies/jour, hotspots géographiques)

**Historique** :
- Recherche par MMSI / zone / période
- Export PDF des rapports d'incident
- Annotations manuelles opérateurs

**Technologies** :
- Frontend : Vue.js 3 + Leaflet (cartes)
- Backend : FastAPI (Python)
- WebSocket : Flux temps réel NATS → Frontend

**Effort estimé** : 3-4 semaines

---

## 6. Fusion multi-capteurs

### Extension vers détection hybride

Actuellement, NOVA utilise **uniquement AIS**. Intégrer d'autres sources :

**Radar côtier** :
- Détection navires sans AIS (pêche illégale)
- Corrélation radar/AIS pour détecter AIS falsifié

**Imagerie satellite** (Sentinel-2, Planet) :
- Détection navires "fantômes" (AIS éteint)
- Validation position AIS vs position réelle

**Données VTS** (Vessel Traffic Service) :
- Validation croisée avec données officielles
- Intégration zones réglementées

**Architecture** :

```
AIS → Parser-AIS ─┐
Radar → Parser-Radar ─┼→ Fusion-Module → Analyzer
Satellite → Parser-Sat ─┘
```

**Effort estimé** : 6-8 semaines (projet majeur)

---

## Priorisation recommandée

| Priorité | Travail | Impact | Effort | ROI |
|----------|---------|--------|--------|-----|
| **P0** | Seuils adaptatifs | Élevé | 2-3j | ⭐⭐⭐⭐⭐ |
| **P1** | Optimisation zones denses | Moyen | 1 sem | ⭐⭐⭐⭐ |
| **P1** | Interface visualisation | Élevé | 3 sem | ⭐⭐⭐⭐ |
| **P2** | Intégration météo | Moyen | 1 sem | ⭐⭐⭐ |
| **P3** | LSTM détection | Élevé | 2 sem | ⭐⭐⭐ |
| **P4** | Fusion multi-capteurs | Très élevé | 8 sem | ⭐⭐ |

**Recommandation** : Commencer par **P0** (seuils adaptatifs) pour gains immédiats, puis **P1** (optimisation + visualisation) pour utilisabilité opérationnelle.
