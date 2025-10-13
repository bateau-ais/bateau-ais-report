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

<!--
Ajouter ici la liste d'article éventuellement, si nous avons besoin de remplir
les 6 pages.
-->

## Principaux axes de recherche

Dans notre sélection, 5 articles de recherche implémentent des modèles de machine
learning ou de deep learning.

Ils se basent sur des bases de données libres ou non et leur implémentations
sont rarement disponibles en open-source.
Ce point là est important à nos yeux, car cela veut dire que la recherche dans ce
milieu ne propose que peu de transparence.

Voici les étapes qui reviennent dans ces papiers :

1. Récupération des données
2. Filtrage des données manifestement invalides
3. Enrichissement et normalisation des données
4. Ajout de données falsifiée
5. Entraînement du/des modèle(s)
6. Évaluation de la performance du/des modèle(s)

Nous avons aussi eu un article qui a tenté d'utiliser NUMSYNTH, un framework
pour générer des "théories" à partir de paramètres numériques.
Ils obtiennent ainsi des résultats comparables aux approches par deep
learning actuelles, mais avec un coût de calcul bien plus limité.
Cela pourrait ouvrir à des usages dans des systèmes avec des performances
limités.
