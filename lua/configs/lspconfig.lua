-- load defaults i.e lua_lsp
require("nvchad.configs.lspconfig").defaults()
-- EXAMPLE
local on_attach = require("nvchad.configs.lspconfig").on_attach
local on_init = require("nvchad.configs.lspconfig").on_init
local capabilities = require("nvchad.configs.lspconfig").capabilities

local lspconfig = require "lspconfig"

-- EXAMPLE
local servers = { "html", "cssls" }
local nvlsp = require "nvchad.configs.lspconfig"

local util = require "lspconfig.util"

-- Function to read the .nvim-lsp.json file and return the disabled servers list
local function get_disabled_servers()
  local cwd = vim.fn.getcwd()

  local lsp_config_path = cwd .. "/.nvim/lsp.json"
  local disabled_servers = {}

  if vim.fn.filereadable(lsp_config_path) == 1 then
    local file = io.open(lsp_config_path, "r")
    if file then
      local content = file:read "*a"
      file:close()
      local noErr, parsed = pcall(vim.json.decode, content)
      if noErr and parsed and parsed.forceDisable then
        disabled_servers = parsed.forceDisable
      end
    end
  end
  return disabled_servers
end

-- Get the list of disabled servers
local disabled_servers = get_disabled_servers()

local function isServerDisabled(server)
  return vim.tbl_contains(disabled_servers, server)
end

require("mason-lspconfig").setup_handlers {
  function(server)
    if isServerDisabled(server) then
      return
    end
    lspconfig[server].setup {
      on_init = on_init,
      on_attach = on_attach,
      capabilities = capabilities,
    }
  end,
  ["lua_ls"] = function()
    if isServerDisabled "lua_ls" then
      return
    end
    lspconfig.lua_ls.setup {
      settings = {
        Lua = {
          hint = { enable = true },
        },
      },
    }
  end,
  ["gopls"] = function()
    if isServerDisabled "gopls" then
      return
    end
    lspconfig.gopls.setup {
      settings = {
        gopls = {
          ["ui.inlayhint.hints"] = {
            compositeLiteralFields = true,
            constantValues = true,
            parameterNames = true,
          },
        },
      },
    }
  end,
  ["tsserver"] = function()
    if isServerDisabled "tsserver" then
      return
    end
    lspconfig.tsserver.setup {
      settings = {
        typescript = {
          -- inlayHints = {
          --   includeInlayParameterNameHints = "all",
          --   includeInlayParameterNameHintsWhenArgumentMatchesName = false,
          --   includeInlayFunctionParameterTypeHints = true,
          --   includeInlayVariableTypeHints = true,
          --   includeInlayVariableTypeHintsWhenTypeMatchesName = false,
          --   includeInlayPropertyDeclarationTypeHints = true,
          --   includeInlayFunctionLikeReturnTypeHints = true,
          --   includeInlayEnumMemberValueHints = true,
          -- },
        },
        javascript = {
          -- inlayHints = {
          --   includeInlayParameterNameHints = "all",
          --   includeInlayParameterNameHintsWhenArgumentMatchesName = false,
          --   includeInlayFunctionParameterTypeHints = true,
          --   includeInlayVariableTypeHints = true,
          --   includeInlayVariableTypeHintsWhenTypeMatchesName = false,
          --   includeInlayPropertyDeclarationTypeHints = true,
          --   includeInlayFunctionLikeReturnTypeHints = true,
          --   includeInlayEnumMemberValueHints = true,
          -- },
        },
        completions = { completeFunctionCalls = true },
      },
    }
  end,
  ["pyright"] = function()
    if isServerDisabled "pyright" then
      return
    end
    lspconfig.pyright.setup {
      on_attach = on_attach,
      capabilities = capabilities,
      settings = {
        pyright = {
          autoImportCompletions = true,
        },
        python = {
          analysis = {
            -- autoSearchPaths = true,
            -- diagnosticMode = "workspace",
            useLibraryCodeForTypes = true,
          },
        },
      },
    }
  end,
}

if not isServerDisabled "sourcekit" then
  lspconfig.sourcekit.setup {
    cmd = { "sourcekit-lsp" },
    root_dir = util.root_pattern("buildServer.json", "*.xcodeproj", "*.xcworkspace", "Package.swift"),
    on_attach = on_attach,
    on_init = on_init,
    capabilities = capabilities,
  }
end
if not isServerDisabled "dartls" then
  lspconfig.dartls.setup {
    on_attach = on_attach,
    on_init = on_init,
    capabilities = capabilities,
    cmd = { "dart", "language-server", "--protocol=lsp" },
    filetypes = { "dart" },
    root_dir = util.root_pattern "pubspec.yaml",
    init_options = {
      onlyAnalyzeProjectsWithOpenFiles = true,
      suggestFromUnimportedLibraries = true,
      closingLabels = true,
      outline = true,
      flutterOutline = true,
    },
    settings = {
      dart = {
        completeFunctionCalls = true,
        showTodos = true,
      },
    },
  }
end


-- lsps with default config
-- for _, lsp in ipairs(servers) do
--   lspconfig[lsp].setup {
--     on_attach = on_attach,
--     on_init = on_init,
--     capabilities = capabilities,
--   }
-- end
--
-- -- typescript
-- lspconfig.tsserver.setup {
--   on_attach = on_attach,
--   on_init = on_init,
--   capabilities = capabilities,
-- }
