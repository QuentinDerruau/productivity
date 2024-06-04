# iOS App: ToDo List & Pomodoro Timer

Bienvenue dans l'application iOS ToDo List & Pomodoro Timer ! Cette application combine une liste de tâches et un minuteur Pomodoro pour améliorer votre productivité.

## Fonctionnalités

- **Liste de tâches :**
  - Ajouter, modifier et supprimer des tâches.
  - Marquer les tâches comme complètes ou incomplètes.
  - Organisation des tâches par date.

- **Minuteur Pomodoro :**
  - Configurer des sessions de travail et de pause.
  - Suivi du nombre de cycles Pomodoro complétés.
  - Notifications à la fin des sessions de travail et de pause.

## Installation

1. **Cloner le dépôt :**
    ```bash
    git clone https://github.com/QuentinDerruau/productivity.git
    cd productivity
    ```

2. **Ouvrir le projet dans Xcode :**
    ```bash
    open Productivity.xcodeproj
    ```

3. **Lancer l'application :**
   Sélectionnez un simulateur ou un appareil physique et cliquez sur le bouton "Run".

## Architecture

L'application est structurée selon l'architecture MVVM (Model-View-ViewModel) pour une séparation claire des préoccupations.
- **ViewControllerList :** Représente la liste des taches.
- **Extensions :** Represente les modifications sur les class existantes
- **MangaeDb :** Actions sur la base de donnée de SwiftData
- **Model :** Représente les données de l'application (ex. : Tâche, SessionPomodoro).
- **ViewControllerList :** La visualisation du détails des taches.
- **TaskCell :** Met en place la cellule de tache
- **PomodoroViewController:** La visualisation de la page pomodorro.
  
## Bibliothèques Utilisées

- **UIKit** : Pour la construction de l'interface utilisateur.
- **SwiftData** : Pour la persistance des tâches.

---

Merci d'utiliser l'application ToDo List & Pomodoro Timer ! Profitez de votre expérience et améliorez votre productivité.

---

# Support

Si vous rencontrez des problèmes ou avez des questions, n'hésitez pas à créer une issue sur le dépôt GitHub.

---

# Version

Version 1.0.0

---

# Historique des Versions

- 1.0.0 : Première version de l'application. Inclut les fonctionnalités de base pour la gestion des tâches et le minuteur Pomodoro.

---
