require "nvchad.mappings"

local map = vim.keymap.set

map("n", ";", ":", { desc = "CMD enter command mode" })
map("i", "jk", "<ESC>")

-- map({ "n", "i", "v" }, "<C-s>", "<cmd> w <cr>")
--
map("n", "<leader>q", function()
  require("telescope.builtin").diagnostics { bufnr = 0 }
end, { desc = "Diagnostic setloclist" })
map("n", "<leader>fe", "<cmd> Telescope oldfiles cwd_only=v:true <CR>", { desc = "Find oldfiles in cwd" })
-- map("n", "<leader>ot", "<cmd>call jobstart('x-terminal-emulator')<CR>", { desc = "open new dedicated terminal window" })
map("n", "<leader>.", "<cmd>lua vim.lsp.buf.code_action()<CR>", { desc = "invoke lsp code action" })
map("n", "<M-.>", "<cmd>lua vim.lsp.buf.code_action()<CR>", { desc = "invoke lsp code action" })
map(
  "n",
  "gl",
  "<CMD>silent execute '!xdg-open ' .. shellescape(expand('<cfile>'), v:true)<CR>",
  { desc = "Open link in browser" }
)
map("n", "gr", function()
  require("telescope.builtin").lsp_references()
end, { desc = "Open LSP references" })
map("n", "<leader>rs", "<cmd>lua vim.lsp.buf.rename()<CR>", { desc = "rename variable (scoped, to all occurence)" })

map("i", "<M-.>", "<cmd>lua vim.lsp.buf.code_action()<CR>", { desc = "invoke lsp code action" })

map("t", "<leader><Esc>", "<C-\\><C-n>", { desc = "exit terminal mode" })
