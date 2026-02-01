variable "TAG" {
  default = "latest"
}

variable "REPO" {
  default = "taha2samy/qr-maker-app"
}

group "default" {
  targets = ["app"]
}

target "app" {
  context    = "."
  dockerfile = "Dockerfile"
  
  platforms  = ["linux/amd64", "linux/arm64"]
  
  tags       = ["${REPO}:${TAG}"]
  
  cache-from = ["type=registry,ref=${REPO}:buildcache"]
  cache-to   = ["type=registry,ref=${REPO}:buildcache,mode=max"]
  
  attest = [
    "type=provenance,mode=max",
    "type=sbom"
  ]
  # -------------------------

  output     = ["type=image,push=true"]
}