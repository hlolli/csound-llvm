#!/usr/bin/env bash

nix-build -E 'with import <nixpkgs> {}; callPackage ./env.nix {}' --show-trace && \
    rm -rf ./lib && mkdir lib && cp -rf result/lib/csound.bc ./lib && chmod -R +rw ./lib
