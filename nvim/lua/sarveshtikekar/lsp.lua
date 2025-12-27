local M = {}

function M.setup()
    
    require("mason").setup({
        ui = { border = "rounded" },
    })

    require("mason-lspconfig").setup({
        ensure_installed = { "pyright" },
        automatic_installation = false,
    })

    local capabilities = require("cmp_nvim_lsp").default_capabilities()

    vim.lsp.config('pyright', {
        cmd = { "pyright-langserver", "--stdio" },
        filetypes = { "python" },
        -- Native way to define markers for upward searching
        root_markers = { ".git", "pyproject.toml", "setup.py", "requirements.txt" },
        
        -- Modern 0.11+ root_dir logic with fallback to CWD
        root_dir = function(bufnr, on_dir)
            local root = vim.fs.root(bufnr, { ".git", "pyproject.toml", "setup.py" })
            on_dir(root or vim.fn.getcwd())
        end,

        capabilities = capabilities,
        settings = {
            python = {
                analysis = {
                    typeCheckingMode = "basic",
                    autoSearchPaths = true,
                    useLibraryCodeForTypes = true,
                }
            }
        }
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
      				suggest = { 
					completeFunctionCalls = true,
					autoImports = true, 
                			includeCompletionsForModuleExports = true,
				},

				preferences = {
                			importModuleSpecifierPreference = "non-relative", 
            			}
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
    	vim.lsp.config('eslint-lsp', {})
	vim.lsp.config('html-ls', {})
	vim.lsp.config('djlsp', {})
	vim.lsp.config('bashls',{})

    -- LSP enable
    vim.lsp.enable('vtsls')
    vim.lsp.enable('tailwindcss')
    vim.lsp.enable('eslint-lsp')
    vim.lsp.enable('pyright')
    vim.lsp.enable('clangd')
    vim.lsp.enable('lua_ls')
    vim.lsp.enable('html-ls')
    vim.lsp.enable('djlsp')
    vim.lsp.enable('bashls')
end

return M
