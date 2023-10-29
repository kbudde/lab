#!/bin/env bash

base=rendered/envs/zoo

export AVP_TYPE=sops

for app in "$base"/*; do
  argocd-vault-plugin generate "$base/$app" | kapp deploy -y -c -a "$app" -f -
done