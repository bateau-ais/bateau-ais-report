# Analyse du retentissement

De par les ressources dont nous disposons pour le développement d'une
solution permettant de détecter les comportements AIS anormaux, notre
solution nécessitera peu de ressources techniques et sera très accessible
financièrement. De par ces caractéristiques, une part plus importante des
services de surveillance maritime pourront être équipé, et plus facilement,
répondant ainsi aux principales attentes du marché.

Le public visé par ce projet concerne les principaux services
de surveillance maritime :

- VTS (Vessel Traffic Service) : il s'agit de système à terre
qui vont de la fourniture de simples messages d'informations aux navires,
tels que la position des autres navires ou les avertissements
de dangers météorologiques, à une gestion étendue du trafic
dans un port ou une voie navigable.
[@ServicesTraficMaritime] ;
- CROSS (Centre Régionaux Opérationnels de Surveillance et de Sauvetage) :
la mission de sauvetage en mer est coordonnée par les CROSS
à l'intérieur des zones sous reponsabilité française,
en métropole et outre-mer.
[@SurveillanceSauvetageMer] ;
- FOC (Fleet Operation Center) : peut servir plusieurs
objectifs de management de flottes dans le domaine commercial
et gouvernemental.
[@yangHarnessingPowerMachine2024]

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
dès les premiers signes et de pouvoir agir avant même que le signal de détresse
ne soit envoyé par l'équipage**. Cette capacité de réaction rapide permettrait
ainsi de réduire le nombre d'accident et de sauver des vies.
