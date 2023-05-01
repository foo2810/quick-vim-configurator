-- Copyright (c) 2023 hogedamari
-- Released under the MIT license
-- License notice:
-- https://github.com/foo2810/quick-vim-configurator/blob/main/LICENSE


-- User Interface
-- --------------

local ui = {}

-- Optins of color schemes
local cs_options = {
    background = "dark",

    -- For syntax highlight in tmux, termguicolors is necessary (Why??)
    termguicolors = true,

    theme = "hybrid",
}

local options = {
    -- *** Highlight ***
    syntax = "on",
    cursorline = false,
    cursorcolumn = false,
    -- *** end ***

    -- *** Show info ***
    number = true,
    showcmd = true,
    title = true,

    -- [Status Line]
    noruler = true,    -- disable "ruler"
    laststatus = 2,
    -- To get details, type "help statusline" or see https://vim-jp.org/vimdoc-ja/options.html#'statusline'
    -- Format: <edit status> <filename> <row>:<col>
    statusline = "%m %f %l:%v",
    -- *** end ***

    -- *** Edit Options ***
    expandtab = true,
    tabstop = 4,
    shiftwidth = 4,

    smartindent = true,
    autoindent = true,

    textwidth = 0,

    hidden = true,

    -- https://vi.stackexchange.com/questions/2162/why-doesnt-the-backspace-key-work-in-insert-mode
    backspace = "indent,eol,start",

    -- [Clipboard]
    clipboard = "unnamedplus",
    -- *** end ***


    -- *** Color Schemes ***
    background = cs_options.background,

    -- For syntax highlight in tmux, termguicolors is necessary (Why??)
    termguicolors = cs_options.termguicolors,

    -- theme is set after.
    -- *** end ***


    -- *** Fonts ***
    guifont = "Hack NF:h11",
    -- guifont = "DejaVuSansMono NF:h11",
    -- *** end ***


    -- *** Misc ***
    writebackup = true,
    --noswapfile = true,
    wrapscan = true,

    -- always display sign column (for vim-lsp)
    signcolumn = "yes",
    -- *** end ***
}

local global_vars = {
     loaded_matchparen = 1,
}


-- set options
for k, v in pairs(options) do
    vim.o[k] = v
end

-- set global variables
for k, v in pairs(global_vars) do
    vim.g[k] = v
end


-- change colorscheme
status, err = pcall(vim.cmd, string.format("colorscheme %s", cs_options.theme))
if (not status) then
    vim.cmd("colorscheme default")
    vim.print(string.format("[Warn] %s not installed", cs_options.theme))
end


ui.options = options
ui.cs_options = cs_options
ui.global_vars = global_vars


return ui

