{
  lib,
  emacs,
  makeDarwinBundle,
  makeDesktopItem,
  runCommand,
  writeShellScriptBin,
}: {
  profileName,
  displayName,
}: let
  scriptName = "emacs-with-profile-${profileName}";
  emacsWithProfileScript = writeShellScriptBin scriptName ''
    ${emacs}/bin/emacs --with-profile ${profileName} $*
  '';
  emacsDesktop = makeDesktopItem {
    name = "emacs-${profileName}";
    desktopName = "Emacs (${displayName})";
    genericName = "Text Editor";
    comment = "Edit text";
    mimeTypes = [
      "text/english"
      "text/plain"
      "text/x-makefile"
      "text/x-c++hdr"
      "text/x-c++src"
      "text/x-chdr"
      "text/x-csrc"
      "text/x-java"
      "text/x-moc"
      "text/x-pascal"
      "text/x-tcl"
      "text/x-tex"
      "application/x-shellscript"
      "text/x-c"
      "text/x-c++"
    ];
    exec = "${emacs}/bin/emacs --with-profile ${profileName} %F";
    icon = "emacs";
    type = "Application";
    categories = ["Development" "TextEditor"];
    startupWMClass = "Emacs";
    keywords = ["Text" "Editor"];
  };
  makeDarwinBundle' = makeDarwinBundle {
    name = "Emacs (${displayName})";
    exec = scriptName;
  };
in
  runCommand "emacs-with-profile-${profileName}" {} ''
    install -D -m 555 -t $out/bin/ ${emacsWithProfileScript}/bin/${scriptName}
    install -D -m 444 -t $out/share/applications/ ${emacsDesktop}/share/applications/emacs-${profileName}.desktop
    . ${makeDarwinBundle'}
    makeDarwinBundlePhase
  ''
