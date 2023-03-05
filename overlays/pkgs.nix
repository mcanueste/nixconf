packages: final: prev:
prev // builtins.mapAttrs (n: v: v.defaultPackage.${final.system}) packages
