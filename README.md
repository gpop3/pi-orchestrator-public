> ⚠️ **Note :** Ceci est un miroir public et en lecture seule du dépôt privé original. Pour des raisons de sécurité et afin d'éviter tout accès malveillant aux runners privés, les modifications et Pull Requests doivent être soumises uniquement sur le dépôt source.

# Pi-Orchestrator

## Présentation

Infrastructure personnelle pour orchestrer une Raspberry Pi dédiée à la maison.
     
La Raspberry héberge notamment :

- Home Assistant ;
- un conteneur Python qui contacte une IA et envoie une découverte du jour sur WhatsApp ;
- un runner GitHub Actions self-hosted pour automatiser les déploiements.

Le projet est organisé autour de trois couches :

- **Bootstrap** : initialise la Raspberry au minimum.
- **Ansible** : configure le système.
- **OpenTofu** : déploie et orchestre les services applicatifs Docker.

---

## Architecture du projet
Schéma d'architecture simplifié 
```text
               ┌────────────────────────┐
               │    GitHub Repository   │ (Code)
               └───────────┬────────────┘
                           │  Trigger (Push / PR)
                           ▼
 ┌───────────────────────────────────────────────────┐
 │                   Raspberry Pi                    │ (Infrastructure Local)
 │                                                   │
 │  ┌───────────────┐ ┌──────────────┐ ┌──────────┐  │
 │  │ HomeAssistant │ │ Python (app) │ │ GHA      │  │
 │  │ (Domotique)   │ │ (IA Agent)   │ │ Runner   │  │
 │  └───────┬───────┘ └──────┬───────┘ └────┬─────┘  │
 │          │                │              │        │
 └──────────┼────────────────┼──────────────┼────────┘
            │                │              │
            ▼                ▼              ▼
     [Objets Connectés]  [APIs Extérieures] [Commandes Locales]
     (Zigbee/Wi-Fi/IP)   (Anthropic/Twilio) (Ansible & OpenTofu)
```

---

## Responsabilités

### Bootstrap

Le dossier `bootstrap/` sert uniquement à préparer la Raspberry pour que l’automatisation puisse prendre le relais.

Il installe :

- Python ;
- Git ;
- Ansible ;
- les dépendances minimales nécessaires ;
- un runner GitHub Actions self-hosted.

Le bootstrap ne doit pas configurer toute la machine.  
La configuration complète est gérée par Ansible.

### Ansible

Le dossier `ansible/` configure l’OS de la Raspberry.

Il gère notamment :

- la mise à jour du système ;
- l’installation des paquets de base ;
- la création de l’utilisateur principal ;
- la configuration SSH ;
- l’installation de Docker ;
- l’installation d’OpenTofu ;
- les dossiers applicatifs ;
- la maintenance système ;
- les mises à jour automatiques.

### OpenTofu

La dernière couche utilise OpenTofu pour déclarer et instancier les conteneurs applicatifs. L'état (state) est stocké localement.

Déploiement des services
Depuis le dossier opentofu/ :

- tofu init
- tofu plan
- tofu apply -auto-approve

---

## Prérequis

### Matériel

- Raspberry Pi ;
- Raspberry Pi OS ou distribution compatible Debian ;
- accès réseau ;
- Docker supporté sur l’architecture de la Raspberry.

---

## Bootstrap

Le dossier `bootstrap/` contient le script d’amorçage initial de la Raspberry Pi.

Son rôle est volontairement limité :

- installer Python ;
- installer Git ;
- installer Ansible ;
- préparer le runner GitHub Actions self-hosted.

La configuration complète de la machine est ensuite gérée par Ansible.

### Structure

```text
bootstrap/
├── kickstart.sh
├── lib/
│   ├── common.sh
│   └── config.sh
└── tasks/
    ├── 00-preflight.sh
    ├── 10-install-bootstrap-packages.sh
    ├── 20-create-runner-user.sh
    ├── 30-install-github-runner.sh
    └── 40-print-next-steps.sh
```

### Rendre les scripts exécutables

