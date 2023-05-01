-- Copyright (c) 2023 hogedamari
-- Released under the MIT license
-- License notice:
-- https://github.com/foo2810/quick-vim-configurator/blob/main/LICENSE


-- NVim Configurations
-- ===================

-- User Interface
require("ui")


-- For vim command completion
vim.keymap.set("c", "<UP>", "<C-P>")
vim.keymap.set("c", "<DOWN>", "<C-N>")


-- Packer
status, packer = pcall(function()
    return require("packer-if")
end)
if (not status) then
    vim.print("[Warn] wbthomason/packer.nvim not installed")
end


-- configurations of ddc and cmp tools
-- c.f. https://www.reddit.com/r/neovim/comments/p6mqij/loading_vimscript_files_from_lua/
vim.cmd("source ~/AppData/Local/nvim/ddc_config.vim")


-- lsp configurations
status, err = pcall(function()
    local nvim_lsp = require("lspconfig")
    local on_attach = function(client)
        require("completion").on_attach(client)
    end

    nvim_lsp.rust_analyzer.setup({
        on_attach=on_attach,
        settings = {
            ["rust-analyzer"] = {},
        }
    })

    vim.api.nvim_create_autocmd("LspAttach", {      -- same as autocmd of vim
        group = vim.api.nvim_create_augroup("UserLspConfig", {}),   -- same as augroup of vim
        callback = function(ev)
            local opts = {buffer = ev.buf}
            vim.keymap.set("n", "<C-K>", vim.lsp.buf.hover, opts)
            vim.keymap.set("n", "<space>f", function()
                vim.lsp.buf.format({async = true})
            end, opts)
        end
    })
end)
if (not status) then
    vim.print(string.format("[Warn] failed to config LSP, %s", err))
end

