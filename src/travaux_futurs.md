# Travaux futurs envisageables

## 1. Détection LSTM de trajectoires anormales

### Motivation

L'approche actuelle (statistique + détection de spoofing basique) fonctionne bien pour les anomalies **évidentes** (téléportation, vitesses impossibles), mais échoue sur des patterns **plus complexes** :

- Spoofing GPS sophistiqué qui respecte les contraintes physiques
- Comportements légèrement déviants mais statistiquement normaux
- Patterns temporels complexes (trajectoires en spirale, loitering)

### Approche proposée

**Principe** : Entraîner un LSTM sur trajectoires **normales** uniquement. Les trajectoires anormales seraient alors détectées.

```
Séquence 20 msg AIS → LSTM Encoder → Latent → LSTM Decoder → Reconstruction
                                         ↓
                            Si erreur > seuil → Anomalie
```

### Dataset d'entraînement

- **Données** : un nombre important de trajectoires exemptes d'anomalies
- **Prétraitement** : Normalisation des coordonnées, interpolation temporelle
- **Validation** : Cross-validation pour calibrer seuil

### Avantages / Inconvénients

**Avantages** :
- Détecte spoofing sophistiqué (respecte contraintes physiques mais anormal)
- Apprend patterns temporels complexes
- Adaptable par type de navire (modèles spécialisés)

**Inconvénients** :
- Nécessite large dataset validé
- Coût computationnel (~10-50ms inférence vs <5ms statistique)
- Maintenance (ré-entraînement périodique)

**Références** :
- Liu et al. (2019) - "Deep Learning for AIS Trajectory Prediction"
- Zhou et al. (2020) - "Fishing Vessel Behaviour Prediction using LSTM"

## 2. Seuils adaptatifs par type de navire

### Problème actuel

Les seuils sont **fixes** et ne tiennent pas compte du type de navire. Par exemple :

- Un cargo à 25 nœuds est anormal ;
- Une vedette rapide à 35 nœuds est normal ;
- Un tanker à 18 nœuds est à sa vitesse max.

Les résultats de la solution peuvent donc comporter des faux-positifs.

### Améliorations possibles

Utiliser le champ relatif au type de navire dans les trames AIS pour adapter les seuils de détection d'anomalies.

Exemple :

| Type navire | Code AIS | Vitesse max | Seuil accélération |
|-------------|----------|-------------|-------------------|
| Cargo | 70-79 | 25 kt | 0.8 kt/min |
| Tanker | 80-89 | 18 kt | 0.6 kt/min |
| Passenger | 60-69 | 35 kt | 1.2 kt/min |
| High-speed craft | 40-49 | 50 kt | 1.5 kt/min |
| Fishing | 30 | 20 kt | 1.0 kt/min |

## 3. Intégration données météorologiques

### Problème actuel

Les **conditions météo** ne sont pas prises en compte. Les éléments tels que la vitesse du vent et sa direction et les courants peuvent entrainer des déviations de cap ainsi que des accélérations.

Ces différents éléments peuvent créer des faux positifs dans notre solution.

### Améliorations possibles

Enrichir les trames AIS avec données météo en temps réel (API OpenWeather, Météo France).

Exemple de données à ajouter :

- **Vitesse du vent** (nœuds)
- **État de la mer** (Douglas scale 0-9)
- **Courants marins** (vitesse/direction)

## 4. Interface de visualisation avancée

### État actuel

Le module Visualizer est en cours de développement avec une interface web basique.

### Améliorations possibles

Les éléments supplémentaires pourront être affichés dans notre interface graphique, permettant ainsi de disposer davantage de contexte et d'améliorer la lecture des informations.

**Carte interactive** :
- Heatmap des anomalies par zone
- Filtres par type de navire / sévérité

**Tableau de bord** :
- Métriques système (latence, throughput, taux d'anomalie)
- Graphiques tendances (anomalies/jour, hotspots géographiques)

**Historique** :
- Recherche par MMSI / zone / période
- Export PDF des rapports d'incident
- Annotations manuelles opérateurs

## 5. Fusion multi-capteurs

### Extension vers détection hybride

Actuellement, NOVA utilise **uniquement AIS**. Une piste d'amélioration du projet est l'utilisation de multiples sources afin de couvrir un maximum de navires. De plus, cela permettrait de détecter des incohérences entre la position déclarée du navire (via AIS) et sa position réelle observée.

**Radar côtier** :
- Détection navires sans AIS
- Corrélation radar/AIS pour détecter AIS falsifié

**Imagerie satellite** :
- Détection navires "fantômes" (AIS éteint)
- Corrélation image satellite/AIS pour détecter AIS falsifié

**Données VTS** (Vessel Traffic Service) :
- Validation croisée avec données officielles
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

**Recommandation** : Commencer par **P0** (seuils adaptatifs) pour gains immédiats, puis **P1** (optimisation + visualisation) pour utilisabilité opérationnelle.
