{
  programs.nixvim = {
    plugins = {
      copilot-lua = {
        enable = true;
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

      copilot-chat = {
        enable = true;
        settings = {
          debug = false;
          model = "gpt-4";
          temperature = 0.1;
          context = "buffers"; # Default context: "buffers" | "buffer" | nil
        };
      };
    };

    keymaps = let
      map = mode: key: action: desc: {
        inherit mode key action;
        options.desc = desc;
      };
    in [
      (map ["n"] "<leader>cc" ":CopilotChatToggle<cr>" "Toggle Chat")
      (map ["n"] "<leader>cS" ":CopilotChatStop<cr>" "Stop Output")
      (map ["n"] "<leader>cR" ":CopilotChatReset<cr>" "Reset Chat")
      (map ["n"] "<leader>cM" ":CopilotChatModels<cr>" "Models")
      (map ["n"] "<leader>ce" ":CopilotChatExplain<cr>" "Explain")
      (map ["n"] "<leader>cr" ":CopilotChatReview<cr>" "Review")
      (map ["n"] "<leader>cf" ":CopilotChatFix<cr>" "Fix")
      (map ["n"] "<leader>co" ":CopilotChatOptimize<cr>" "Optimize")
      (map ["n"] "<leader>cd" ":CopilotChatDocs<cr>" "Docs")
      (map ["n"] "<leader>ct" ":CopilotChatTests<cr>" "Tests")
      (map ["n"] "<leader>ci" ":CopilotChatFixDiagnostic<cr>" "Fix Diagnostic")
      (map ["n"] "<leader>cm" ":CopilotChatCommit<cr>" "Commit Message")
      (map ["n"] "<leader>cs" ":CopilotChatCommitStaged<cr>" "Commit Message (Staged)")
    ];
  };
}
