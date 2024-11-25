{
  programs.nixvim = {
    autoGroups = {
      checkTime.clear = true;
      resizeSplits.clear = true;
      lastLoc.clear = true;
      wrapSpell.clear = true;
      closeWithQ.clear = true;
      lastMod.clear = true;
      tfCommentString.clear = true;
    };

    autoCmd = [
      {
        desc = "Reload the buffer if it has changed";
        group = "checkTime";
        event = ["FocusGained" "TermClose" "TermLeave"];
        command = "checktime";
      }

      {
        desc = "Resize splits if window got resized";
        group = "resizeSplits";
        event = "VimResized";
        callback.__raw =
          # lua
          ''
            function()
              vim.cmd("tabdo wincmd =")
            end
          '';
      }

      {
        desc = "Go to last loc when opening a buffer";
        group = "lastLoc";
        event = "BufReadPost";
        callback.__raw = ''
          function()
            local mark = vim.api.nvim_buf_get_mark(0, '"')
            local lcount = vim.api.nvim_buf_line_count(0)
            if mark[1] > 0 and mark[1] <= lcount then
              pcall(vim.api.nvim_win_set_cursor, 0, mark)
            end
          end
        '';
      }

      {
        desc = "Wrap and check for spell in text file types";
        group = "wrapSpell";
        event = "FileType";
        pattern = ["gitcommit" "markdown"];
        callback.__raw = ''
          function()
            vim.opt_local.wrap = true
            vim.opt_local.spell = true
          end
        '';
      }

      {
        desc = "Close listed filetypes with `q`";
        group = "closeWithQ";
        event = "FileType";
        pattern = ["help" "man"];
        callback.__raw = ''
          function(event)
            vim.bo[event.buf].buflisted = false
            vim.keymap.set("n", "q", "<cmd>close<cr>", { buffer = event.buf, silent = true })
          end
        '';
      }

      {
        desc = "Update `lastmod` in markdown files";
        group = "lastMod";
        event = "BufWritePre";
        pattern = "*.md";
        callback.__raw = ''
          function()
            local bufnr = vim.api.nvim_get_current_buf()
            for line_num = 0, vim.api.nvim_buf_line_count(bufnr) - 1 do
              local line = vim.api.nvim_buf_get_lines(bufnr, line_num, line_num + 1, false)[1]
              if line:match 'lastmod:' then
                local new_date = os.date 'lastmod: %Y-%m-%d'
                vim.api.nvim_buf_set_lines(bufnr, line_num, line_num + 1, false, { tostring(new_date) })
                break
              end
            end
          end
        '';
      }

      {
        desc = "Fix terraform and hcl comment string";
        group = "tfCommentString";
        event = "FileType";
        pattern = ["terraform" "hcl"];
        callback.__raw = ''
          function(ev)
            vim.bo[ev.buf].commentstring = "# %s"
          end
        '';
      }
    ];
  };
}
