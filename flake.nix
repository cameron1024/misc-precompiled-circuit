{
  description = "Basic devshell for polybase";
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs";
    flake-utils.url = "github:numtide/flake-utils";
    rust-overlay.url = "github:oxalica/rust-overlay";
  };

  outputs = { nixpkgs, flake-utils, rust-overlay, ... }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs {
          inherit system;
          overlays = [ (import rust-overlay) ];
        };

        rustToolchain = pkgs.rust-bin.stable.latest.default.override {
          extensions = [ "rust-src" "rust-analyzer" ];
        };

      in {
        devShells.default = pkgs.mkShell {
          packages = with pkgs; [ 
            rustToolchain 

            pkg-config
            fontconfig
            openssl

            go
            nodejs

            clang # required for rocksdb

            cargo-insta
          ];

          LIBCLANG_PATH = "${pkgs.libclang.lib}/lib/";
          RUST_SRC_PATH = "${rustToolchain}/lib/rustlib/src/rust/library";
          ROLLUP_CONTRACT_ADDR="0x9fe46736679d2d9a65f0992f2272de9f3c7fa6e0";
        };
      });
}
