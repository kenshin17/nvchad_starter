-- EXAMPLE
local on_attach = require("nvchad.configs.lspconfig").on_attach
local on_init = require("nvchad.configs.lspconfig").on_init
local capabilities = require("nvchad.configs.lspconfig").capabilities

local lspconfig = require "lspconfig"
local servers = {
  "html",
  "cssls",
  "clangd",
  -- "tsserver",
  "unocss",
  -- "emmet_language_server",
  -- "lua_ls",
  -- "bashls",
  "lemminx",
  -- "gradle_ls",
  "marksman",
  "yamlls",
  -- "cucumber_language_server"
  -- golang
  "gopls",
  -- java
  -- "jdtls"
  "rust_analyzer",
  "cmake",
  -- make file
  "texlab",
}

-- lsps with default config
for _, lsp in ipairs(servers) do
  lspconfig[lsp].setup {
    on_attach = on_attach,
    on_init = on_init,
    capabilities = capabilities,
  }
end

-- typescript
-- lspconfig.tsserver.setup {
--   on_attach = on_attach,
--   on_init = on_init,
--   capabilities = capabilities,
-- }

lspconfig.jsonls.setup {
  on_attach = on_attach,
  capabilities = capabilities,
  on_init = on_init,
  settings = {
    json = {
      -- Schemas https://www.schemastore.org
      schemas = {
        {
          fileMatch = { "package.json" },
          url = "https://json.schemastore.org/package.json",
        },
        {
          fileMatch = { "tsconfig*.json" },
          url = "https://json.schemastore.org/tsconfig.json",
        },
        {
          fileMatch = {
            ".prettierrc",
            ".prettierrc.json",
            "prettier.config.json",
          },
          url = "https://json.schemastore.org/prettierrc.json",
        },
        {
          fileMatch = { ".eslintrc", ".eslintrc.json" },
          url = "https://json.schemastore.org/eslintrc.json",
        },
        {
          fileMatch = { ".babelrc", ".babelrc.json", "babel.config.json" },
          url = "https://json.schemastore.org/babelrc.json",
        },
        {
          fileMatch = { "lerna.json" },
          url = "https://json.schemastore.org/lerna.json",
        },
        {
          fileMatch = { "now.json", "vercel.json" },
          url = "https://json.schemastore.org/now.json",
        },
        {
          fileMatch = {
            ".stylelintrc",
            ".stylelintrc.json",
            "stylelint.config.json",
          },
          url = "http://json.schemastore.org/stylelintrc.json",
        },
      },
    },
  },
}
-- typescript
require("typescript-tools").setup {
  dependencies = { "nvim-lua/plenary.nvim", "neovim/nvim-lspconfig" },
  on_attach = on_attach,
  on_init = on_init,

  settings = {
    tsserver_path = vim.env.TSSERVER_JS,
  },
}

lspconfig.pyright.setup {
  on_attach = on_attach,
  capabilities = capabilities,
  on_init = on_init,
  settings = {
    python = {
      analysis = {
        typeCheckingMode = "off",
        useLibraryCodeForTypes = true,
      },
    },
  },
}

lspconfig.solargraph.setup {
  on_attach = on_attach,
  capabilities = capabilities,
  on_init = on_init,
  settings = {
    solargraph = {
      diagnostics = false,
    },
  },
}

-- lspconfig.bashls.setup({
-- 	on_attach = on_attach,
-- 	capabilities = capabilities,
-- 	filetypes = { "sh" },
-- })

lspconfig.cucumber_language_server.setup {
  on_attach = on_attach,
  capabilities = capabilities,
  on_init = on_init,
  filetypes = { "cucumber", "feature" },
  root_dir = lspconfig.util.find_git_ancestor,
  settings = {
    cucumber = {
      features = { "./src/**/*.feature" },
      glue = { "./src/**/*.ts", "./src/**/*.tsx", "./src/**/*.js", "./src/**/*.jsx" },
      parameterTypes = {},
      snippetTemplates = {},
    },
  },
  cmd = { "cucumber-language-server", "--stdio" },
}

local possible_lsp = {
  ["kotlin-language-server"] = function()
    lspconfig.kotlin_language_server.setup {
      on_init = on_init,
      on_attach = on_attach,
      capabilities = capabilities,
      root_dir = lspconfig.util.root_pattern("settings.gradle", "settings.gradle.kts"),
    }
  end,
  ["sourcekit-lsp"] = function()
    lspconfig.sourcekit.setup {
      on_init = on_init,
      on_attach = on_attach,
      capabilities = capabilities,
    }
  end,
  ["autotools-language-server"] = function()
    lspconfig.autotools_ls.setup {
      on_init = on_init,
      on_attach = on_attach,
      capabilities = capabilities,
    }
  end,
}

for command, lsp_setup in pairs(possible_lsp) do
  if vim.fn.executable(command) == 1 then
    lsp_setup()
  end
end
