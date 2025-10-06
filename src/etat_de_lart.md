# Recueil et analyse du besoin du marché
*A faire*

# Analyse du retentissement
*A finir*

Le public visé par ce projet de détection automatique
de comportement anormaux sont les secteurs suivants :
- VTS (Vessel Traffic Service) : il s'agit de système à terre
qui vont de la fourniture de simples messages d'informations aux navires,
tels que la position des autres navires ou les avertissements
de dangers météorologiques, à une gestion étendue du trafic
dans un port ou une voie navigable.
[\[Source\]](https://www.imo.org/fr/ourwork/safety/pages/vesseltrafficservices.aspx) ;
- CROSS (Centre Régionaux Opérationnels de Surveillance et de Sauvetage) :
la mission de sauvetage en mer est coordonnée par les CROSS
à l'intérieur des zones sous reponsabilité française,
en métropole et outre-mer.
[\[Source\]](https://www.mer.gouv.fr/surveillance-et-sauvetage-en-mer) ;
- FOC (Fleet Operation Center) : peut servir plusieurs
objectifs de management de flottes dans le domaine commercial
et gouvernemental.
[\[Source\]](https://constanttech.com/implementing-a-fleet-operations-center/).

Dans le cadre d'opérations de surveillance des navires (VTS ou FOC par exemple),
notre solution pourrait permettre de détecter automatiquement et avec fiabilité
un ou plusieurs navires ayant un comportement anormal dans ses déplacements.
Cette détection permettrait alors une **réaction rapide des équipes de suivi afin
de rediriger le traffic et d'éviter la zone de danger que pourrait représenter
le navire agissant de manière suspecte**.

Il est possible que le comportement suspect observé à partir des données AIS
s'explique par le fait que le navire subit une attaque radio alterant les données AIS émises
(exemple : jamming, spoofing, entre autres).
Dans ce cas de figure, la solution pourrait **permettre d'avertir rapidement
l'équipage du navire ciblé de cette observation, leur permettant ainsi
de réagir rapidement** (par exemple, par un changement de fréquence,
de médium de communication, ou en prévenant les navires aux alentours
de son incapacité à communiquer sa position de manière fiable).

Une trajectoire anormal pouvant être la résultante d'une avarie
(par exemple, lorsqu'un navire s'arrète et part à la dérive),
**notre solution permettrait aux CROSS de détecter ces navires en détresse
dès les premiers signes et de pouvoir agir avant que le signal de détresse
ne soit envoyé par l'équipage**.

# État de l'art et positionnement par rapport à l'existant

## Protocole de sélection de papier de recherche

Afin de chercher une liste d'article pertinente, nous nous sommes basés sur
la méthodologie de Kitchenham [?].

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
l'outil /Publish or perish/ [?] afin de ressortir 1000 articles sur les années
2020 à 2025.
Les mots-clef utilisés ont été "AIS", "maritime cybersecurity", et "machine learning".

Ensuite, nous avons supprimé les articles précédant 2025 et qui n'ont aucune
citation.
Cela représente 18 articles.
À côté, nous avons fait une deuxième sélection de papier ayant zéro citation,
mais qui ont été publiés en 2025.
12 articles correspondent à cette description.

À partir de ces 30 articles, nous les avons lu et nous n'en avons retenu 17 qui
traitent du sujet de l'AIS.

<!--
Ajouter ici la liste d'article éventuellement, si nous avons besoin de remplir
les 6 pages.
-->

## Principaux axes de recherche

??? articles de recherche implémentent des modèles de machine learning ou
de deep learning.
Ils se basent sur des bases de données libres ou non et leur implémentations
sont rarement disponibles en open-source.
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
