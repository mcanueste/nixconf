{lib, ...}: rec {
  mkBoolOption = {
    description,
    default ? true,
  }:
    lib.mkOption {
      inherit description default;
      type = lib.types.bool;
    };

  mkEnumOption = {
    values,
    default,
    description,
  }:
    lib.mkOption {
      inherit description default;
      type = lib.types.enum values;
    };

  getPackageIf = cond: pkg:
    if cond
    then pkg
    else null;

  filterPackages = packages: with builtins; filter (p: p != null) packages;
}
