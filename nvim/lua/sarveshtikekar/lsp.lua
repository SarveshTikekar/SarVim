local M = {}

local function get_python_path()
  local buf = vim.api.nvim_get_current_buf()

  local root = vim.fs.root(buf, {
    "pyproject.toml",
    ".git",
  })

  if not root then
    return nil
  end

  local python = root .. "/.venv/bin/python"
  if vim.fn.executable(python) == 1 then
    return python
  end

  return nil
end

function M.setup()
    
    require("mason").setup({
        ui = { border = "rounded" },
    })

    require("mason-lspconfig").setup({
        ensure_installed = { "pyright" },
        automatic_installation = false,
    })

    local capabilities = require("cmp_nvim_lsp").default_capabilities()

    vim.lsp.config('pyright',{
		
		cmd = { "pyright-langserver", "--stdio" },
  filetypes = { "python" },

  root_markers = {
    ".git",
    "pyproject.toml",
  },

  root_dir = function(bufnr, on_dir)
    local root = vim.fs.root(bufnr, { ".git", "pyproject.toml" })
    on_dir(root or vim.fn.getcwd())
  end,

  before_init = function(_, config)
    local python = get_python_path()

    if python then
      config.settings = config.settings or {}
      config.settings.python = config.settings.python or {}
      config.settings.python.pythonPath = python
    end
  end,

  settings = {
    python = {
      analysis = {
        typeCheckingMode = "basic",
        autoSearchPaths = true,
        useLibraryCodeForTypes = true,
        diagnosticMode = "openFilesOnly",
      },
    },
  },
    })

    vim.lsp.config('clangd', {
        cmd = { 
            	"clangd",
        	"--query-driver=/usr/bin/g++,/usr/bin/gcc", 
        	"--background-index",
        	"--header-insertion=never",
        },
        filetypes = { "c", "cpp", "objc", "objcpp", "cuda", "proto" },
        root_markers = { 
            ".git", 
            "compile_commands.json", 
            "compile_flags.txt", 
            ".clangd", 
            "CMakeLists.txt" 
        },
        root_dir = function(bufnr, on_dir)
            local root = vim.fs.root(bufnr, { ".git", "compile_commands.json", "CMakeLists.txt" })
            on_dir(root or vim.fn.getcwd())
        end,
        capabilities = capabilities,
    })

	vim.lsp.config('vtsls', {
	
		settings = {
			javascript = {
      				updateImportsOnFileMove = { enabled = "always" },
      				suggest = { completeFunctionCalls = true },
    			},
	    	},
	})

	vim.lsp.config('lua_ls', {
    		settings = {
        	Lua = {
            		diagnostics = {
                	-- Get the language server to recognize the `vim` global
                	globals = {'vim'},
            	},
            	workspace = {
                	-- Make the server aware of Neovim runtime files
                	library = vim.api.nvim_get_runtime_file("", true),
                	checkThirdParty = false,
            	},

            	telemetry = { enabled = false },
        	},
    	},})

	vim.lsp.config('tailwindcss', {})
    	vim.lsp.config('eslint', {})
	vim.lsp.config('html-ls', {})
	vim.lsp.config('djlsp', {})
	vim.lsp.config('bashls',{})

    -- LSP enable
    vim.lsp.enable('vtsls')
    vim.lsp.enable('tailwindcss')
    vim.lsp.enable('eslint')
    vim.lsp.enable('pyright')
    vim.lsp.enable('clangd')
    vim.lsp.enable('lua_ls')
    vim.lsp.enable('html-ls')
    vim.lsp.enable('djlsp')
    vim.lsp.enable('bashls')
end

return M
