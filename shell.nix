{ pkgs ? import <nixpkgs> {} }:

pkgs.mkShell {
  buildInputs = with pkgs.haskellPackages; [
    ghc
    cabal-install
    haskell-language-server
    scotty
    blaze-html
  ];

  shellHook = ''
    echo "🚀 Entered WeatherForecastMarathon dev shell!"
  '';
}
