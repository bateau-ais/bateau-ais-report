---
title:    Analyse automatisée des trames AIS pour la détection en temps réel d’anomalies et de spoofing maritime
subtitle: Jalon 1
author: 
- Noilou Quentin
- Le Bail Elouarn
- Veneny François
- Dufour Nils
keywords: [ais, marine, autonomous vessels, machine learning]
date: 13 octobre 2025
lang: fr

note_type: reference
writing_type: draft
include-resources: src
bibliography: refs.yaml
csl: ieee.csl
link-citations: true

listings-no-page-break: false
code-block-font-size: \scriptsize
fontsize: 10pt
colorlinks: ff0d8a
mainfont: Overpass Nerd Font
sansfont: Overpass Nerd Font
linkcolor: cyan
urlcolor: cyan

titlepage: true
titlepage-rule-color: 89b4fa
titlepage-background: ./background.png
titlepage-text-color: "000000"
page-background: ./background.png

toc-own-page: true

abstract-title: Introduction
abstract: |

  Le transport maritime, pilier du commerce mondial, repose largement sur le système AIS (Automatic Identification System) pour assurer la sécurité et la traçabilité des navires. Cependant, les falsifications de signal (spoofing), les coupures volontaires et les anomalies de trajectoire constituent aujourd’hui des menaces croissantes pour la sûreté maritime et la cybersécurité des infrastructures maritimes.
  Ce projet propose le développement d’une solution intelligente, ouverte et modulaire de détection de comportements anormaux à partir de l’analyse des trames AIS. En s’appuyant sur les apports récents de la recherche, la solution combine des modèles d’intelligence artificielle (tels que les réseaux Bi-LSTM pour la détection temporelle et les algorithmes de clustering non supervisé pour les anomalies spatiales) avec une analyse statistique fine des caractéristiques géospatiales et dynamiques des navires.
  L’architecture proposée suit un pipeline complet : ingestion et nettoyage des flux AIS bruts, enrichissement des données, classification par IA et génération d’alertes contextualisées au sein d’un tableau de bord interactif. L’approche open source retenue garantit la transparence scientifique, la souveraineté technologique et une interopérabilité avec les systèmes de surveillance maritime existants (VTS, CROSS, FOC).
  En offrant une détection en temps réel, adaptable et explicable, ce projet vise à restaurer la confiance dans les données AIS, renforcer la résilience face aux manipulations numériques, et soutenir les acteurs civils et militaires dans leurs missions de sécurité et de gestion du trafic maritime.

---

```{=latex}
\setlength{\columnsep}{1.2cm}
\twocolumn
```

!include Contexte_et_besoins.md

!include Analyse_retentissement.md

!include etat_de_lart.md

```{=latex}
\onecolumn
```

!include Matrice_RACI.md

```{=latex}
\newpage
```

# Références

::: {#refs}
:::

