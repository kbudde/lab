# personal pi cluster k8s manifests

Rendered manifests using [github.com/mykso/myks](https://github.com/mykso/myks).

## Secret management

Secrets are managed using sops with age and [argocd-vault-plugin](https://argocd-vault-plugin.readthedocs.io/).

Secrets are stored in yaml files in `secrets/.*\.yaml`. They are encrypted using sops with age. Recipient is configured in .sops.yaml.

Editing files is simple: `sops secrets/demo.yaml`

Rendering kubernetes resources: `argocd-vault-plugin generate rendered/envs/demo` will spit out manifests with secrets.

### How are secrets configured

Special syntax: "<path:secrets/file.yaml#key>"

```yaml
apiVersion: v1
kind: Secret
metadata:
  annotations:
    a8r.io/repository: ""
  labels:
    app.kubernetes.io/name: argocd-secret
    app.kubernetes.io/part-of: argocd
  name: argocd-secret
  namespace: argocd
type: Opaque
stringData:
  foo: bar
  encrypted: <path:secrets/demo.yaml#myKey>
```

Warning: sops as [backend](https://argocd-vault-plugin.readthedocs.io/en/stable/backends/#sops) in argocd-vault-plugin does not support nested keys or versions like vault.

```yaml
parent:
  child: value
```

```yaml
kind: Secret
apiVersion: v1
metadata:
  name: test-secret
type: Opaque
stringData:
  password: <path:example.yaml#parent | jsonPath {.child}>
```

## deployment

Manual for now using deploy.sh

```sh
#!/bin/env bash

base=rendered/envs/some-env
apps=$(ls $base)

for app in $apps; do
  argocd-vault-plugin generate "$base/$app" | kapp deploy -y -a "$app" -f -
done
```

## Todos

- [x] Generate ns resources for each app
- [ ] automate deployment
  - [ ] Create own age key for each cluster and store key in cluster?

