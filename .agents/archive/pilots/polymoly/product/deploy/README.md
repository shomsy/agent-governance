# Product Deploy README

`product/deploy/` is the deploy pipeline slice of PolyMoly.

The canonical shape is:

```text
deploy/
  deploy_pipeline.go
  install/
  release/
    prepare/
    verify/
  validate/
    runtime/
```

Meaning:

- `install/` installs an already-built Poly binary into one project
- `release/prepare/` prepares release-facing distribution surfaces
- `release/verify/` writes proof and evidence artifacts around a release
- `validate/runtime/` validates that a promoted or staged runtime claim is still honest

This folder starts after source checkout.
`git clone polymoly` is earlier than this slice.
