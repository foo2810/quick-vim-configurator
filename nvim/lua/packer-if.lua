-- Copyright (c) 2023 hogedamari
-- Released under the MIT license
-- License notice:
-- https://github.com/foo2810/quick-vim-configurator/blob/main/LICENSE


-- [Note]
-- Packages installed by "Packer" are placed in XDG_DATA_HOME. (maybe)
-- On Windows, by default, XDG_DATA_HOME =  "~/AppData/Local/nvim-data".

-- c.f. lua module
-- https://qiita.com/mod_poppo/items/ef3d8a6fe03f7f426426

-- c.f. lua functioncall, 3.4.10 - Function Calls
-- https://www.lua.org/manual/5.4/manual.html#3.3.6

return require('packer').startup(function(use)
    -- Packer can manage itself
    use("wbthomason/packer.nvim")

    -- complete parehthese
    use("rstacruz/vim-closer")

    -- (colorscheme) hybrid
    use("w0ng/vim-hybrid")

    -- nvim-lspconfig
    use("neovim/nvim-lspconfig")

    -- [ddc.vim]
    -- "ddc.vim" consists of 4 main components, 
    -- "Core", "Sources", "Filters", and "UI".
    -- - "Core" provides only pure complement features.
    -- - "Sources" collect complement candidates from around cursor, 
    --   file tree, and so on
    -- - "Filters" filter candidates based on any rules. 
    --   The rules vary depending on filter plugins.
    -- - "UI" provides interface for displaying candidates, selecting a candidate,
    --   and so on.
    -- To get details, please see https://zenn.dev/shougo/articles/ddc-vim-beta.
    --
    -- ddc depends on "deno". To use ddc, you must install "deno".
    -- See https://deno.land/manual@v1.31.3/getting_started/installation

    -- Core
    use("Shougo/ddc.vim")
    use("vim-denops/denops.vim")

    -- Sources
    use("Shougo/ddc-around")    -- collect candidate around cursor position
    use("LumaKernel/ddc-file")  -- collect candidate from file tree (for complement file path)
    use("Shougo/ddc-source-nvim-lsp")   -- Sources - LSP (Language Server Protocol)

    -- Filters
    use("Shougo/ddc-matcher_head")  -- filter candidates based on typing words
    use("Shougo/ddc-sorter_rank")   -- sort candidates
    use("Shougo/ddc-converter_remove_overlap")  -- remove duplication

    -- UI
    use("Shougo/ddc-ui-native")
    use("matsui54/denops-popup-preview.vim")
    use("matsui54/denops-signature_help")
end)

