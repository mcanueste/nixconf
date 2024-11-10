{pkgs, ...}: {
  programs.nixvim = {
    extraPlugins = [
      pkgs.gp-nvim
    ];

    extraConfigLua = ''
      local home = vim.fn.expand("$HOME")
      local gp = require("gp")

      gp.setup({
          openai_api_key = { "cat", home .. "/.ssh/openai.key" },
          image = { secret = { "cat", home .. "/.ssh/openai.key" } },

          providers = {
              openai = {
                  disable = false,
                  endpoint = "https://api.openai.com/v1/chat/completions",
              },
          },

          agents = {
              {
                  name = "ChatGPT4",
                  provider = "openai",
                  chat = true,
                  command = false,
                  model = { model = "gpt-4", temperature = 0.1, top_p = 1 },
                  system_prompt = require("gp.defaults").chat_system_prompt,
              },
              {
                  name = "CodeGPT4",
                  provider = "openai",
                  chat = false,
                  command = true,
                  model = { model = "gpt-4", temperature = 0.1, top_p = 1 },
                  system_prompt = require("gp.defaults").code_system_prompt,
              },
          },

          chat_shortcut_respond = { modes = { "n", "i", "v", "x" }, shortcut = "<C-a><C-a>" },
          chat_shortcut_delete = { modes = { "n", "i", "v", "x" }, shortcut = "<C-a>d" },
          chat_shortcut_stop = { modes = { "n", "i", "v", "x" }, shortcut = "<C-a>s" },
          chat_shortcut_new = { modes = { "n", "i", "v", "x" }, shortcut = "<C-a>c" },
      })
    '';

    keymaps = let
      map = mode: key: action: desc: {
        inherit mode key action;
        options.desc = desc;
      };
    in [
      (map ["n"] "<leader>aa" "<cmd>GpChatToggle vsplit<cr>" "Toggle Chat")
      (map ["n"] "<leader>an" "<cmd>GpChatNew vsplit<cr>" "New Chat")
      (map ["n"] "<leader>af" "<cmd>GpChatFinder<cr>" "Find Chats")
      (map ["n"] "<leader>ap" "<cmd>GpChatPaste vsplit<cr>" "Paste to Chat")
      (map ["n"] "<leader>ar" "<cmd>GpChatRespond<cr>" "Request Response")
      (map ["n"] "<leader>ad" "<cmd>GpChatDelete<cr>" "Delete Chat")
      (map ["n"] "<leader>as" "<cmd>GpStop<cr>" "Stop Chat")
      (map ["n"] "<leader>ai" "<cmd>GpImplement<cr>" "Implement Selected Comment")
      (map ["n"] "<leader>ac" "<cmd>GpContext vsplit<cr>" "Custom Context")
    ];

    plugins.which-key.settings.spec = [
      {
        __unkeyed = "<leader>a";
        group = "AI";
        icon = "󰚩";
      }
    ];
  };
}
