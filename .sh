#!/bin/bash 

mkdir .cargo
echo -n $'[registries]\nmy-registry = { index = "http://127.0.0.1:3333/git" }\n\n[registry]\ndefault = "my-registry"\n\n[net]\ngit-fetch-with-cli = true\n\n#' > .cargo/config

mkdir vendor
cargo install cargo-local-registry

git clone https://github.com/d-e-s-o/cargo-http-registry.git

cd cargo-http-registry

git checkout topic/symlink

cargo build --release

git config --global user.email "notused@email.com"
git config --global user.name "Ockam"

./target/release/cargo-http-registry add/vendor/full/path/here  --addr="127.0.0.1:3333" &

echo "Started http registry"
cd ../foo
# Download all dependencies to our local
cargo local-registry --sync Cargo.lock ../vendor --no-delete >> ../.cargo/config
echo "Retrieved dependencies from crates.io"

cargo publish --token null


cd ../bar
cargo local-registry --sync Cargo.lock ../vendor --no-delete
cargo publish --token null