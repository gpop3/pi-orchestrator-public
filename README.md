# Pi-Orchestrator

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

---

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

---

### OpenTofu

Le dossier `opentofu/` gère la couche applicative.

---

## Prérequis

### Matériel

- Raspberry Pi ;
- Raspberry Pi OS ou distribution compatible Debian ;
- accès réseau ;
- Docker supporté sur l’architecture de la Raspberry.

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
