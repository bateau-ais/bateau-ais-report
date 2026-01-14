# Analyse et évaluation des résultats

## Métriques de performance

### Performances système

Les tests sur le dataset AIS Maritime (1M+ messages) donnent les résultats suivants :

```{=latex}
\onecolumn
```

| Métrique | Valeur | Objectif | Statut |
|----------|--------|----------|--------|
| Latence moyenne (bout-en-bout) | 15-22ms | <100ms | OK |
| Throughput | 850-1100 msg/s | >500 msg/s | OK |
| Mémoire totale | ~350MB | <1GB | OK |
| CPU (moyenne) | 15-25% | <50% | OK |

**Note** : Tests effectués sur machine standard (8 cores, 16GB RAM)

### Performances par module

Voir le Tableau @tbl:analyse_evaluation:perfs-par-module.

L'**Enricher** est le module le plus gourmand en mémoire car il maintient l'historique des navires en cache Redis.

```{=latex}
\twocolumn
```

## Qualité de détection

### Matrice de confusion

Tests sur dataset augmenté avec 500 anomalies injectées manuellement :

Voir le Tableau @tbl:analyse_evaluation:matrice-confusion.

**Métriques de classification** :

- **Précision** : 84.6% (468/553)
- **Rappel** : 93.6% (468/500)
- **F1-score** : 88.9%
- **Taux de faux positifs** : 0.9% (85/9505)

### Analyse par type d'anomalie

```{=latex}
\onecolumn
```

| Type | Détections | Rappel | Faux positifs |
|------|------------|--------|---------------|
| Vitesse excessive (>50kt) | 150/150 | 100% | 0 |
| Téléportation (Δv >30kt) | 142/145 | 97.9% | 2 |
| Changement cap brutal (>90°) | 98/100 | 98% | 15 |
| Accélération excessive | 78/105 | 74.3% | 68 |

**Observations** :

**Excellentes performances** sur anomalies évidentes (vitesse impossible, téléportation)  
**Faux positifs** sur accélération : manœuvres d'urgence légitimes parfois flaggées  
**Faux négatifs** sur accélération : seuil de 1.0 kt/min peut-être trop élevé pour petits navires

```{=latex}
\twocolumn
```

## Limitations identifiées

### 1. Cold start

**Problème** : Nouveaux navires sans historique génèrent des décisions peu fiables (confiance <0.3)

**Impact** : ~12% des messages initiaux marqués comme anomalies alors qu'ils sont normaux

**Solution partielle** : Le champ `is_first_message` dans `EnrichedAISMessage` permet à l'analyzer de réduire le poids des critères statistiques pour les premiers messages

### 2. Zones denses

**Problème** : Performance dégradée en zones à très fort trafic (>100 navires)

**Impact** : Latence peut monter jusqu'à 80-120ms, throughput chute à ~400 msg/s

**Cause** : Enricher doit maintenir l'historique de nombreux navires simultanément

### 3. Seuils rigides

**Problème** : Les seuils sont fixes et ne s'adaptent pas au type de navire

**Impact** : Faux positifs sur petites embarcations (bateaux de pêche, vedettes rapides)

**Exemple** : Un zodiac à 35 nœuds est anormal pour un cargo mais normal pour lui

### 4. Manœuvres d'urgence

**Problème** : Évitement de collision légitime peut déclencher alertes

**Impact** : Accélération/virage brutal détecté alors que conforme à COLREGS

**Taux** : ~8% des faux positifs sont des manœuvres d'urgence

## Pertinence scientifique

### Forces

**Seuils justifiés** : Chaque seuil est sourcé par une publication scientifique ou standard maritime (IMO, COLREGS)

**Transparence** : Décisions explicables avec raisons détaillées (`anomaly_reasons`)

**Reproductibilité** : Code open source, dataset public, seuils documentés

**Temps quasi-réel** : Latence <25ms permet surveillance opérationnelle

### Faiblesses

**Hypothèse gaussienne** : Suppose distribution normale des comportements, peut ne pas tenir pour tous les navires

