#!/bin/env bash

base=rendered/envs/zoo
apps=$(ls $base)

export AVP_TYPE=sops

for app in $apps; do
  argocd-vault-plugin generate "$base/$app" | kapp deploy -c -a "$app" -f -
done