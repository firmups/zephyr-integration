{
  description = "FIRMUPS device-sdk environment";

  inputs.nixpkgs.url = "github:nixos/nixpkgs?ref=25.05";

  outputs = { self, nixpkgs }:
    let
      supportedSystems = [ "x86_64-linux" "aarch64-linux" "x86_64-darwin" "aarch64-darwin" ];
      forAllSystems = f: nixpkgs.lib.genAttrs supportedSystems (system:
        f system
      );
    in {
      devShells = forAllSystems (system:
        let
          pkgs = import nixpkgs { inherit system; };
        in {
          default = pkgs.mkShell {
            name = "firmups-zephyr-integration";
            buildInputs = with pkgs; [
              gcc14
              cmake
              llvmPackages_20.libcxxClang
              ninja
              glibc
              glibc.static
              gdb
              valgrind
              bashInteractive
              python313
              python313Packages.pip
            ];
            shellHook = ''
              export PS1="($name)$PS1"
              echo "Welcome to the $name devShell!"
            '';
          };
        }
      );
    };
}
