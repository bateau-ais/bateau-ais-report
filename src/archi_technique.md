# Architecture technique

```{.mermaid #fig:archi_technique}
---
config:
  layout: elk
---
graph TB
    %% Légende
    LEGEND[
        🟦 Modules d'ingestion<br/>
        🟨 Topics NATS<br/>
        🟩 Modules de traitement<br/>
        🟧 Serveur d'agrégation/Dash<br/>
        ⬜ Interface utilisateur<br/>
        ⬛ Sources externes
    ]:::legend

    %% Sources de données
    ANT[🔡 Antenne Radio]:::source
    FILE[📁 Fichier AIS]:::source
    FUTURE_SRC[:::Futures sources:::]:::source

    %% Modules d'ingestion
    MOD_ANT[Module Antenne<br/>Machine A]:::ingestion
    MOD_FILE[Module Fichier<br/>Machine B]:::ingestion
    MOD_FUTURE_IN[:::Module futur:::<br/>Machine X]:::ingestion

    %% Module de spoofing
    MOD_SPOOFING[Module de Spoofing<br/>Machine G]:::processing

    %% Modules de traitement niveau 1
    MOD_SESSION[Module Suivi de session<br/>Machine C]:::processing
    MOD_ENRICHED[Module Enrichissement AIS<br/>Machine D]:::processing
    MOD_STATS[Module Statistiques<br/>Machine E]:::processing

    %% Modules de traitement niveau 2
    MOD_ML[Module ML Détection<br/>Machine F]:::processing
    MOD_FUTURE1[:::Module Analytics:::<br/>Machine H]:::processing
    MOD_FUTURE2[:::Module Prédiction:::<br/>Machine I]:::processing

    %% Agrégation et Dashboard
    MOD_AGG[Module Agrégation<br/>Collecte des alertes]:::aggregation
    DASH_SERVER[Serveur Python Dash<br/>API REST/WebSocket]:::aggregation

    %% Interface finale
    DASHBOARD[📊 Interface Dash<br/>- Graphiques temps réel<br/>- Alertes<br/>- Statistiques]:::interface
    OP1[👤 Opérateur 1]:::interface
    OP2[👤 Opérateur 2]:::interface
    OP3[👤 Opérateur N]:::interface

    %% Connexions Sources -> Modules d'ingestion
    ANT --> MOD_ANT
    FILE --> MOD_FILE
    FUTURE_SRC -.-> MOD_FUTURE_IN

    %% Modules d'ingestion -> Spoofing (via raw_ais)
    MOD_ANT ==>|raw_ais| MOD_SPOOFING
    MOD_FILE ==>|raw_ais| MOD_SPOOFING
    MOD_FUTURE_IN -.->|raw_ais| MOD_SPOOFING

    %% Spoofing -> Modules traitement niveau 1 (via raw_spoofed_ais)
    MOD_SPOOFING ==>|raw_spoofed_ais| MOD_SESSION
    MOD_SPOOFING ==>|raw_spoofed_ais| MOD_ENRICHED
    MOD_SPOOFING ==>|raw_spoofed_ais| MOD_STATS
    MOD_SPOOFING -.->|raw_spoofed_ais| MOD_FUTURE1
    MOD_SPOOFING ==>|raw_spoofed_ais| MOD_ML
    MOD_SPOOFING ==>|raw_spoofed_ais| MOD_AGG

    %% Connexions inter-modules niveau 1
    MOD_SESSION ==>|session| MOD_ML
    MOD_SESSION ==>|session| MOD_STATS
    MOD_ENRICHED ==>|enriched_ais| MOD_SESSION

    %% Modules -> Agrégation (topics d'alertes)
    MOD_STATS ==>|anomalies| MOD_AGG
    MOD_ML ==>|anomalies| MOD_AGG
    MOD_ML ==>|alerts| MOD_AGG
    MOD_FUTURE1 -.->|future_topic| MOD_AGG
    MOD_FUTURE2 -.->|future_topic| MOD_AGG
    MOD_FUTURE2 -.->|future_topic| MOD_FUTURE1

    %% Agrégation -> Dashboard
    MOD_AGG --> DASH_SERVER
    DASH_SERVER -->|HTTP/WS| DASHBOARD

    %% Dashboard -> Opérateurs
    DASHBOARD <--> OP1
    DASHBOARD <--> OP2
    DASHBOARD <--> OP3

    %% Styles pour les classes
    classDef source fill:#424242,stroke:#000,color:#fff
    classDef ingestion fill:#2196f3,stroke:#1565c0,color:#fff
    classDef processing fill:#4caf50,stroke:#2e7d32,color:#fff
    classDef aggregation fill:#ff9800,stroke:#e65100,color:#fff
    classDef interface fill:#dc2b34,stroke:#616161,color:#fff
    classDef legend fill:#fff,stroke:#333,stroke-width:2px,stroke-dasharray: 5 5
    
    %% Style pour les éléments futurs
    classDef future stroke-dasharray: 5 5,opacity:0.7
    class MOD_FUTURE_IN,MOD_FUTURE1,MOD_FUTURE2,FUTURE_SRC,MOD_ML future
    
    %% Style pour les flèches topics (orange)
    linkStyle 5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22 stroke:#ff9800,stroke-width:3px
```
