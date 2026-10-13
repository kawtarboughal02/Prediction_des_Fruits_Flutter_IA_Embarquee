# 🍎 Prédiction des fruits — Application mobile Flutter + IA embarquée

Application mobile **Flutter** qui identifie un fruit à partir d'une photo grâce à un
modèle d'**intelligence artificielle embarqué (TensorFlow Lite)** fonctionnant
**hors-ligne, directement sur l'appareil**. L'application intègre également une
authentification **Firebase** et un **assistant vocal** (reconnaissance vocale +
Google Gemini).

> Auteure : **Kawtar Boughal** — [GitHub @kawtarboughal02](https://github.com/kawtarboughal02)

Le rapport détaillé est disponible dans [`docs/RAPPORT_FINAL.md`](./docs/RAPPORT_FINAL.md).

---

## 📌 Contexte et problème

Reconnaître un fruit depuis une photo est une tâche de **classification d'images** que
l'œil humain fait instantanément, mais qui reste difficile à automatiser de façon
légère et rapide. Les solutions fondées sur le cloud imposent une connexion internet,
un aller-retour réseau et posent des questions de latence et de confidentialité des
images envoyées.

**Problème :** comment identifier un fruit à partir d'une image **de manière instantanée,
sans dépendre d'internet**, tout en offrant une expérience mobile simple et sécurisée ?

## ✅ Solution développée

Une application mobile **cross-platform** (Android / iOS) qui :

- 🔐 **Authentifie** l'utilisateur via **Firebase Auth** (inscription avec profil, connexion, déconnexion).
- 📸 **Capture ou importe** une photo de fruit (caméra ou galerie) via `image_picker`.
- 🧠 **Classe le fruit en local** avec un modèle **TensorFlow Lite** (`model.tflite`) parmi **10 classes** : Apple, Avocado, Banana, Cherry, Kiwi, Mango, Orange, Pineapple, Strawberries, Watermelon.
- 📊 **Affiche le résultat** : nom du fruit + **score de confiance en %**.
- 🎙️ Propose un **assistant vocal** (reconnaissance vocale `speech_to_text` + génération de réponse **Google Gemini**) pour la traduction / l'aide à la communication.
- 🎨 Interface **Material 3** cohérente (thème bleu), navigation par écrans et menu latéral.

### Fonctionnalités par écran

| Écran | Rôle |
|-------|------|
| **Connexion** (`login_screen`) | Authentification email / mot de passe (Firebase) |
| **Inscription** (`register_screen`) | Création de compte (nom, prénom, date de naissance, téléphone, email, genre) + enregistrement du nom d'affichage |
| **Accueil** (`home_page`) | Tableau de bord, menu latéral, accès aux 2 fonctionnalités |
| **Prédiction de fruits** (`fruit_pred_page`) | Sélection d'image → inférence TFLite → fruit + confiance |
| **Traduction vocale** (`voice_translation_page`) | Dialogue vocal / texte avec Gemini |

---

## 🛠️ Technologies

| Technologie | Rôle dans le projet |
|---|---|
| **Flutter / Dart** | Framework mobile cross-platform et langage |
| **TensorFlow Lite** (`flutter_tflite`) | Modèle d'IA embarqué exécuté sur l'appareil |
| **Firebase Auth** (`firebase_core`, `firebase_auth`) | Authentification et gestion des comptes |
| **Google Gemini** (`google_generative_ai`) | Assistant conversationnel / traduction |
| **Speech-to-Text** (`speech_to_text`) | Reconnaissance vocale |
| **Image Picker** (`image_picker`) | Accès caméra / galerie |
| **Material 3** | Système de design de l'interface |

---

## 🏗️ Architecture

Application mobile **Flutter** organisée en **écrans (screens)** naviguant via les
routes nommées de `MaterialApp`. Le modèle d'IA et ses libellés sont chargés comme
**assets** au démarrage de l'écran de prédiction.

```text
lib/
├── main.dart                     # Point d'entrée, thème, routes nommées, init Firebase
├── firebase_options.dart         # Configuration Firebase (web / android / ios)
└── screens/
    ├── login_screen.dart         # Connexion Firebase
    ├── register_screen.dart      # Inscription + profil
    ├── home_page.dart            # Accueil + menu latéral
    ├── fruit_pred_page.dart      # Inférence TFLite (caméra/galerie → fruit + confiance)
    └── voice_translation_page.dart # Assistant vocal Gemini

assets/
└── model/
    ├── model.tflite              # Modèle de classification (10 classes)
    └── labels.txt                # Libellés des classes
```

**Flux de prédiction (edge AI) :**

```text
Caméra / Galerie ──► ImagePicker ──► Prétraitement image
                                              │
                                   Tflite.runModelOnImage (local)
                                              │
                                     Top-1 : fruit + confiance
```


---

## 📸 Captures d'écran

| Connexion | Inscription |
|---|---|
| ![Connexion](./docs/screenshots/01_connexion.png) | ![Inscription](./docs/screenshots/02_inscription.png) |

| Accueil | Prédiction de fruit |
|---|---|
| ![Accueil](./docs/screenshots/03_accueil.png) | ![Prédiction](./docs/screenshots/04_prediction_fruit.png) |

| Traduction vocale |
|---|
| ![Traduction vocale](./docs/screenshots/05_traduction_vocale.png) |

---

## 🎯 Compétences démontrées

- **Développement mobile cross-platform** avec Flutter/Dart et Material 3.
- **Intégration d'un modèle d'IA embarqué** (TensorFlow Lite) et inférence on-device.
- **Consommation d'API d'IA générative** (Google Gemini) via SDK.
- **Authentification et gestion de session** avec Firebase Auth.
- **Gestion d'assets** (modèle + libellés) et de la navigation multi-écrans.
- **Sécurité appliquée** : retrait d'une clé API codée en dur au profit d'une
  injection au build (`--dart-define`).

## 🤝 Lien Data Science / IA

Ce projet est la **brique « déploiement » (MLOps / edge)** d'une chaîne Data Science :
un modèle de classification d'images, une fois **entraîné** (ex. Transfer Learning sur
un CNN type MobileNet), est **converti en TensorFlow Lite** puis **embarqué et servi
dans une application mobile**. Il illustre le passage du notebook à l'application :

