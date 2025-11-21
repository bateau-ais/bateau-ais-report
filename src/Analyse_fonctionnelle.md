# Analyse fonctionnelle

Nous réalisons une analyse fonctionnelle de la solution, en partant d’un diagramme dit « bête à corne ».
Pour cela, nous partons des informations suivantes identifiées précédemment :
-	Public cible : VTS (Vessel Traffic Service),
  CROSS (Centre Régionaux Opérationnels de Surveillance et de Sauvetage)
 	et FOC (Fleet Operation Center) ;
-	Sur quoi agit notre solution : les trames AIS réceptionnées sont analysées par notre solution ;
-	Objectif de notre solution : détecter les anomalies de comportement de navigation maritime
  pour améliorer la sécurité de la navigation maritime.

Le diagramme « bête à corne » suivant permet de visualiser ces informations :

INSERER IMAGE BETE A CORNE

Nous avons identifié les fonctions suivantes comme étant essentielles à notre projet 
(FP = Fonction Principale, FC = Fonction Contrainte) :
-	FP : la solution doit détecter automatiquement les anomalies
  de navigations au travers des trames AIS reçues ;
-	FC1 : traiter un volume massif de données de façon performante ;
-	FC2 : être modulaire et scalable ;
-	FC3 : créer un modèle généralisable (indépendant de la géographie) ;
-	FC4 : visualiser les résultats de façon user-friendly ;
-	FC5 : permettre l’entrainement du modèle à partir de données falsifiées.

Le tableau suivant permet de regrouper ces différentes fonctions.
Différents critères leurs sont associés afin de pouvoir déterminer si la fonction est respectée :

| Fonction                          | Critères          | Niveau          | Flexibilité          |
| :---------------------------------|:-----------------:|:---------------:|:--------------------:|
| FP : la solution doit détecter automatiquement les anomalies de navigations au travers des trames AIS reçues. | Efficacité | Sécurité nautique | F0 |
| FC1 : traiter un volume massif de données de façon performante. | Rapidité | Données | F0 |
| FC2 : être modulaire et scalable. | Polyvalence | Programmation | F1 |
| FC3 : créer un modèle généralisable (indépendant de la géographie). | Universalité | Pour tout le monde | F0 |
| FC4 : visualiser les résultats de façon user-friendly. | Praticité | Pour tous les utilisateurs | F1 |
| FC5 : permettre l’entrainement du modèle à partir de données falsifiées. | Reproductibilité | Entrainement | F0 |
