#!/bin/env bash
set -e

base=rendered/envs/zoo

export AVP_TYPE=sops

apply_app(){
  local app=$1
  local app_name=${app#"$base/"}
  echo "argocd-vault-plugin generate \"$app\" | kapp deploy  -c -a \"$app_name\" -f -"
  #! Warning errors not handled and workload is deleted from the cluster :)
  argocd-vault-plugin generate "$app" >> /dev/null || (echo "Error generating $app_name failed" && exit 1)
  argocd-vault-plugin generate "$app" | kapp deploy -y -c -a "$app_name" -f - --apply-default-update-strategy fallback-on-replace
}

# check if parameter are passed
if [ $# -eq 0 ]; then
  for app in "$base"/*; do
    apply_app "$app"
  done
else
  for app in "$@"; do
    apply_app "$base/$app"
  done
fi