> entraînement du modèle → conversion `.tflite` → inférence on-device → restitution UI

Compétences transverses valorisées : compréhension du **cycle de vie d'un modèle**
(entraînement, quantification, déploiement), de l'**inférence temps réel**, et des
enjeux **latence / confidentialité** de l'IA en périphérie (*edge AI*).

---

## 🚀 Lancer le projet

**Prérequis :** [Flutter SDK](https://docs.flutter.dev/get-started/install) (Dart SDK
`^3.5.4`), Android Studio / Xcode pour l'émulateur, et un projet Firebase configuré.

```bash
# 1. Installer les dépendances
flutter pub get

# 2. Lancer l'application sur un appareil / émulateur connecté
flutter run
```

> ⚠️ L'inférence TensorFlow Lite via `flutter_tflite` fonctionne sur **Android / iOS**
> (mobile). La classification n'est pas disponible sur le **web**.

### 🔑 Configurer l'assistant vocal (Google Gemini)

La clé API n'est **pas** stockée dans le code. Fournissez-la au lancement via
`--dart-define` :

```bash
flutter run --dart-define=GEMINI_API_KEY=votre_cle_gemini
```

### 🔥 Configurer Firebase

```bash
# Installer la CLI FlutterFire puis régénérer la configuration si besoin
dart pub global activate flutterfire_cli
flutterfire configure
```

---

## ⚠️ Limites et perspectives

- **Entraînement du modèle non versionné ici** : le `model.tflite` est fourni prêt à
  l'emploi ; le notebook/script d'entraînement (Transfer Learning, jeu de données
  d'images) pourrait être ajouté pour rendre la chaîne reproductible de bout en bout.
- **Classification mobile uniquement** : le chemin web affiche un message dédié.
- **Clé API Gemini** : correctement externalisée, mais une bonne pratique supplémentaire
  serait de passer par un backend proxy pour ne jamais exposer la clé côté client.
- **Perspectives** : nombre de classes plus élevé, affichage du **top-3** des
  prédictions, historique local des analyses, et quantification du modèle pour
  réduire encore sa taille.

---

## 🇬🇧 English

Cross-platform **Flutter** mobile app that identifies a fruit from a photo using an
**on-device TensorFlow Lite** model (offline). It adds **Firebase Auth** and a
**voice assistant** (speech-to-text + Google Gemini). Detailed report in
[`docs/RAPPORT_FINAL.md`](./docs/RAPPORT_FINAL.md). Run with `flutter pub get` then
`flutter run`; provide the Gemini key via `--dart-define=GEMINI_API_KEY=...`.
On-device inference works on Android/iOS (not on web).

### Auteure / Author
**Kawtar Boughal** — [GitHub](https://github.com/kawtarboughal02) · [LinkedIn](https://www.linkedin.com/in/kawtar-boughal02)
