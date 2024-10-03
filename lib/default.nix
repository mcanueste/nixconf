{lib, ...}: {
  # mkEnableOption, with default being True
  mkEnabledOption = name:
    lib.mkOption {
      default = true;
      example = false;
      description = "Whether to enable ${name}.";
      type = lib.types.bool;
    };

  # Filter out `null` from list
  filterNull = list: builtins.filter (e: e != null) list;

  # Return `null` if condition is not met, otherwise the expression given with 'yes'.
  mkIfElseNull = cond: yes:
    if cond
    then yes
    else null;
}
