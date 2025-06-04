#!/usr/bin/env bash

set -euo pipefail

dnf config-manager --add-repo "https://repo.secureblue.dev/secureblue.repo"
dnf config-manager --set-disabled "secureblue"
dnf -y --enablerepo "secureblue" --nogpgcheck  install trivalent


