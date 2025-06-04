#!/usr/bin/env bash

set -euo pipefail

dnf -y --enablerepo https://repo.secureblue.dev/secureblue.repo --nogpgcheck  install trivalent


