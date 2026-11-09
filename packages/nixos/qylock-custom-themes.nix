# Locally edited qylock themes (assets/qylock/<name>/).
# Each directory is installed as the SDDM theme "<name>-custom", so it
# never collides with the upstream theme of the same name.
{ stdenvNoCC }:
stdenvNoCC.mkDerivation {
  pname = "qylock-custom-themes";
  version = "local";
  src = ../../assets/qylock;
  dontBuild = true;
  installPhase = ''
    runHook preInstall
    mkdir -p $out/share/sddm/themes
    for theme in */; do
      cp -r "$theme" "$out/share/sddm/themes/''${theme%/}-custom"
    done
    runHook postInstall
  '';
}
