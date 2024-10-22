#!/bin/bash

# Exit immediately if a command exits with a non-zero status
set -e  
# Print commands and their arguments as they are executed
set -x  

# Root directory Path
ROOT_DIR=$(pwd)

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

### Main Project Structure for AegisWasm ML Toolkit
create_directories "." \
  ".github/workflows" "docs/api/grpc-protos" "cmd/orchestrator" "cmd/executor" \
  "src/orchestrator" "src/executor" "src/plugin" "src/model_registry" \
  "src/feature_store" "src/wasm_pipeline" "src/utils" \
  "crates/core" "crates/executor" "crates/orchestrator" "crates/plugins" \
  "plugins/pqc" "plugins/differential_privacy" "plugins/confidential_comp" "plugins/antivirus_scanning" \
  "deployments/k8s-operator" "deployments/porter-bundles" \
  "observability/telemetry" "observability/metrics" "observability/ai_observability" \
  "scripts" "tests/unit" "tests/integration" "tests/e2e" \
  "configs/dev" "configs/prod" "proto" "tools/buf" "tools/linters"

# GitHub Actions Workflow for CI/CD
create_files ".github/workflows" "ci-cd.yml"
cat <<EOL > .github/workflows/ci-cd.yml
name: CI/CD Pipeline
on: [push, pull_request]
jobs:
  build:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v2
      - name: Install Rust
        uses: actions-rs/toolchain@v1
        with:
          toolchain: stable
          profile: minimal
          override: true
      - name: Build Project
        run: cargo build --workspace --release
      - name: Run Tests
        run: cargo test --workspace --all-features
      - name: Lint Code
        run: cargo clippy --all-targets --all-features -- -D warnings
EOL

# Documentation Structure
create_files "docs" "architecture.md" "usage.md"
create_files "docs/api/grpc-protos" "model_registry.proto"

# Command-Line Binaries for Orchestrator and Executor
create_files "cmd/orchestrator" "main.rs"
create_files "cmd/executor" "main.rs"

# Source Code Structure
create_files "src/orchestrator" "lib.rs" "raft.rs"
create_files "src/executor" "lib.rs" "wasm_executor.rs"
create_files "src/plugin" "lib.rs" "interface.rs"
create_files "src/model_registry" "lib.rs" "metadata.rs"
create_files "src/feature_store" "lib.rs" "storage.rs"
create_files "src/wasm_pipeline" "lib.rs" "pipeline.rs"
create_files "src/utils" "mod.rs" "helpers.rs"

# Core Crate Setup
create_files "crates/core" "Cargo.toml" "README.md"
cat <<EOL > crates/core/Cargo.toml
[package]
name = "core"
version = "0.1.0"
edition = "2021"

[dependencies]
serde = { version = "1.0", features = ["derive"] }
tokio = { version = "1.0", features = ["full"] }
EOL

# Executor Crate Setup
create_files "crates/executor" "Cargo.toml" "README.md"
cat <<EOL > crates/executor/Cargo.toml
[package]
name = "executor"
version = "0.1.0"
edition = "2021"

[dependencies]
core = { path = "../core" }
tokio = { version = "1.0", features = ["full"] }
EOL

# Orchestrator Crate Setup
create_files "crates/orchestrator" "Cargo.toml" "README.md"
cat <<EOL > crates/orchestrator/Cargo.toml
[package]
name = "orchestrator"
version = "0.1.0"
edition = "2021"

[dependencies]
core = { path = "../core" }
tokio = { version = "1.0", features = ["full"] }
EOL

# Plugins Crate Setup
create_files "crates/plugins" "Cargo.toml" "README.md"
cat <<EOL > crates/plugins/Cargo.toml
[package]
name = "plugins"
version = "0.1.0"
edition = "2021"

[dependencies]
core = { path = "../core" }
EOL

# Plugins Setup (Post-Quantum Cryptography, Differential Privacy, etc.)
create_files "plugins/pqc" "lib.rs" "pqc.rs"
create_files "plugins/differential_privacy" "lib.rs" "privacy.rs"
create_files "plugins/confidential_comp" "lib.rs" "tee_integration.rs"
create_files "plugins/antivirus_scanning" "lib.rs" "scan.rs"

# Deployments (K8s Operator and Porter Bundles)
create_files "deployments/k8s-operator" "deployment.yaml"
create_files "deployments/porter-bundles" "porter.yaml"

# Observability (Telemetry, Metrics, AI Observability)
create_files "observability/telemetry" "tracing.rs"
create_files "observability/metrics" "metrics.rs"
create_files "observability/ai_observability" "ai_metrics.rs"

# Scripts (Setup, Deployment, Testing)
create_files "scripts" "setup.sh" "run-tests.sh"
cat <<EOL > scripts/setup.sh
#!/bin/bash
# Setup script for AegisWasm ML Toolkit
set -e
cargo build --workspace
wasm-pack build wasm --target web
EOL
cat <<EOL > scripts/run-tests.sh
#!/bin/bash
# Run tests for AegisWasm ML Toolkit
set -e
cargo test --workspace --all-features
EOL

# Tests (Unit, Integration, E2E)
create_files "tests/unit" "test_main.rs"
create_files "tests/integration" "test_integration.rs"
create_files "tests/e2e" "test_e2e.rs"

# Configurations (Development, Production, Feature Flags)
create_files "configs/dev" "config.yaml"
create_files "configs/prod" "config.yaml"
create_files "configs" "feature_flags.yaml"

# Proto files for gRPC APIs
create_files "proto" "model_registry.proto"

# Tools (Buf for Proto Management, Linters)
create_files "tools/buf" "buf.yaml"
create_files "tools/linters" "clippy.toml"

# Root-Level Configuration Files
create_files "." "Cargo.toml" ".gitignore" "README.md"
cat <<EOL > Cargo.toml
[workspace]
members = [
    "src",
    "crates/core",
    "crates/executor",
    "crates/orchestrator",
    "crates/plugins",
    "plugins",
    "cmd",
    "wasm"
]

[profile.dev]
opt-level = 0

[profile.release]
opt-level = 3
EOL

cat <<EOL > .gitignore
/target
/node_modules
/pkg
*.rs.bk
Cargo.lock
EOL

# Initialize Git Repository (if not already initialized)
if [[ ! -d .git ]]; then
  git init
fi

# Add and commit changes
git add .
if git commit -m "Initial seed setup for AegisWasm ML Toolkit"; then
  git push origin main || { echo "Git push failed"; exit 1; }
else
  echo "Git commit failed"
  exit 1
fi

# End of Script
echo "AegisWasm ML Toolkit setup complete!"