let
  writeIf = cond: txt:
    if cond
    then txt
    else "";

  getPackage = pkgs: pname:
    with builtins;
      if hasAttr pname pkgs
      then getAttr pname pkgs
      else getAttr pname pkgs;

  getPackageIf = cond: pkgs: pname:
    if cond
    then getPackage pkgs pname
    else null;

  filterPackages = packages: with builtins; filter (p: ! isNull p) packages;
in {
  inherit writeIf getPackage getPackageIf filterPackages;
}
