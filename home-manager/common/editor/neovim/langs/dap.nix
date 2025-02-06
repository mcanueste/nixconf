{...}: {
  programs.nixvim.plugins = {
    dap.enable = true;
    dap-virtual-text.enable = true;
    dap-ui.enable = true;
  };
}
