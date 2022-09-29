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

          LANG = "C.UTF-8";
          # enable IEx shell history
          ERL_AFLAGS = "-kernel shell_history enabled";
        };
      });
}
