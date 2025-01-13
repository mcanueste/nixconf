{...}: {
  programs.nixvim.plugins.dap = {
    enable = true;
    extensions = {
      dap-virtual-text = {
        enable = true;
      };
      dap-ui = {
        enable = true;
      };
    };
  };
}
