#!/bin/env bash

base=rendered/envs/zoo

export AVP_TYPE=sops

for app in "$base"/*; do
  echo "argocd-vault-plugin generate \"$app\" | kapp deploy  -c -a \"${app#"$base/"}\" -f -"
  argocd-vault-plugin generate "$app" | kapp deploy -y -c -a "${app#"$base/"}" -f - --apply-default-update-strategy fallback-on-replace
done