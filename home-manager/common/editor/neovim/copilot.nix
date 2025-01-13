{
  programs.nixvim = {
    plugins = {
      copilot-lua = {
        enable = true;
        settings = {
          panel = {
            enabled = true;
            autoRefresh = false;
            keymap = {
              refresh = "<C-r>";
              open = "<C-CR>";
            };
          };
          suggestion = {
            enabled = true;
            autoTrigger = true;
            keymap = {
              accept = "<C-l>";
              dismiss = "<C-h>";
              next = "<C-j>";
              prev = "<C-k>";
            };
          };
        };
      };

      copilot-chat = {
        enable = true;
        settings = {
          debug = false;
          model = "claude-3.5-sonnet";
          temperature = 0.1;
          context = "buffers"; # Default context: "buffers" | "buffer" | nil
        };
      };

      which-key.settings.spec = [
        {
          __unkeyed = "<leader>c";
          group = "Copilot";
          icon = "";
        }
      ];
    };

    keymaps = let
      map = mode: key: action: desc: {
        inherit mode key action;
        options.desc = desc;
      };
    in [
      # General Copilot Chat commands
      (map ["n"] "<leader>cc" ":CopilotChatToggle<cr>" "Toggle Chat")
      (map ["n"] "<leader>cS" ":CopilotChatStop<cr>" "Stop Output")
      (map ["n"] "<leader>cM" ":CopilotChatModels<cr>" "Models")

      # Explanation and review commands
      (map ["n"] "<leader>ce" ":CopilotChatExplain<cr>" "Explain")
      (map ["n"] "<leader>cr" ":CopilotChatReview<cr>" "Review")

      # Fix and optimize commands
      (map ["n"] "<leader>cf" ":CopilotChatFix<cr>" "Fix")
      (map ["n"] "<leader>co" ":CopilotChatOptimize<cr>" "Optimize")

      # Documentation and testing commands
      (map ["n"] "<leader>cd" ":CopilotChatDocs<cr>" "Docs")
      (map ["n"] "<leader>ct" ":CopilotChatTests<cr>" "Tests")

      # Diagnostic and commit commands
      (map ["n"] "<leader>ci" ":CopilotChatFixDiagnostic<cr>" "Fix Diagnostic")
      (map ["n"] "<leader>cm" ":CopilotChatCommit<cr>" "Commit Message")
      (map ["n"] "<leader>cs" ":CopilotChatCommitStaged<cr>" "Commit Message (Staged)")
    ];
  };
}
