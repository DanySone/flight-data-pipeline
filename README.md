# ✈️ Aviation Analytics Pipeline

Une pipeline ELT moderne pour analyser le trafic aérien mondial en temps réel.

## 🏗️ Architecture
- **Source** : OpenSky Network API
- **Ingestion** : Python (Pandas) via GitHub Actions
- **Data Warehouse** : Google BigQuery
- **Transformation** : dbt Core (Architecture Staging/Marts)

## 📊 Modélisation dbt
Le projet suit les bonnes pratiques d'Analytics Engineering :
- `staging/` : Nettoyage et typage des données brutes.
- `marts/` : Création de tables analytiques (Vitesse moyenne, densité par pays).

## 🚀 Comment ça marche ?
Le script s'exécute automatiquement toutes les heures via GitHub Actions, alimentant BigQuery sans coût d'infrastructure.