# Petit Rapport de TP : Tests Unitaires avec CMocka

Ce document synthétise le travail réalisé sur la mise en place de tests unitaires pour le module de tarification RATP. L'objectif était de valider la logique métier, de comprendre les nuances des assertions, de gérer le cycle de vie des tests et d'isoler les dépendances via des Mocks.

## 1. Objectifs et Logique Métier

La fonction principale testée est `computePrice(age)`. La règle de gestion implémentée est la suivante :

> 
> *Si l'âge est inférieur ou égal à 12 ans, le prix standard du ticket (1.5€) est divisé par deux.* 
> 
> 

## 2. Analyse des Choix Techniques

### Comparaison des Assertions (Q1 & Q2)

Le code explore deux méthodes pour vérifier les résultats, mettant en évidence pourquoi `assert_float_equal` est préférable à `assert_true` pour les nombres flottants.

* **Problème de précision (Q1) :** Les nombres flottants (float) ayant une précision limitée en informatique, une égalité stricte (`==`) échoue souvent. L'utilisation d'un **epsilon** (`0.01` dans le code) est nécessaire pour définir une marge d'erreur acceptable.


* **Clarté du débogage (Q2) :**
* `assert_true` renvoie un message générique peu utile : `ERROR computePrice(12) == 1.2`.
* `assert_float_equal` affiche les valeurs exactes : `ERROR 0.750000 != 0.600000`. Cela permet de comprendre immédiatement l'écart.





### Gestion du Cycle de Vie (Fixtures)

Le code utilise les mécanismes de **Setup** et **Teardown** pour garantir que chaque test s'exécute dans un environnement propre.

* **Setup Custom (`setup_custom`) :** Alloue dynamiquement de la mémoire pour stocker l'âge (`malloc`) et passe ce pointeur au test via la variable `state`. Cela permet de paramétrer les tests.


* **Teardown (`teardown`) :** Libère la mémoire allouée (`free`) après l'exécution du test, évitant ainsi les fuites de mémoire, quelle que soit l'issue du test.



## 3. Isolation et Mocking (Q6 & Q7)

Pour rendre le test unitaire indépendant des dépendances externes (comme une base de données ou une saisie utilisateur), le code utilise le système de **Mocking** de CMocka.

* **La Fonction Mockée :** La fonction `recupAge` a été redéfinie pour ne plus effectuer sa tâche réelle mais pour appeler `mock()`.
```c
void recupAge(int *valeur){
    *valeur = (int) mock(); // Récupère la valeur simulée
}

```


* **Injection de valeur :** Dans le test `computePrice_moins12_mock_recupAge`, la fonction `will_return(recupAge, 12)` est utilisée. Elle place la valeur `12` dans une pile. Lorsque `recupAge` appelle `mock()`, elle dépile cette valeur.



## 4. Couverture de Code (GCOV)

Le code contient les instructions pour générer un rapport de couverture, permettant de vérifier quelles lignes du code source ont été exécutées par les tests.

* **Compilation :** Ajout des flags `-fprofile-arcs -ftest-coverage` pour instrumenter le binaire.


* **Liaison (Linker) :** Ajout de `-lgcov --coverage`.


* **Visualisation :** Utilisation de l'outil `gcovr` pour générer un rapport HTML lisible (`result.html`).



## 5. Structure du Main

Le `main` orchestre l'exécution. Actuellement, seul le test avec Mock est activé pour se concentrer sur la dernière partie de l'exercice :

```c
const struct CMUnitTest tests[] = {
    // Tests précédents commentés...
    cmocka_unit_test(computePrice_moins12_mock_recupAge)
};

```

Cette structure modulaire permet d'activer ou désactiver des groupes de tests selon les besoins du développement.