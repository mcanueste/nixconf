{
  pkgs,
  lib,
  config,
  ...
}:
with pkgs.lib.conflib; let
  cfg = config.nixhome.term;
in {
  options.nixhome.term = {
    starship = mkBoolOption {description = "Enable starship";};
  };

  config = lib.mkIf cfg.starship {
    programs.starship = {
      enable = true;
      enableBashIntegration = true;
      enableFishIntegration = cfg.fish;
      settings = {
        scan_timeout = 10;
        add_newline = true;
        azure = {disabled = true;};
        battery = {disabled = true;};
        buf = {disabled = true;};
        bun = {disabled = true;};
        cobol = {disabled = true;};
        conda = {disabled = true;};
        crystal = {disabled = true;};
        daml = {disabled = true;};
        dart = {disabled = true;};
        deno = {disabled = true;};
        dotnet = {disabled = true;};
        elixir = {disabled = true;};
        elm = {disabled = true;};
        erlang = {disabled = true;};
        fill = {disabled = true;};
        guix_shell = {disabled = true;};
        haskell = {disabled = true;};
        haxe = {disabled = true;};
        java = {disabled = true;};
        julia = {disabled = true;};
        kotlin = {disabled = true;};
        nim = {disabled = true;};
        ocaml = {disabled = true;};
        opa = {disabled = true;};
        openstack = {disabled = true;};
        perl = {disabled = true;};
        php = {disabled = true;};
        pulumi = {disabled = true;};
        purescript = {disabled = true;};
        rlang = {disabled = true;};
        raku = {disabled = true;};
        red = {disabled = true;};
        scala = {disabled = true;};
        singularity = {disabled = true;};
        spack = {disabled = true;};
        swift = {disabled = true;};
        vlang = {disabled = true;};
        vcsh = {disabled = true;};
        zig = {disabled = true;};
      };
    };
  };
}
