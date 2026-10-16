# docker-buildx-multiarch

> **Reference configuration.** `docker buildx bake --print` confirmed the bake file parses and expands, and `docker build --check` reports no Dockerfile warnings. No image was built, no multi-platform build was run, and the GitHub workflow **has never run**.

One image for both `linux/amd64` and `linux/arm64` (Intel/AMD servers and Apple Silicon or Graviton), built with a declarative bake file and a GitHub Actions workflow.

```
docker buildx bake --print        # show what would be built
docker buildx bake local          # build amd64 into the local Docker
docker buildx bake app --push     # multi-platform, push (needs a registry login)
```

## Why it matters

A customer on arm64 pulling an amd64-only image gets `exec format error`. A multi-platform image is one tag with a manifest listing one image per platform; Docker pulls the matching one.

## Pieces

- **`Dockerfile`**: `FROM --platform=$BUILDPLATFORM` runs build steps natively on the build machine; `TARGETARCH` is available to select per-architecture assets. Cross-compiling beats emulating when the language allows it.
- **`docker-bake.hcl`**: platforms, tags, labels and cache in one file, with variables and a `local` target for single-platform runs.
- **Registry cache** (`cache-from`/`cache-to`): CI runners start empty, so the layer cache lives in the registry.
- **`build.yml`**: QEMU for emulation, Buildx, login with the automatic `GITHUB_TOKEN`, bake. Least-privilege permissions.

## Trade-offs

- Emulated arm64 builds under QEMU are slow (often 5 to 20 times). Native arm64 runners or cross-compilation are faster.
- The first multi-platform build must be pushed or exported; `--load` into the local Docker supports one platform only.
- Actions are pinned by major version tag, not commit SHA.

## Not checked

Everything beyond parsing: the build, QEMU emulation, the cache refs, pushing to GHCR, and whether the `v4`/`v7` major tags behave as expected.

MIT licensed.
