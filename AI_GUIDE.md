# 🚀 Guide de développement - Labé Market (Flutter + Firebase)

## 🎯 Objectif du projet
Créer une application mobile Flutter appelée **Labé Market** permettant de connecter les producteurs agricoles de Labé avec les acheteurs.

L'application doit être :
- simple
- rapide
- accessible aux utilisateurs peu expérimentés
- fonctionnelle hors ligne (concept SMS)

---

## 🧱 Architecture générale

Le projet Flutter doit être structuré comme suit :

lib/
│
├── screens/        # Écrans de l’application
├── widgets/        # Composants réutilisables
├── models/         # Modèles de données
├── services/       # Firebase + logique métier
├── utils/          # Constantes et helpers

---

## 📱 Écrans principaux

L’application comporte les écrans suivants :

1. Authentification :
   - welcome_screen.dart
   - login_screen.dart
   - register_screen.dart

2. Application principale :
   - home_screen.dart (liste produits)
   - add_product_screen.dart
   - product_detail_screen.dart
   - profile_screen.dart
   - favorites_screen.dart
   - notifications_screen.dart
   - map_screen.dart

---

## 🔥 Firebase

Utiliser Firebase :

- Firestore → produits
- Auth → utilisateurs (simple)
- Storage → images produits

### Structure Firestore :

Collection : products

- id
- name (String)
- price (int)
- quantity (int)
- location (String)
- phone (String)
- imageUrl (String)
- createdAt (Timestamp)
- userId (String)

---

## ⚙️ Règles importantes

- Toujours écrire du code propre et lisible
- Utiliser des widgets réutilisables
- Séparer la logique et l’UI
- Ne pas complexifier inutilement
- Priorité à la rapidité et stabilité

---

## 🎨 Design UI

Respecter le design suivant :

- Couleur principale : vert (#2E7D32)
- Couleur secondaire : orange (#F57C00)
- Design moderne, minimaliste
- Boutons larges et accessibles
- Interface simple pour utilisateurs ruraux

---

## 🧩 Fonctionnalités MVP (OBLIGATOIRE)

- Ajouter un produit
- Voir la liste des produits
- Voir les détails d’un produit
- Contacter le producteur (appel / WhatsApp)

---

## 🚀 Bonus fonctionnalités

- Mode hors ligne (affichage)
- Icône audio pour assistance
- Géolocalisation (carte)
- Favoris
- Notifications

---

## 📌 Bonnes pratiques Flutter

- Utiliser setState ou Provider (simple)
- Eviter les packages inutiles
- Garder les écrans simples
- Pas de logique lourde dans UI

---

## ⚠️ Contraintes hackathon

- Temps limité → priorité au MVP
- L’application doit fonctionner sans bug
- Préparer la démo (important)

---

## 🎤 Objectif final

Créer une application :
- fluide
- utile
- impressionnante visuellement

pour gagner le hackathon.

