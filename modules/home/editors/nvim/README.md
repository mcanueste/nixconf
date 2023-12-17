# Important keymaps

## basics.lua
- `<C-hjkl>` -> move between windows
- `<C-arrows>` -> resize windows
- `<M-hjkl>` -> move cursor in command/insert/terminal
- `<leader>t` -> toggles
- `go` -> put empty line below (replaces default `goto` bytes)
- 'gO' -> put empty line above (replaces default 'show outline' on helm and man buffers)
- 'gV' -> visually select latest changed, put, or yanked text FIXME: doesn't work?
- 'g/' -> search inside visually selected text
- '<C-S>' -> save and go to normal mode
- '<C-Z>' -> correct latest misspelled word TODO: enable spellchecking properly
- `q` -> close some file types (see `basics.lua` for file types)

## maps.lua

- `<M-hjkl>` -> move lines
- `esc` -> disable search highlight
- `H` -> move to the beginning of line
- `L` -> move to the end of line
- `<leader>tu` -> toggle `conceallevel` (missing from `basics.lua`)
- `<leader>bb` -> switch to other buffer
- `<leader>ex` -> make current file executable
- `<leader>ed` -> delete word under cursor or selected text without saving to registers
- `<leader>ep` -> paste in place for selected text without saving to register

## tools.lua

- `gcc` -> toggle comment on current line
- `gc` -> toggle comment in normal and visual (i.e. `gcip` -> comment inner paragraph)
- `text object`: `gc` -> use comment as text object, i.e `dgc`
- `gS` -> toggle split/join
- `sa` -> add surrounding in Normal and Visual modes
- `sd` -> delete surrounding
- `sf` -> find surrounding (to the right)
- `sF` -> find surrounding (to the left)
- `sh` -> highlight surrounding
- `sr` -> replace surrounding
- `sn` -> update `n_lines`
- `l` -> suffix to search with "prev" method
- `n` -> suffix to search with "next" method
- `<leader>hh` -> harpoon mark file
- `<leader>hm` -> harpoon toggle menu
- `<leader>hn` -> harpoon next
- `<leader>hp` -> harpoon previous
- `<leader>hf` -> harpoon open `f`
- `<leader>hd` -> harpoon open `d`
- `<leader>hs` -> harpoon open `s`
- `<leader>ha` -> harpoon open `a`
- `<leader>oe` -> open file explorer
- `<leader>ol` -> open loclist
- `<leader>oq` -> open quickfix list
- `[]q` -> move to next loc/quickfix
- `<leader>f...` -> telescope find bindings
- `<leader>g...` -> telescope grep bindings
- `<leader>s...` -> telescope search bindings

## vcs.lua

- `[]h` -> move to vcs hunks
- `<leader>vb` -> gitsigns blame line
- `<leader>vB` -> gitsigns blame line toggle
- `<leader>vs` -> gitsigns stage hunk (or selected)
- `<leader>vS` -> gitsigns stage buffer
- `<leader>vu` -> gitsigns undo hunk (or selected)
- `<leader>vd` -> gitsigns diff line
- `<leader>vD` -> gitsigns diff file
- `ih` -> gitsigns text object for hunk
- `<leader>vc` -> telescope commits
- `<leader>vC` -> telescope buffer commits
- `<leader>vt` -> telescope stash
- `<leader>vb` -> telescope branches

## treesitter.lua

- bunch of text objects... see the file itself

## lsp.lua

- bunch of keymaps with lsp, trouble, telescope... see the file itself

## floats.lua

- `<leader>ot` -> open terminal
- `<leader>og` -> open lazygit
- `<leader>od` -> open lazydocker
