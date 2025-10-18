# Contexte géopolitique et analyse des besoins du marché

## Contexte géopolitique

Le transport maritime représente aujourd'hui l'épine dorsale du commerce mondial, acheminant environ 90% des échanges internationaux en volume et près de 11 milliards de tonnes de marchandises annuellement [@InfographieChiffresclesEchanges; @PlanetoscopeStatistiquesMarchandises]. 

Cette dépendance critique aux routes maritimes s'accompagne d'une vulnérabilité croissante face aux cybermenaces, particulièrement celles ciblant l'Automatic Identification System (AIS), système devenu indispensable à la navigation moderne [@TransportMaritimeCNUCED2025].

L'AIS, obligatoire pour tous les navires de plus de 300 tonneaux en navigation internationale depuis les amendements SOLAS de 2004, transmet en continu des données essentielles : position GPS, vitesse, cap, identité du navire et destination [@TranspondeursAIS]. Ce système permet de fournir automatiquement des informations sur le navire aux autres navires et aux autorités côtières, garantissant ainsi une navigation sécurisée [@ServicesTraficMaritime].

Le contexte géopolitique actuel est marqué par une intensification préoccupante des attaques contre les infrastructures maritimes numériques, transformant les mers en nouveaux terrains de confrontation hybride.
La Russie est régulièrement accusée de brouiller massivement les signaux GPS en mer Baltique, perturbant la navigation commerciale et aérienne.
En avril 2024, la Suède a réclamé une présence accrue de l'OTAN en mer Baltique face au brouillage des signaux GPS par la Russie [@lagneauBrouillageSignauxGPS2024]. En mer Rouge, des navires de commerce sont confrontés au brouillage GPS, compliquant la navigation dans l'une des routes maritimes les plus fréquentées au monde [@cogneMerRougeNavires2025].
La Corée du Nord a également été impliquée en novembre 2024 dans des perturbations GPS affectant navires et avions en Corée du Sud [@cogneMerRougeNavires2025].

Plus récemment, la "flotte fantôme" russe a été identifiée comme vecteur d'opérations de déstabilisation à l'échelle mondiale.
Cette flotte fantôme russe, évaluée à environ 600 navires, est utilisée clandestinement par la Russie pour exporter son pétrole malgré les sanctions internationales durant l'invasion de l'Ukraine [@cogneMerRougeNavires2025].

Sans propriétaire identifiable ni assurance adéquate, cette flotte représente aujourd'hui 17% des pétroliers mondiaux [@portail-ieFlotteFantomeComment2025]. Ces navires manipulent fréquemment leurs transpondeurs AIS, déconnectant leurs balises pendant plusieurs jours dans certaines zones ou transmettant de fausses positions, rendant leur traçabilité extrêmement difficile [@ConformiteAvecPratiques].

En décembre 2024, le pétrolier Eagle S immatriculé aux îles Cook a été soupçonné d'avoir coupé volontairement le câble d'alimentation sous-marin Estlink 2 entre la Finlande et l'Estonie [@cogneMerRougeNavires2025].
La marine suédoise rapporte que les navires fantômes opérant dans les eaux de sa zone économique exclusive sont équipés de dispositifs de communication que n'utilisent pas les navires marchands classiques, suggérant qu'ils jouent un rôle d'espionnage [@portail-ieFlotteFantomeComment2025].
En janvier 2025, une nouvelle série de sanctions a été mise en place par l'Union européenne, visant principalement près de 200 navires pétroliers et méthaniers présentés comme faisant partie de la flotte fantôme [@FlotteFantomeRusse2025].

Au-delà du brouillage GPS, les manipulations de l'AIS prennent diverses formes : spoofing (émission de fausses positions), désactivation volontaire des transpondeurs dans des zones sensibles, usurpation d'identité maritime, ou encore création de "navires fantômes" n'existant pas physiquement mais apparaissant sur les systèmes de surveillance.
Le système AIS est potentiellement vulnérable au brouillage volontaire ou non car les caractéristiques techniques sont publiques, et à l'envoi volontaire d'informations erronées comme des navires fictifs [@serrySystemeDidentificationAutomatique2015].
Ces techniques sont utilisées pour masquer des activités illicites telles que la contrebande, le trafic d'armes, la pêche illégale non déclarée et non réglementée, le contournement de sanctions économiques, ou encore le transbordement illicite en haute mer.

