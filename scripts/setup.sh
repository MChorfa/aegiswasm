#!/bin/bash
# Setup script for AegisWasm ML Toolkit
set -e
cargo build --workspace
wasm-pack build wasm --target web
