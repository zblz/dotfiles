-- Install packer
local ensure_packer = function()
        local fn = vim.fn
        local install_path = fn.stdpath('data') .. '/site/pack/packer/start/packer.nvim'
        if fn.empty(fn.glob(install_path)) > 0 then
                fn.system({ 'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path })
                vim.cmd [[packadd packer.nvim]]
                return true
        end
        return false
end

local packer_bootstrap = ensure_packer()

vim.cmd [[
  augroup Packer
    autocmd!
    autocmd BufWritePost init.lua PackerCompile
  augroup end
]]

local use = require('packer').use
require('packer').startup(function()
        use 'wbthomason/packer.nvim' -- Package manager

        -- git tools
        use 'tpope/vim-fugitive'
        use { 'lewis6991/gitsigns.nvim', tag = 'v0.6' }
        use { 'sindrets/diffview.nvim', requires = 'nvim-lua/plenary.nvim' }

        -- comment, linting
        use {
                'numToStr/comment.nvim',
                config = function()
                        require('Comment').setup()
                end
        }

        -- Selection UI
        use { 'nvim-telescope/telescope.nvim', branch = '0.1.x', requires = { 'nvim-lua/plenary.nvim' } }
        use { 'nvim-telescope/telescope-fzf-native.nvim', run = 'make' }
        use { 'sainnhe/gruvbox-material' }
        use {
                'nvim-lualine/lualine.nvim',
                config = function()
                        --Set statusbar
                        require('lualine').setup {
                                options = {
                                        theme = 'gruvbox-material',
                                        component_separators = { left = '', right = '' },
                                        section_separators = { left = '', right = '' },
                                }
                        }
                end
        }

        -- Treesitter
        use { 'nvim-treesitter/nvim-treesitter', run = ':TSUpdate' }
        use 'nvim-treesitter/nvim-treesitter-textobjects'
        use 'RRethy/nvim-treesitter-textsubjects'

        -- LSP, diagnostics, formatting
        use 'mason-org/mason.nvim'
        use 'mason-org/mason-lspconfig.nvim'
        use 'neovim/nvim-lspconfig' -- Collection of configurations for built-in LSP client
        use "stevearc/conform.nvim"
        use {
                'folke/trouble.nvim',
                requires = { 'nvim-tree/nvim-web-devicons' },
                config = function()
                        require('trouble').setup({})
                end
        }
        use {
                'linux-cultist/venv-selector.nvim',
                branch = 'regexp',
                requires = { 'neovim/nvim-lspconfig', 'nvim-telescope/telescope.nvim', 'mfussenegger/nvim-dap-python' },
                config = function()
                        require('venv-selector').setup {}
                end,
        }

        -- autocompletion w/ nvim-cmp
        use 'hrsh7th/nvim-cmp' -- Autocompletion plugin
        use 'hrsh7th/cmp-nvim-lsp'
        use 'hrsh7th/cmp-nvim-lsp-signature-help'
        use 'hrsh7th/cmp-buffer'
        use 'hrsh7th/cmp-path'
        use 'hrsh7th/cmp-cmdline'
        use 'ray-x/cmp-treesitter'
        use 'petertriho/cmp-git'
        use 'onsails/lspkind-nvim'

        use 'simrat39/rust-tools.nvim'

        use {
                'MeanderingProgrammer/markdown.nvim',
                as = 'render-markdown',
                after = { 'nvim-treesitter' },
                requires = { 'nvim-tree/nvim-web-devicons', opt = true },
                config = function()
                        require('render-markdown').setup({})
                end,
        }

        -- copilot
        use {
                'zbirenbaum/copilot.lua',
                cmd = 'Copilot',
                event = 'InsertEnter',
                config = function()
                        require('copilot').setup({})
                end,
        }
        use {
                'zbirenbaum/copilot-cmp',
                after = { 'copilot.lua' },
                config = function()
                        require('copilot_cmp').setup()
                end
        }

        use 'lervag/wiki.vim'
        use 'ojroques/vim-oscyank' -- yank through SSH
        use {
                'nvim-tree/nvim-tree.lua',
                requires = { 'nvim-tree/nvim-web-devicons', opt = true },
        }

        -- Automatically set up your configuration after cloning packer.nvim
        if packer_bootstrap then
                require('packer').sync()
        end
end)


vim.o.breakindent = true --Enable break indent
vim.o.colorcolumn = '80'
vim.o.expandtab = true
vim.o.tabstop = 4
vim.o.softtabstop = 4
vim.o.ignorecase = true --Case insensitive searching UNLESS /C or capital in search
vim.o.mouse = 'a'       --Enable mouse mode
vim.o.number = true     --Make line numbers default
vim.o.relativenumber = true
vim.o.smartcase = true
vim.o.spelllang = 'en_gb'
vim.o.splitright = true
vim.o.textwidth = 88
vim.o.undofile = true           --Save undo history
vim.o.clipboard = 'unnamedplus' --Copy paste between vim and everything else

vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

vim.cmd [[
        autocmd FileType gitcommit,markdown syntax enable | setlocal spell
]]

--Decrease update time
vim.o.updatetime = 250
vim.wo.signcolumn = 'yes'

--Set colorscheme
vim.o.termguicolors = true
vim.o.background = 'light'

vim.g.gruvbox_material_background = 'medium'
vim.g.gruvbox_material_palette = 'original'
vim.g.gruvbox_material_enable_bold = true
vim.g.gruvbox_material_enable_italic = true
vim.g.gruvbox_material_sign_column_background = 'none'

vim.cmd.colorscheme('gruvbox-material')

--Set leader
vim.g.mapleader = ' '
vim.g.maplocalleader = ','

--Remap for dealing with word wrap
vim.api.nvim_set_keymap('n', 'k', "v:count == 0 ? 'gk' : 'k'", { noremap = true, expr = true, silent = true })
vim.api.nvim_set_keymap('n', 'j', "v:count == 0 ? 'gj' : 'j'", { noremap = true, expr = true, silent = true })

--Some other remaps
vim.api.nvim_set_keymap('n', ';', ':', { noremap = true }) -- avoid a shift for command
vim.api.nvim_set_keymap('n', ',', ':nohlsearch<CR><C-l>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<Tab>', '%', { noremap = true, silent = true })

--toggle folds with <space>
vim.api.nvim_set_keymap('n', '<Space>', 'za', { noremap = true, silent = true })
--define folds over marked range
vim.api.nvim_set_keymap('v', '<Space>', 'zf', { noremap = true, silent = true })

--format paragraph
vim.api.nvim_set_keymap('n', '<leader>q', 'gqip', { noremap = true, silent = true })

--new tab
vim.api.nvim_set_keymap('n', '<C-t>', ':tabnew<CR>', { noremap = true, silent = true })

-- Sensible window movement
vim.api.nvim_set_keymap('n', '<c-h>', '<c-w>h', { silent = true, noremap = true })
vim.api.nvim_set_keymap('n', '<c-j>', '<c-w>j', { silent = true, noremap = true })
vim.api.nvim_set_keymap('n', '<c-k>', '<c-w>k', { silent = true, noremap = true })
vim.api.nvim_set_keymap('n', '<c-l>', '<c-w>l', { silent = true, noremap = true })

-- NvimTree
require("nvim-tree").setup()
vim.api.nvim_set_keymap("n", "<leader>nn", [[<cmd>NvimTreeToggle<CR>]], { silent = true, noremap = true })
vim.api.nvim_set_keymap("n", "<leader>nf", [[<cmd>NvimTreeFindFile<CR>]], { silent = true, noremap = true })

-- Open VenvSelector
vim.api.nvim_set_keymap("n", "<leader>v", [[<cmd>VenvSelect<cr>]], { silent = true, noremap = true })

-- Highlight on yank
vim.cmd [[
  augroup YankHighlight
    autocmd!
    autocmd TextYankPost * silent! lua vim.highlight.on_yank()
  augroup end
]]

--Map blankline
vim.g.indent_blankline_char = '┊'
vim.g.indent_blankline_filetype_exclude = { 'help', 'packer' }
vim.g.indent_blankline_buftype_exclude = { 'terminal', 'nofile' }
vim.g.indent_blankline_char_highlight = 'LineNr'
vim.g.indent_blankline_show_trailing_blankline_indent = false

-- Telescope
require('telescope').setup {
        defaults = {
                mappings = {
                        i = {
                                ['<C-u>'] = false,
                                ['<C-d>'] = false,
                        },
                },
        },
}

require('telescope').load_extension('fzf')

--Add leader shortcuts
vim.keymap.set('n', '<leader>sf', [[<cmd>lua require('telescope.builtin').find_files()<CR>]],
        { noremap = true, silent = true })
vim.keymap.set('n', '<leader>sb', [[<cmd>lua require('telescope.builtin').buffers()<CR>]],
        { noremap = true, silent = true })
vim.keymap.set('n', '<leader>ss', [[<cmd>lua require('telescope.builtin').current_buffer_fuzzy_find()<CR>]],
        { noremap = true, silent = true })
vim.keymap.set('n', '<leader>sh', [[<cmd>lua require('telescope.builtin').help_tags()<CR>]],
        { noremap = true, silent = true })
vim.keymap.set('n', '<leader>st', [[<cmd>lua require('telescope.builtin').tags()<CR>]],
        { noremap = true, silent = true })
vim.keymap.set('n', '<leader>so',
        [[<cmd>lua require('telescope.builtin').tags{ only_current_buffer = true }<CR>]],
        { noremap = true, silent = true })
vim.keymap.set('n', '<leader>sd', [[<cmd>lua require('telescope.builtin').grep_string()<CR>]],
        { noremap = true, silent = true })
vim.keymap.set('n', '<leader>sg', [[<cmd>lua require('telescope.builtin').live_grep()<CR>]],
        { noremap = true, silent = true })
vim.keymap.set('n', '\\', [[<cmd>lua require('telescope.builtin').live_grep()<CR>]],
        { noremap = true, silent = true })
vim.keymap.set('n', '<leader>?', [[<cmd>lua require('telescope.builtin').oldfiles()<CR>]],
        { noremap = true, silent = true })

-- Trouble
vim.keymap.set("n", "<leader>xx", "<cmd>Trouble diagnostics toggle<cr>",
        { silent = true, noremap = true }
)
vim.keymap.set("n", "<leader>xd", "<cmd>Trouble diagnostics toggle filter.buf=0<cr>",
        { silent = true, noremap = true }
)
vim.keymap.set("n", "<leader>xl", "<cmd>Trouble loclist toggle<cr>",
        { silent = true, noremap = true }
)
vim.keymap.set("n", "<leader>xq", "<cmd>Trouble quickfix toggle<cr>",
        { silent = true, noremap = true }
)
vim.keymap.set("n", "gr", "<cmd>Trouble lsp toggle focus=false<cr>",
        { silent = true, noremap = true }
)
vim.keymap.set("n", "gR", "<cmd>Trouble lsp toggle focus=true<cr>",
        { silent = true, noremap = true }
)

-- Treesitter configuration
---@diagnostic disable-next-line: missing-fields
require('nvim-treesitter.configs').setup {
        highlight = {
                enable = true, -- false will disable the whole extension
        },
        ensure_installed = {
                "fish",
                "bash",
                "python",
                "gitcommit",
                "json",
                "http",
        },
        auto_install = true,
        additional_vim_regex_highlighting = true,
        incremental_selection = {
                enable = true,
                keymaps = {
                        init_selection = 'gnn',
                        node_incremental = 'grn',
                        scope_incremental = 'grc',
                        node_decremental = 'grm',
                },
        },
        indent = {
                enable = true,
                disable = { "python", "yaml" }
        },
        textobjects = {
                select = {
                        enable = true,
                        lookahead = true, -- Automatically jump forward to textobj, similar to targets.vim
                        keymaps = {
                                -- You can use the capture groups defined in textobjects.scm
                                ['af'] = '@function.outer',
                                ['if'] = '@function.inner',
                                ['ac'] = '@class.outer',
                                ['ic'] = '@class.inner',
                        },
                },
                move = {
                        enable = true,
                        set_jumps = true, -- whether to set jumps in the jumplist
                        goto_next_start = {
                                [']m'] = '@function.outer',
                                [']]'] = '@class.outer',
                        },
                        goto_next_end = {
                                [']M'] = '@function.outer',
                                [']['] = '@class.outer',
                        },
                        goto_previous_start = {
                                ['[m'] = '@function.outer',
                                ['[['] = '@class.outer',
                        },
                        goto_previous_end = {
                                ['[M'] = '@function.outer',
                                ['[]'] = '@class.outer',
                        },
                },
        },
        textsubjects = {
                enable = true,
                prev_selection = ',', -- (Optional) keymap to select the previous selection
                keymaps = {
                        ['.'] = 'textsubjects-smart' }
        }
}
vim.wo.foldexpr = "nvim_treesitter#foldexpr()"

-- LSP settings
require("mason").setup()
require("mason-lspconfig").setup {
        automatic_enable = true,
        ensure_installed = { 'pyright', 'bashls', 'jsonls', 'graphql', 'taplo', 'sqlls', 'rust_analyzer',
                'ruff', 'eslint', 'ts_ls', 'lua_ls', 'yamlls' }
}
vim.lsp.enable('bacon_ls')

vim.lsp.config('lua_ls', {
        settings = {
                Lua = {
                        workspace = {
                                library = vim.api.nvim_get_runtime_file("", true),
                        },
                        diagnostics = {
                                globals = {
                                        "vim", "require"
                                }
                        },
                }
        }
})

-- advertise nvim-cmp capabilities to servers
local capabilities = require('cmp_nvim_lsp').default_capabilities()
vim.lsp.config('*', {
        capabilities = capabilities
})

vim.diagnostic.config({
        virtual_text = {
                severity = {
                        max = vim.diagnostic.severity.WARN,
                },
        },
        virtual_lines = {
                severity = {
                        min = vim.diagnostic.severity.ERROR,
                },
        },
})

vim.api.nvim_create_autocmd('LspAttach', {
        callback = function(event)
                local client = vim.lsp.get_client_by_id(event.data.client_id)
                -- if client:supports_method('textDocument/completion') then
                --         vim.lsp.completion.enable(true, client.id, event.buf, { autotrigger = true })
                -- end
                -- Inlay hints
                if client:supports_method "textDocument/inlayHints" then
                        vim.lsp.inlay_hint.enable(true, { bufnr = event.buf })
                end
                vim.api.nvim_buf_set_keymap(event.buf, 'n', '<leader>e', '<cmd>lua vim.diagnostic.open_float()<CR>',
                        { noremap = true, silent = true })
                vim.keymap.set("i", "<C-space>", vim.lsp.completion.get, { desc = "trigger autocompletion" })
        end,
})

-- Formatting

local conform = require('conform')
conform.setup({
        formatters_by_ft = {
                markdown = { "mdformat" },
                json = { "jq" },
                sql = { "sqlfmt" },
                terraform = { "terraform_fmt" },
        },
        default_format_opts = {
                lsp_format = "prefer",
        },
        -- Use the "_" filetype to run formatters on filetypes that don't
        ["_"] = { "trim_whitespace" },
})

vim.api.nvim_create_user_command("Format", function(args)
        local range = nil
        if args.count ~= -1 then
                local end_line = vim.api.nvim_buf_get_lines(0, args.line2 - 1, args.line2, true)[1]
                range = {
                        start = { args.line1, 0 },
                        ["end"] = { args.line2, end_line:len() },
                }
        end
        require("conform").format({ async = true, lsp_format = "fallback", range = range })
end, { range = true })

vim.keymap.set('n', '<leader>f', [[<cmd>Format<CR>]], { noremap = true, silent = true })
vim.o.formatexpr = "v:lua.require'conform'.formatexpr()"

-- nvim-cmp setup
vim.o.completeopt = 'menu,menuone,noselect,preview'

local has_words_before = function()
        if vim.api.nvim_buf_get_option_value(0, "buftype") == "prompt" then return false end
        local line, col = unpack(vim.api.nvim_win_get_cursor(0))
        return col ~= 0 and vim.api.nvim_buf_get_text(0, line - 1, 0, line - 1, col, {})[1]:match("^%s*$") == nil
end

local cmp = require 'cmp'
cmp.setup({
        snippet = {
                expand = function(args)
                        vim.snippet.expand(args.body)
                end,
        },
        formatting = {
                format = require('lspkind').cmp_format({
                        mode = "symbol",
                        symbol_map = { Copilot = "" },
                })
        },
        mapping = {
                ['<C-p>'] = cmp.mapping.select_prev_item(),
                ['<C-n>'] = cmp.mapping.select_next_item(),
                ['<C-d>'] = cmp.mapping.scroll_docs(-4),
                ['<C-f>'] = cmp.mapping.scroll_docs(4),
                ['<C-Space>'] = cmp.mapping.complete(),
                ['<C-e>'] = cmp.mapping.close(),
                -- ['<CR>'] = cmp.mapping.confirm { select = true },
                -- only select completion if it has been selected
                ['<CR>'] = cmp.mapping({
                        i = function(fallback)
                                if cmp.visible() and cmp.get_active_entry() then
                                        cmp.confirm({ behavior = cmp.ConfirmBehavior.Replace, select = false })
                                else
                                        fallback()
                                end
                        end,
                        s = cmp.mapping.confirm({ select = true }),
                        c = cmp.mapping.confirm({ behavior = cmp.ConfirmBehavior.Replace, select = true }),
                }),
                ['<Tab>'] = function(fallback)
                        if cmp.visible() and has_words_before() then
                                cmp.select_next_item({ behavior = cmp.SelectBehavior.Select })
                                -- elseif luasnip.expand_or_jumpable() then
                                --         luasnip.expand_or_jump()
                        else
                                fallback()
                        end
                end,
                ['<S-Tab>'] = function(fallback)
                        if cmp.visible() then
                                cmp.select_prev_item()
                                -- elseif luasnip.jumpable(-1) then
                                --         luasnip.jump(-1)
                        else
                                fallback()
                        end
                end,
        },
        sources = cmp.config.sources({
                { name = 'nvim_lsp' },
                { name = 'copilot' },
                -- { name = 'luasnip' },
                { name = 'nvim_lsp_signature_help' },
                { name = 'treesitter' },
        }, {
                { name = 'cmdline' },
                { name = 'buffer' },
                { name = 'path' },
        })
})

-- Set configuration for specific types
cmp.setup.filetype('gitcommit', {
        sources = cmp.config.sources({
                { name = 'git' },
        }, {
                { name = "conventionalcommits" }
        }, {
                { name = 'buffer' },
        })
})
-- Use cmdline & path source for ':'
cmp.setup.cmdline(':', {
        mapping = cmp.mapping.preset.cmdline(),
        completion = { autocomplete = false },
        sources = cmp.config.sources({
                { name = 'path' }
        }, {
                { name = 'cmdline' }
        })
})
-- Use buffer source for `/` and `?`
cmp.setup.cmdline({ '/', '?' }, {
        mapping = cmp.mapping.preset.cmdline(),
        completion = { autocomplete = false },
        sources = {
                { name = 'buffer' }
        }
})

-- python config
vim.cmd [[
let g:loaded_python_provider = 0
let hostname = substitute(system('hostname'), '\n', '', '')
if hostname =~# '^cube-.*'
    let g:python3_host_prog = '/opt/anaconda/envs/Python3/bin/python'
    let g:black_virtualenv = '/opt/anaconda/envs/Python3'
elseif hostname == 'vega'
    let g:python3_host_prog = expand('~/miniconda3/envs/py3/bin/python')
endif

au FileType python
    \ set tabstop=4 |
    \ set softtabstop=4 |
    \ set shiftwidth=4 |
    \ set textwidth=79 |
    \ set expandtab |
    \ set autoindent |
    \ set fileformat=unix |
    \ set formatoptions-=tc

au FileType python map <silent> <leader>b oimport pdb; pdb.set_trace()<esc>

" Display tabs and trailing space in Python mode as bad.
au FileType python match BadWhitespace /^\t\+/
au FileType python match BadWhitespace /\s\+$/

au FileType json
    \ set tabstop=2 |
    \ set softtabstop=2
]]

--YAML config
vim.cmd [[
au FileType yaml
	\ set tabstop=2 |
	\ set shiftwidth=2 |
	\ set softtabstop=2
]]

-- Wiki config
vim.g.wiki_root = '~/Dropbox/wiki'
vim.g.wiki_select_method = {
        pages = require("wiki.telescope").pages,
        tags = require("wiki.telescope").tags,
        toc = require("wiki.telescope").toc,
        links = require("wiki.telescope").links,
}
vim.g.wiki_journal = { frequency = 'weekly' }
vim.api.nvim_set_keymap('n', '<leader>wf', [[<cmd>WikiPages<CR>]], { noremap = true, silent = true })

-- git tools setup
vim.api.nvim_set_keymap('n', '<leader>dv', [[<cmd>DiffviewOpen<CR>]], { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>dc', [[<cmd>DiffviewClose<CR>]], { noremap = true, silent = true })

require('gitsigns').setup {
        on_attach = function(bufnr)
                local gs = package.loaded.gitsigns

                local function map(mode, l, r, opts)
                        opts = opts or {}
                        opts.buffer = bufnr
                        vim.keymap.set(mode, l, r, opts)
                end

                -- Navigation
                map('n', ']c', function()
                        if vim.wo.diff then return ']c' end
                        vim.schedule(function() gs.next_hunk() end)
                        return '<Ignore>'
                end, { expr = true })

                map('n', '[c', function()
                        if vim.wo.diff then return '[c' end
                        vim.schedule(function() gs.prev_hunk() end)
                        return '<Ignore>'
                end, { expr = true })

                -- Actions
                map({ 'n', 'v' }, '<leader>hs', ':Gitsigns stage_hunk<CR>')
                map({ 'n', 'v' }, '<leader>hr', ':Gitsigns reset_hunk<CR>')
                map('n', '<leader>hS', gs.stage_buffer)
                map('n', '<leader>hu', gs.undo_stage_hunk)
                map('n', '<leader>hR', gs.reset_buffer)
                map('n', '<leader>hp', gs.preview_hunk)
                map('n', '<leader>hb', function() gs.blame_line { full = true } end)
                map('n', '<leader>tb', gs.toggle_current_line_blame)
                map('n', '<leader>hd', gs.diffthis)
                map('n', '<leader>hD', function() gs.diffthis('~') end)
                map('n', '<leader>td', gs.toggle_deleted)

                -- Text object
                map({ 'o', 'x' }, 'ih', ':<C-U>Gitsigns select_hunk<CR>')
        end
}
