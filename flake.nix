{
  description = "fastapi-mvc-usecase flake";
  nixConfig.bash-prompt = ''\n\[\033[1;32m\][nix-develop:\w]\$\[\033[0m\] '';

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-22.11";
    flake-utils.url = "github:numtide/flake-utils";
    poetry2nix = {
      url = "github:nix-community/poetry2nix?ref=1.38.0";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, flake-utils, poetry2nix }:
    {
      overlays.default = nixpkgs.lib.composeManyExtensions [
        poetry2nix.overlay
        (import ./overlay.nix)
        (final: prev: {
          fastapi-mvc-usecase = prev.callPackage ./default.nix {
            python = final.python3;
            poetry2nix = final.poetry2nix;
          };
          fastapi-mvc-usecase-dev = prev.callPackage ./editable.nix {
            python = final.python3;
            poetry2nix = final.poetry2nix;
          };
        })
      ];
    } // (flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs {
          inherit system;
          overlays = [ self.overlays.default ];
        };
      in
      rec {
        packages = {
          default = pkgs.fastapi-mvc-usecase;
          fastapi-mvc-usecase-py38 = pkgs.fastapi-mvc-usecase.override { python = pkgs.python38; };
          fastapi-mvc-usecase-py39 = pkgs.fastapi-mvc-usecase.override { python = pkgs.python39; };
          fastapi-mvc-usecase-py310 = pkgs.fastapi-mvc-usecase.override { python = pkgs.python310; };
          poetryEnv = pkgs.fastapi-mvc-usecase-dev;
        } // pkgs.lib.optionalAttrs pkgs.stdenv.isLinux {
          image = pkgs.callPackage ./image.nix {
            inherit pkgs;
            app = pkgs.fastapi-mvc-usecase;
          };
        };

        apps = {
          fastapi-mvc-usecase = flake-utils.lib.mkApp { drv = pkgs.fastapi-mvc-usecase; };
          metrics = {
            type = "app";
            program = toString (pkgs.writeScript "metrics" ''
              export PATH="${pkgs.lib.makeBinPath [
                  pkgs.fastapi-mvc-usecase-dev
                  pkgs.git
              ]}"
              echo "[nix][metrics] Run fastapi-mvc-usecase PEP 8 checks."
              flake8 --select=E,W,I --max-line-length 88 --import-order-style pep8 --statistics --count fastapi_mvc_usecase
              echo "[nix][metrics] Run fastapi-mvc-usecase PEP 257 checks."
              flake8 --select=D --ignore D301 --statistics --count fastapi_mvc_usecase
              echo "[nix][metrics] Run fastapi-mvc-usecase pyflakes checks."
              flake8 --select=F --statistics --count fastapi_mvc_usecase
              echo "[nix][metrics] Run fastapi-mvc-usecase code complexity checks."
              flake8 --select=C901 --statistics --count fastapi_mvc_usecase
              echo "[nix][metrics] Run fastapi-mvc-usecase open TODO checks."
              flake8 --select=T --statistics --count fastapi_mvc_usecase tests
              echo "[nix][metrics] Run fastapi-mvc-usecase black checks."
              black -l 80 --check fastapi_mvc_usecase
            '');
          };
          docs = {
            type = "app";
            program = toString (pkgs.writeScript "docs" ''
              export PATH="${pkgs.lib.makeBinPath [
                  pkgs.fastapi-mvc-usecase-dev
                  pkgs.git
              ]}"
              echo "[nix][docs] Build fastapi-mvc-usecase documentation."
              sphinx-build docs site
            '');
          };
          unit-test = {
            type = "app";
            program = toString (pkgs.writeScript "unit-test" ''
              export PATH="${pkgs.lib.makeBinPath [
                  pkgs.fastapi-mvc-usecase-dev
                  pkgs.git
              ]}"
              echo "[nix][unit-test] Run fastapi-mvc-usecase unit tests."
              pytest tests/unit
            '');
          };
          integration-test = {
            type = "app";
            program = toString (pkgs.writeScript "integration-test" ''
              export PATH="${pkgs.lib.makeBinPath [
                  pkgs.fastapi-mvc-usecase-dev
                  pkgs.git
                  pkgs.coreutils
              ]}"
              echo "[nix][integration-test] Run fastapi-mvc-usecase unit tests."
              pytest tests/integration
            '');
          };
          coverage = {
            type = "app";
            program = toString (pkgs.writeScript "coverage" ''
              export PATH="${pkgs.lib.makeBinPath [
                  pkgs.fastapi-mvc-usecase-dev
                  pkgs.git
                  pkgs.coreutils
              ]}"
              echo "[nix][coverage] Run fastapi-mvc-usecase tests coverage."
              pytest --cov=fastapi_mvc_usecase --cov-fail-under=90 --cov-report=xml --cov-report=term-missing tests
            '');
          };
          test = {
            type = "app";
            program = toString (pkgs.writeScript "test" ''
              ${apps.unit-test.program}
              ${apps.integration-test.program}
            '');
          };
        };

        devShells = {
          default = pkgs.fastapi-mvc-usecase-dev.env.overrideAttrs (oldAttrs: {
            buildInputs = [
              pkgs.git
              pkgs.poetry
            ];
          });
          poetry = import ./shell.nix { inherit pkgs; };
        };
      }));
}
