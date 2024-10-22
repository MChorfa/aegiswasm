#!/bin/bash

# Exit immediately if a command exits with a non-zero status
set -e
# Print commands and their arguments as they are executed
set -x

# Function to create directories
create_directories() {
  local base_dir=$1
  shift
  local dirs=("$@")

  for dir in "${dirs[@]}"; do
    local full_path="$base_dir/$dir"
    if [[ ! -d "$full_path" ]]; then
      mkdir -p "$full_path"
    fi
  done
}

# Function to create files
create_files() {
  local base_dir=$1
  shift
  local files=("$@")

  for file in "${files[@]}"; do
    local file_path="$base_dir/$file"
    if [[ ! -f "$file_path" ]]; then
      touch "$file_path"
    fi
  done
}

# Main Project Structure
create_directories "." \
  ".github/workflows" "dagger/pipelines" "docs/api/grpc-protos" \
  "internal/core" "internal/services" "internal/utils" \
  "crates/orchestrator/src" "crates/executor/src" "crates/plugin-system/src" \
  "crates/wasm-pipeline/src" "crates/observability/src/dashboards" "crates/observability/src/alerts" \
  "cmd/orchestrator" "cmd/executor" "deployments/k8s-operator" "deployments/porter-bundles" \
  "scripts" "tests/unit" "tests/integration" "tests/e2e" "tests/benchmarks" "tests/fuzz_tests" \
  "configs/dev" "configs/prod" "configs/staging" "configs/testing" "security/sbom" "security/policies" "security/scanners" \
  "proto"

# Create Root-Level Files
create_files "." "Cargo.toml" "LICENSE" "README.md"

# CI/CD Workflow
create_files ".github/workflows" "ci-cd.yml"

# Dagger Configuration
create_files "dagger" "dagger.yaml"
create_files "dagger/pipelines" "build_pipeline.go" "deploy_pipeline.go"

# Documentation Files
create_files "docs" "architecture.md" "ddd-models.md" "hexagonal-arch.md" "clean-arch.md"
create_files "docs/api/grpc-protos" "model_registry.proto"

# Internal Libraries
create_files "internal/core" "lib.rs"
create_files "internal/services" "model_registry.rs" "feature_store.rs"
create_files "internal/utils" "mod.rs"

# Crates
create_files "crates/orchestrator" "Cargo.toml" "README.md"
create_files "crates/orchestrator/src" "lib.rs"
create_files "crates/executor" "Cargo.toml" "README.md"
create_files "crates/executor/src" "lib.rs"
create_files "crates/plugin-system" "Cargo.toml" "README.md"
create_files "crates/plugin-system/src" "lib.rs" "loader.rs" "registry.rs"
create_files "crates/wasm-pipeline" "Cargo.toml" "README.md"
create_files "crates/wasm-pipeline/src" "lib.rs" "compiler.rs" "runtime.rs"
create_files "crates/observability" "Cargo.toml" "README.md"
create_files "crates/observability/src" "lib.rs" "telemetry.rs" "metrics.rs" "ai-monitoring.rs"

# CLI Binaries
create_files "cmd/orchestrator" "main.rs"
create_files "cmd/executor" "main.rs"

# Deployment Configurations
create_files "deployments/k8s-operator" "deployment.yaml"
create_files "deployments/porter-bundles" "porter.yaml"

# Scripts
create_files "scripts" "setup.sh" "run-tests.sh" "deploy.sh" "lint.sh"

# Tests
create_files "tests/unit" "test_main.rs"
create_files "tests/integration" "test_integration.rs"
create_files "tests/e2e" "test_e2e.rs"
create_files "tests/benchmarks" "performance_benchmark.rs"
create_files "tests/fuzz_tests" "fuzz_test.rs"

# Configurations
create_files "configs/dev" "config.yaml"
create_files "configs/prod" "config.yaml"
create_files "configs/staging" "config.yaml"
create_files "configs/testing" "config.yaml"
create_files "configs" "feature_flags.yaml"

# Protobufs and Buf Configuration
create_files "proto" "model_registry.proto"
create_files "proto" "buf.yaml"

# Security Tools
create_files "security/sbom" "generate_sbom.sh"
create_files "security/policies" "security_policy.md"
create_files "security/scanners" "vuln_scan.sh"

# Workspace Cargo.toml
cat <<EOL > Cargo.toml
[workspace]
members = [
    "crates/orchestrator",
    "crates/executor",
    "crates/plugin-system",
    "crates/wasm-pipeline",
    "crates/observability"
]
EOL

# Initialize Git Repository (if not already initialized)
if [[ ! -d .git ]]; then
  git init
fi

# Add and commit changes
git add .
if git commit -m "Initial setup for AegisWasm ML Toolkit"; then
  git push origin main || { echo "Git push failed"; exit 1; }
else
  echo "Git commit failed"
  exit 1
fi

# End of Script
echo "AegisWasm ML Toolkit setup complete!"