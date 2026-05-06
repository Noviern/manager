[English](README.md) | [Français](README.fr.md) | [Русский](README.ru.md) | [简体中文](README.zh_cn.md)

# Gestionnaire d'extensions
Permet d'activer/désactiver les extensions et donne accès à leurs paramètres (si pris en charge).
Double-cliquez sur la barre de titre pour épingler la fenêtre au premier plan de l'interface.

![Gestionnaire d'extensions](https://i.imgur.com/C4DWrRA.png)

**Remarque :**

En raison d'un bug dans l'API des addons, tout addon qui crée un bouton dans le
menu Échap ajoutera un nouveau bouton à chaque rechargement ou activation, sans
supprimer le précédent.

**AVERTISSEMENT : Le rechargement peut faire planter le client**

Le rechargement des addons est généralement sûr mais **peut provoquer des plantages** dans certaines circonstances :
- Boucles infinies
- Fuites de mémoire UI ou problèmes de chargement de textures
- Conflits avec d'autres addons ou objets d'interface existants

## Développeurs
Le bouton des paramètres à côté de chaque extension déclenche l'événement `UI_ADDON` pour cette extension.