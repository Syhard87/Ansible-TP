#  TP DevSecOps - Infrastructure Azure

Bienvenue sur la documentation technique de notre projet d'infrastructure.
Ce site est généré automatiquement via **GitHub Actions** et hébergé sur **GitHub Pages**.

---

##  Vue d'ensemble
Ce projet implémente une approche **DevSecOps** complète pour déployer une application Web sécurisée sur Microsoft Azure.

###  Stack Technique
| Domaine | Outil utilisé | Rôle |
| :--- | :--- | :--- |
| **Infrastructure as Code** |  **Terraform** | Déploiement de la VM, Réseau, Disques |
| **Configuration** |  **Ansible** | Installation et sécurisation d'Apache |
| **CI/CD** |  **GitHub Actions** | Orchestration de tous les jobs |
| **Qualité & Sécurité** |  **SonarCloud** + **tfsec** | Analyse statique code & infra (SAST/IaC) |
| **FinOps** |  **Infracost** | Estimation des coûts avant déploiement |
| **Identité** |  **Managed Identity** | Authentification Azure sans secrets |



##  Notre Workflow CI/CD

Chaque modification du code (`git push`) déclenche un pipeline automatisé composé de 4 jobs parallèles :

1.  **Infrastructure & Config** : Provisioning Terraform et configuration Ansible.
2.  **Qualité & Sécurité** : Analyse SonarCloud et Scan IaC (`tfsec`).
3.  **FinOps** : Estimation du coût mensuel avec Infracost.
4.  **Documentation** : Génération et déploiement du site MkDocs.

---

```mermaid
graph TD

Dev[Developpeur] -->|"git push"| Repo[GitHub Repository]

subgraph CI_CD[GitHub Actions Pipeline]
  direction TB
  Repo --> Start((Start Workflow))

  subgraph Infrastructure[Job: Infra & Config]
    direction TB
    Start -->|"Job 1"| J_Infra[Provisioning]
    J_Infra --> TF[Terraform Apply]
    TF -->|"Cree VM & IP"| Azure[Azure Resources]
    Azure --> Ans[Ansible Config]
    Ans -->|"Installe Apache"| VM[Serveur Web]
    VM --> Test[Tests Fonctionnels]
  end

  subgraph Quality[Job: SonarCloud]
    Start -->|"Job 2"| J_Sonar[Analyse Qualite]
    J_Sonar --> Scan[SonarScanner]
    Scan -->|"Envoi Rapport"| Dash[SonarCloud Dashboard]
  end

  subgraph Cost[Job: Estimation Couts]
    Start -->|"Job 3"| J_FinOps[FinOps]
    J_FinOps --> InfraCost[Infracost Calc]
    InfraCost -->|"Genere"| Markdown[finops.md]
    Markdown -->|"Auto Commit"| Repo
  end

  subgraph Documentation[Job: Deploy Docs]
    Start -->|"Job 4"| J_Docs[Documentation]
    J_Docs --> Build[MkDocs Build]
    Build -->|"Inclut finops.md"| Site[Site Statique]
    Site -->|"Deploy"| GHP[GitHub Pages]
  end
end

Repo -.->|"Mise a jour Prix"| J_Docs
Test -.->|"Valide"| J_Docs
```
