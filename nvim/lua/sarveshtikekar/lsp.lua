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

    vim.lsp.enable('pyright')
    vim.lsp.enable('clangd')
end

return M