Depuis la racine du projet :

```bash
chmod +x bootstrap/kickstart.sh
chmod +x bootstrap/tasks/*.sh
chmod +x bootstrap/lib/*.sh
```

### Lancer le bootstrap

Depuis la racine du projet :

```bash
./bootstrap/kickstart.sh
```

### Lancer avec des variables personnalisées

Il est possible de surcharger certaines variables sans modifier les fichiers.

Exemple :

```bash
GITHUB_RUNNER_NAME="raspberry-prod" \
GITHUB_RUNNER_LABELS="raspberry,self-hosted,home,prod" \
GITHUB_RUNNER_USER="github-runner" \
./bootstrap/kickstart.sh
```

### Après l’exécution

Une fois le bootstrap terminé, le script affiche les étapes à suivre pour connecter le runner GitHub Actions au repository.

Résumé des commandes à exécuter ensuite sur la Raspberry :

```bash
sudo -u github-runner bash
cd /opt/github-runner
```

Puis lancer la commande fournie par GitHub, par exemple :

```bash
./config.sh \
  --url https://github.com/<owner>/<repo> \
  --token <token> \
  --name raspberry-pi \
  --labels raspberry,self-hosted,home \
  --unattended
```

Installer ensuite le runner comme service :

```bash
sudo /opt/github-runner/svc.sh install github-runner
sudo /opt/github-runner/svc.sh start
```

Vérifier le statut :

```bash
sudo /opt/github-runner/svc.sh status
```

Quand le runner est actif, il doit apparaître en ligne dans GitHub Actions.

---

## Pipeline CI/CD (GitOps & DevSecOps)

Le projet intègre un workflow **GitHub Actions** hautement sécurisé et industrialisé qui s'exécute directement sur la Raspberry Pi (`runs-on: raspberry`) via son runner *self-hosted*.

Toute modification de l'infrastructure ou des applications suit un cycle de validation rigoureux avant d'être déployée.

### 1. Sécurité Statique (DevSecOps)
Avant toute action, le code subit une analyse de vulnérabilité :
- **Gitleaks** : Scanne l'intégralité du dépôt à la recherche de secrets, clés d'API ou mots de passe qui auraient pu être commités par erreur.
- **Checkov** : Analyse statique de l'Infrastructure as Code (IaC) pour détecter d'éventuelles failles de sécurité ou mauvaises configurations dans les fichiers OpenTofu/Ansible.

### 2. Couche Système (Ansible)
- **Validation** : Validation de la syntaxe du playbook et exécution de `ansible-lint` (configuré en mode strict sur les branches de feature pour garantir la qualité du code, et permissif sur `main`).
- **Déploiement** : Si les tests passent (sur un `push` ou un déclenchement manuel), le playbook `site.yml` est appliqué pour mettre à jour et configurer l'OS de la Raspberry Pi.

### 3. Couche Applicative (OpenTofu)
- **Validation** : Vérification du formatage (`tofu fmt`), initialisation sans backend et validation de la cohérence des fichiers de configuration (`tofu validate`).
- **Déploiement** : Injection sécurisée des secrets d'environnement (Tokens GHCR, clés d'API Anthropic/Twilio) via GitHub Secrets. Génération d'un plan d'exécution (`tofu plan`) puis application automatique (`tofu apply`) pour instancier les conteneurs.

### 4. Santé
Une fois l'infrastructure déployée :
- **Healthcheck** : Vérification finale en direct de l'état des conteneurs (`docker ps`).

---

## Gestion des Secrets & Concurrence

- **Protection des données** : Toutes les clés sensibles (Anthropic, Twilio, Docker Registry) sont centralisées dans l'environnement sécurisé `raspberry-maison` de GitHub et injectées dynamiquement au moment du runtime.
- **Verrouillage des exécutions** : Le workflow utilise un groupe de concurrence (`raspberry-infrastructure`). Si plusieurs modifications sont poussées en même temps, elles s'exécutent l'une après l'autre sans jamais bloquer ou corrompre l'état (*state*) de la machine.
