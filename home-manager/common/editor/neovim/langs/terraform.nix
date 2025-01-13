{
  pkgs,
  lib,
  ...
}: {
  programs.nixvim.plugins = {
    lsp.servers.terraformls.enable = true;

    lint = {
      linters = {
        tflint.cmd = lib.getExe pkgs.tflint;
        tfsec.cmd = lib.getExe' pkgs.tfsec "tfsec";
      };

      lintersByFt.terraform = ["tflint" "tfsec"];
    };
  };
}
