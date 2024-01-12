#!/bin/env bash

set -e

# "MYKS_ENV":              a.e.Id,
# "MYKS_APP":              a.Name,
# "MYKS_APP_PROTOTYPE":    a.Prototype,
# "MYKS_ENV_DIR":          a.e.Dir,
# "MYKS_RENDERED_APP_DIR": "rendered/envs/" + a.e.Id + "/" + a.Name, // TODO: provide func and use it everywher

export AVP_TYPE=sops

kapp_diff(){
    local app=$1
    local dir=$2
    echo argocd-vault-plugin generate "$dir"
    argocd-vault-plugin generate "$dir" >> /dev/null 
    argocd-vault-plugin generate "$dir" | kapp deploy -a "$app" --diff-changes --diff-run -f -
}


kapp_diff "$MYKS_APP"  "$MYKS_RENDERED_APP_DIR"