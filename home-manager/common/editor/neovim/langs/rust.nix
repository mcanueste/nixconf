{pkgs, ...}: {
  programs.nixvim = {
    extraPackages = [
      pkgs.cargo
      pkgs.rustc
      pkgs.rust-analyzer
      pkgs.rustfmt
      pkgs.clippy
      pkgs.cargo-nextest
    ];

    plugins = {
      rustaceanvim = {
        enable = true;
        settings = {
          server.default_settings = {
            rust-analyzer = {
              check.command = "clippy";
              inlayHints.lifetimeElisionHints.enable = "always";
            };
          };
          tools = {
            enable_clippy = true;
            enable_nextest = true;
          };
          dap.autoload_configurations = true;
        };
      };
    };
  };
}
