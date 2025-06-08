# AttrsOf PackageDef available as args. (i.e. `pkgs` attrset is the argument to ths function)
{ stdenv }:
stdenv.mkDerivation {
  name = "pkg1";
  src = ./.;
  installPhase = "make DESTDIR=$out install";
}
