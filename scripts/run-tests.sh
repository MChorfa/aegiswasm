#!/bin/bash
# Run tests for AegisWasm ML Toolkit
set -e
cargo test --workspace --all-features
