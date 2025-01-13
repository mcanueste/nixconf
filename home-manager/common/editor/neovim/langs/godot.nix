{...}: {
  programs.nixvim = {
    plugins.lsp.servers = {
      gdscript = {
        enable = true;
        package = null;
      };
      gdshader_lsp = {
        enable = true;
        package = null;
      };
    };

    extraFiles."after/ftplugin/gdscript.lua".text =
      #lua
      ''
        local port = os.getenv('GDScript_Port') or '6005'
        local cmd = vim.lsp.rpc.connect('127.0.0.1', port)
        local socket = '/tmp/godot.sock'

        vim.lsp.get_clients()
        vim.lsp.start({
          name = 'Godot',
          cmd = cmd,
          root_dir = vim.fs.dirname(vim.fs.find({ 'project.godot', '.git' }, { upward = true })[1]),
          on_attach = function(client, bufnr)
            local servers = vim.fn.serverlist()
            local socket_exists = false

            for _, server in ipairs(servers) do
              if server == socket then
                socket_exists = true
                break
              end
            end

            if not socket_exists then
              vim.api.nvim_command('echo serverstart("' .. socket .. '")')
            end
          end
        })
      '';
  };
}
