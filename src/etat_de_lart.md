# État de l'art et positionnement par rapport à l'existant

## Protocole de sélection de papier de recherche

Afin de chercher une liste d'article pertinente, nous nous sommes basés sur
la méthodologie de Kitchenham [@kitchenhamSystematicReviewSystematic2013].

<!--
Devons nous vraiment citer Kitchenham sachant que nous n'avons pas relu sa
méthodologie avant de faire nos recherches ? Nous pouvons normalement nous en
passer ici. Comme nous n'avons pas vocation à vraiment faire un état de l'art
complet, mais bien de pouvoir lister quelques travaux nous précédant à la
manière des papiers de recherche que nous avons eu l'occasion de lire.
-->

Cette dernière nous assure une base solide afin d'obtenir les informations
importantes dans la recherche académique.

Pour obtenir la première sélection d'article, nous nous sommes aidés de
l'outil _Publish or perish_ [?] afin de ressortir 1000 articles sur les années
2020 à 2025.
Les mots-clef utilisés ont été "AIS", "maritime cybersecurity", et "machine learning".

Ensuite, nous avons supprimé les articles précédant 2025 et qui n'ont aucune
citation.
Cela représente 18 articles.
À côté, nous avons fait une deuxième sélection de papier ayant zéro citation,
mais qui ont été publiés en 2025 afin de réintégrer les papiers les plus récents
à notre recherche.
12 articles correspondent à cette description.

À partir de ces 30 articles, nous les avons lu et nous n'en avons retenu 17 qui
traitent du sujet de l'AIS.

## Tendances des publications

L'état de l'art autour de la détection d'anomalies sur le système AIS et les méthodes d'intelligence artificielle (IA) appliquées à la cybersécurité maritime est en pleine expansion, comme le montrent les recherches récentes.
Plusieurs axes émergent clairement dans la littérature scientifique.

Premièrement, la détection de signaux AIS falsifiés reste un défi majeur.
Pohontu et al. (2025) proposent une comparaison entre trajectoires simulées et données AIS réelles, soulignant l'efficacité d'algorithmes d'analyse comportementale pour repérer le spoofing avec une précision élevée [@pohontuRealtimeDetectionSpoofed2025].
Cette approche combinant des données simulées et réelles permet d'améliorer la robustesse des détecteurs d'anomalies.

Ensuite, l'usage de l'IA dans la cybersécurité maritime s'élargit avec des revues systématiques comme celle de Miller et al. (2025), qui synthétisent les stratégies de détection des menaces et les mécanismes de réduction du risque fondés sur des approches d'apprentissage automatique et d'apprentissage profond [@millerArtificialIntelligenceMaritime2025].
Ces méthodes favorisent la détection précoce d'activités malveillantes dans les flux AIS.

Parmi les approches spécifiques, Raj et Kumar (2025) mettent en œuvre un modèle Bi-LSTM (Long Short-Term Memory) pour détecter les points de trajet spoofés dans les données AIS, illustrant le fort potentiel des réseaux de neurones récurrents dans l'analyse des séries temporelles maritimes [@nitishrajVesselTrajectoryRoute2025].
Cette technique permet de capturer efficacement les dépendances temporelles dans les trajectoires des navires.

La sélection de caractéristiques via des méthodes statistiques, comme présenté par Visky et al. (2025), est également une piste importante pour améliorer la détection d'anomalies.
L'analyse statistique aide à extraire les variables les plus discriminantes dans les jeux de données AIS afin d'alimenter des modèles d'IA plus performants [@viskyStatisticalAnalysisBasedFeature2025a].

D'autres travaux étudient des méthodes avancées comme la topologie persistante pour l’identification de trajectoires géospatiales anormales, offrant une perspective originale sur la nature des anomalies spatiales en mer (Evans-Lee et Lamb, 2024) [@evans-leeIdentificationAnomalousGeospatial2024].

Enfin, il est important de mentionner la dimension plus large de la sécurité maritime intégrant des aspects de mesure et de communication technologique, ainsi que les risques associés aux attaques radio furtives contre les diffusions AIS, comme analysé par Jiang et al. (2025) [@jiangCurrentStatusBibliometricsBased2025] et Klör et al. (2024) [@klorDudeWheresThat2024].
Ces travaux soulignent la nécessité d’une défense coordonnée intégrant cybersécurité et sécurité opérationnelle.

En résumé, les recherches récentes convergent vers des solutions hybrides mêlant intelligence artificielle avancée, analyse statistique rigoureuse et validation par données simulées et réelles.
Ces approches permettent d’améliorer la détection d’anomalies AIS, facteur clé pour renforcer la cybersécurité maritime et la sûreté de la navigation [W4408835171][W4410004931][W4408806682][W4407737541][W4403322254][W4409155591][W4402353371].


Nous avons aussi eu un article qui a tenté d'utiliser NUMSYNTH, un framework
pour générer des "théories" à partir de paramètres numériques.
Ils obtiennent ainsi des résultats comparables aux approches par deep
learning actuelles, mais avec un coût de calcul bien plus limité.
Cela pourrait ouvrir à des usages dans des systèmes avec des performances
limités.
