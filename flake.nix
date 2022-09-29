{
  description = "imui Portal";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs { inherit system; };

        erlangVersion = "erlangR25";
        elixirVersion = "elixir_1_14";

        erlang = pkgs.beam.interpreters.${erlangVersion};
        elixir = pkgs.beam.packages.${erlangVersion}.${elixirVersion};
        hex = pkgs.beam.packages.${erlangVersion}.hex;
        nodejs = pkgs.nodejs-18_x;
        elixir_ls = pkgs.beam.packages.${erlangVersion}.elixir_ls;
      in {
        devShell = pkgs.mkShell {
          packages = [
            erlang
            elixir
            nodejs
            elixir_ls
            pkgs.inotify-tools
            pkgs.postgresql_14
          ];

          shellHook = ''
            # this allows mix to work on the local directory
            mkdir -p .nix-mix .nix-hex
            export MIX_HOME=$PWD/.nix-mix
            export HEX_HOME=$PWD/.nix-mix
            # make hex from Nixpkgs available
            # `mix local.hex` will install hex into MIX_HOME and should take precedence
            export MIX_PATH="${hex}/lib/erlang/lib/hex/ebin"
            export PATH=$MIX_HOME/bin:$HEX_HOME/bin:$PATH
            export LANG=C.UTF-8
            # keep your shell history in iex
            export ERL_AFLAGS="-kernel shell_history enabled"

            # phoenix related env vars
            export POOL_SIZE=15
            export DB_URL="postgresql://postgres:postgres@localhost:5432/db"
            export PORT=4000
            export MIX_ENV=dev
          '';
        };
      });
}
