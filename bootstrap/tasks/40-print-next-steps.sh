#!/usr/bin/env bash

set -euo pipefail

cat <<EOF

Bootstrap terminé.

Pour connecter le runner à GitHub :

1. Va dans ton repository GitHub :
   Settings > Actions > Runners > New self-hosted runner

2. Choisis Linux et l'architecture correspondante.

3. GitHub va te donner une commande du type :
   ./config.sh --url https://github.com/<owner>/<repo> --token <token>

4. Exécute la configuration du runner :

   sudo -u ${GITHUB_RUNNER_USER} bash
   cd ${GITHUB_RUNNER_DIR}
   ./config.sh \\
     --url https://github.com/<owner>/<repo> \\
     --token <token> \\
     --name ${GITHUB_RUNNER_NAME} \\
     --labels ${GITHUB_RUNNER_LABELS} \\
     --unattended

5. Installe et démarre le service :

   sudo ${GITHUB_RUNNER_DIR}/svc.sh install ${GITHUB_RUNNER_USER}
   sudo ${GITHUB_RUNNER_DIR}/svc.sh start

6. Vérifie le statut :

   sudo ${GITHUB_RUNNER_DIR}/svc.sh status

Ensuite, GitHub Actions pourra lancer Ansible puis OpenTofu sur la Raspberry.

EOF