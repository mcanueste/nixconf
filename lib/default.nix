{lib, ...}: rec {
  mkBoolOption = {
    description,
    default ? true,
  }:
    lib.mkOption {
      inherit description default;
      type = lib.types.bool;
    };

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
}
