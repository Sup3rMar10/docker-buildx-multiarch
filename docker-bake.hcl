variable "REGISTRY" { default = "ghcr.io/sup3rmar10" }
variable "TAG"      { default = "dev" }

group "default" { targets = ["app"] }

target "app" {
  context    = "."
  dockerfile = "Dockerfile"
  platforms  = ["linux/amd64", "linux/arm64"]
  tags       = ["${REGISTRY}/buildx-demo:${TAG}"]
  cache-from = ["type=registry,ref=${REGISTRY}/buildx-demo:cache"]
  cache-to   = ["type=registry,ref=${REGISTRY}/buildx-demo:cache,mode=max"]
  labels = {
    "org.opencontainers.image.source" = "https://github.com/Sup3rMar10/docker-buildx-multiarch"
  }
}

# Local, single-platform, loads into the local Docker: docker buildx bake local
target "local" {
  inherits   = ["app"]
  platforms  = ["linux/amd64"]
  cache-from = []
  cache-to   = []
  output     = ["type=docker"]
}
