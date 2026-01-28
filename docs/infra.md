#  Infrastructure Azure

L'infrastructure est déployée de manière automatisée sur **Azure** à l'aide de **Terraform**.

## Schéma de l'Architecture
L'infrastructure se compose des éléments suivants :
- **Resource Group** : `tp-web-rg` (Conteneur logique).
- **Réseau Virtuel (VNet)** : Un espace d'adressage en `10.0.0.0/16`.
- **Subnet** : Un sous-réseau dédié en `10.0.1.0/24`.
- **IP Publique** : Une adresse IP statique pour accéder au serveur web.
- **Carte Réseau (NIC)** : Interface de la VM liée à l'IP publique.
- **Machine Virtuelle** : Ubuntu Server 22.04 LTS (Taille : Standard_B1s).
- **Identité** : Managed Identity activée (System Assigned).

## Authentification & Identité
Nous avons activé la **System Assigned Managed Identity** sur la VM.
Cela supprime le besoin de gérer des "Service Principals" ou des clés d'accès stockées en dur sur la machine. L'identité de la VM est gérée automatiquement par Azure AD.

## Gestion du State
Pour permettre l'idempotence et éviter les conflits lors des déploiements via GitHub Actions, nous utilisons un **Backend distant** :
- **Storage Account** : `syhar3ilstate`
- **Conteneur** : `tfstate`

Cela permet à Terraform de garder en mémoire les ressources déjà créées.