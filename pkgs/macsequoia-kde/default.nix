{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  colorVariants ? [],
}: let
  pname = "macsequoia-kde";
in
  lib.checkListOfEnum "${pname}: color variants" ["light" "dark"] colorVariants
  stdenvNoCC.mkDerivation rec {
    inherit pname;
    version = "unstable-2024-09-08";

    src = fetchFromGitHub {
      owner = "vinceliuice";
      repo = pname;
      rev = "0dc669afd476b88ddbfb686ab86fb5f911e9c145";
      hash = "sha256-BW1eUQbQRZb+FL1sckPXYQb2BK+9fM49osO+9iWRlYI=";
    };

    postPatch = ''
      patchShebangs install.sh

      substituteInPlace install.sh \
        --replace '.config' share \
        --replace '.local/' '/'
    '';

    installPhase = ''
      runHook preInstall;

      name= ./install.sh --dest $out/ \
        ${lib.optionalString (colorVariants != []) "--color " + builtins.toString colorVariants}

      runHook postInstall;
    '';
  }