**Pas de contexte météo** : Tempêtes peuvent fausser les seuils (accélération/vitesse erratique légitime)

**Spoofing GPS sophistiqué** : Détecte les impossibilités physiques mais pas le spoofing qui respecte les contraintes

**Pas de prédiction** : Détection a posteriori uniquement, pas de prévision de trajectoires futures

## Cas d'usage validés

Sur la base des résultats, le système est **recommandé** pour :

**Surveillance côtière** : Détection temps quasi-réel pour investigation humaine  
**Analyse post-incident** : Reconstruction et analyse de trajectoires suspectes  
**Recherche académique** : Benchmark pour nouveaux algorithmes  
**Formation opérateurs** : Système d'alerte pour entraînement

Le système est **déconseillé** pour :

**Décisions automatiques critiques** : Taux de faux positifs nécessite validation humaine  
**Application de sanctions automatiques** : Risque d'erreur trop élevé

## Comparaison état de l'art

Par rapport aux systèmes existants (surveyor, VesselWatch, MarineTraffic) :

Voir le Tableau @tbl:analyse_evaluation:comparaison-etat-art.

**Conclusion** : NOVA se positionne comme solution **académique** et **transparente** plutôt que concurrent commercial direct.

## Pistes d'amélioration

Les résultats identifient plusieurs axes d'optimisation (détaillés dans section "Travaux futurs") :

1. **Seuils adaptatifs** par type de navire
2. **Intégration météo** pour contextualiser les anomalies
3. **LSTM** pour spoofing sophistiqué
4. **Optimisation performances** pour zones denses

```{=latex}
\onecolumn
```


| Métrique                       | Valeur         | Objectif   | Statut |
|--------------------------------|----------------|------------|--------|
| Latence moyenne (bout-en-bout) | 15-22ms        | <100ms     | ✅     |
| Throughput                     | 850-1100 msg/s | >500 msg/s | ✅     |
| Mémoire totale                 | ~350MB         | <1GB       | ✅     |
| CPU (moyenne)                  | 15-25%         | <50%       | ✅     |

: Métriques de performance {#tbl:analyse_evaluation:metriques-perf}


| Module   | Latence moyenne | Mémoire |
|----------|-----------------|---------|
| Parser   | 2-4ms           | ~50MB   |
| Enricher | 5-8ms           | ~120MB  |
| Analyzer | 3-6ms           | ~80MB   |
| Fusioner | 4-7ms           | ~100MB  |

: Performances par module {#tbl:analyse_evaluation:perfs-par-module}


|                   | Prédit Normal | Prédit Anomalie |
|-------------------|---------------|-----------------|
| **Réel Normal**   | 9,420 (TN)    | 85 (FP)         |
| **Réel Anomalie** | 32 (FN)       | 468 (TP)        |

: Matrice de confusion {#tbl:analyse_evaluation:matrice-confusion}


| Type                         | Détections | Rappel | Faux positifs |
|------------------------------|------------|--------|---------------|
| Vitesse excessive (>50kt)    | 150/150    | 100%   | 0             |
| Téléportation (Δv >30kt)     | 142/145    | 97.9%  | 2             |
| Changement cap brutal (>90°) | 98/100     | 98%    | 15            |
| Accélération excessive       | 78/105     | 74.3%  | 68            |

: Analyse par type d'anomalie {#tbl:analyse_evaluation:analyse-par-type}


| Critère          | NOVA                | Systèmes commerciaux |
|------------------|---------------------|----------------------|
| **Transparence** | ✅ Seuils sourcés   | ❌ "Boîte noire"     |
| **Open source**  | ✅ GPL v3           | ❌ Propriétaire      |
| **Latence**      | ✅ <25ms            | ⚠️ 100-500ms          |
| **Spoofing GPS** | ⚠️ Basique           | ✅ Avancé            |
| **ML avancé**    | ❌ Stats uniquement | ✅ LSTM/CNN          |

: Comparaison état de l'art {#tbl:analyse_evaluation:comparaison-etat-art}

```{=latex}
\twocolumn
```