## Analyse des besoins du marché

Face à cette menace émergente et multiforme, les autorités maritimes civiles et militaires – CROSS (Centres Régionaux Opérationnels de Surveillance et de Sauvetage) en France, gardes-côtes, capitaineries portuaires, services de renseignement maritime – manquent d'outils abordables et extensibles pour analyser ces anomalies en temps réel.
Les solutions commerciales existantes, développées principalement par des entreprises comme Windward, Spire Maritime ou Orbcomm, combinent données AIS satellitaires et terrestres pour offrir des capacités de détection d'anomalies [@turgeonAISDataProviders2024;@PowerYourOrganization].
Windward a notamment développé un partenariat avec Spire Global pour la validation de position AIS permettant de détecter les navires manipulant leurs transmissions [@PowerYourOrganization;@GlobalShipTracking].
Ces solutions utilisent l'intelligence artificielle pour analyser de vastes quantités de données maritimes et identifier des anomalies impactant les opérations, détectant automatiquement les activités irrégulières sans intervention utilisateur [@PowerYourOrganization;@durgpalAIPoweredSolutionLaunched2024].

Cependant, ces solutions propriétaires peuvent coûter plusieurs dizaines de milliers d'euros par an pour les licences commerciales, donc insuffisamment accessibles aux organisations ne disposant pas de budgets conséquents, soit incompatibles avec les systèmes nationaux de surveillance.
Le marché de l'intelligence commerciale dérivée de l'AIS peut être divisé en trois types d'acteurs [@VesselTrackingReveals] :

- les fournisseurs de données AIS,
- les nettoyeurs de données fournissant des produits de visualisation,
- les fournisseurs d'intelligence commerciale haut de gamme.

En 2025, le marché a connu une consolidation significative avec l'acquisition par Kpler de Spire Maritime pour 241 millions de dollars et par S&P Global de l'activité AIS d'ORBCOMM, démontrant la valeur stratégique de ces données [@asymmetrixSPPurchase2025].

Le manque de solutions abordables et extensibles démontre une lacune capacitaire est particulièrement critique pour les nations moyennes, les capitaineries de ports régionaux, et les organisations ne disposant pas de budgets conséquents, créant ainsi un besoin opérationnel urgent pour une solution accessible, performante et ouvvertes.

## Présentation de la solution proposée

Face aux limites des outils actuels, notre équipe propose une solution ouverte, accessible et modulaire pour la détection de comportements maritimes anormaux à partir des trames AIS.

Notre solution exploite des flux AIS bruts qu’elle nettoie et enrichit avant de les soumettre à plusieurs modèles de classification. Ces modèles — combinant apprentissage supervisé, non supervisé et méthodes statistiques — permettent de détecter des anomalies de comportement communes [@ribeiroAISbasedMaritimeAnomaly2023] telles que :

- le spoofing (falsification de position ou d’identité),
- les coupures volontaires ou comportement de “dark ships”,
- les trajectoires incohérentes liées à des défaillances ou à des activités suspectes.

L’architecture se veut extensible et interopérable, avec des spécifications claires afin d’être adaptable à divers cas d’usage : surveillance portuaire, suivi de flotte commerciale, opérations militaires ou recherche académique. Le système intègre un tableau de bord interactif fournissant en temps réel la cartographie des alertes, les indicateurs de confiance et des rapports automatisés exploitables par les opérateurs (VTS, CROSS, FOC).

Notre approche a également vocation à être open source, permettant la transparence scientifique et la collaboration interdisciplinaire. Contrairement aux solutions commerciales fermées comme celles de Windward ou Kpler, notre modèle favorise un développement communautaire durable et la souveraineté technologique des acteurs publics.

En combinant détection avancée, accessibilité et explicabilité, cette solution vise à restaurer la confiance dans les données AIS, renforcer la cybersécurité maritime, et offrir un outil abordable, performant et souverain à l’ensemble des acteurs du domaine naval.
