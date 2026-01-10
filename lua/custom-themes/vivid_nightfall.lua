-- ============================================================================
-- Vivid Nightfall Theme
-- ============================================================================
-- A purple-focused theme based on the Vivid Nightfall palette
-- https://coolors.co/palette/10002b-240046-3c096c-5a189a-7b2cbf-9d4edd-c77dff-e0aaff
-- ============================================================================

local M = {}

-- Vivid Nightfall Palette
M.colors = {
    -- None
    none = "NONE",
    
    -- Base Colors (Backgrounds & UI)
    bg_darkest = "#10002b",   -- Dark Amethyst (Deepest) - Sidebars
    bg_main    = "#240046",   -- Dark Amethyst (Main BG) - Editor Background
    ui_dark    = "#3c096c",   -- Indigo Ink
    ui_medium  = "#5a189a",   -- Indigo Velvet
    
    -- Accents
    primary    = "#7b2cbf",   -- Royal Violet
    secondary  = "#9d4edd",   -- Lavender Purple
    tertiary   = "#c77dff",   -- Mauve Magic
    text_main  = "#e0aaff",   -- Mauve
    
    -- Mappings to maintain compatibility
    white = "#ffffff",
    black = "#000000",
    
    -- Grayscale Replacements (Tinted with Vivid Nightfall)
    zinc_200 = "#e0aaff",     -- Text (Mauve)
    zinc_300 = "#c77dff",     -- Dim Text (Mauve Magic)
    zinc_400 = "#9d4edd",     -- Darker Text (Lavender)
    zinc_500 = "#7b2cbf",     -- Comments (Royal Violet)
    zinc_600 = "#5a189a",     -- UI Elements (Indigo Velvet)
    zinc_700 = "#3c096c",     -- Dark UI (Indigo Ink)
    zinc_800 = "#3c096c",     -- Selection/Pmenu (Indigo Ink)
    zinc_900 = "#240046",     -- Main BG (Dark Amethyst)
    zinc_950 = "#10002b",     -- Darkest BG (Dark Amethyst)
    
    -- Theme Colors
    purple_500 = "#7b2cbf",   -- Royal Violet
    purple_200 = "#9d4edd",   -- Lavender Purple
    fuchsia_200 = "#e0aaff",  -- Mauve
    fuchsia_300 = "#c77dff",  -- Mauve Magic
    fuchsia_400 = "#c77dff",  -- Mauve Magic
    
    -- Blue Replacements (No Blue Accents!)
    blue_200 = "#c77dff",     -- Mauve Magic
    blue_400 = "#9d4edd",     -- Lavender Purple
    
    -- Functional Colors
    yellow_200 = "#fef08a",
    yellow_500 = "#eab308",
    yellow_600 = "#ca8a04",
    red_600 = "#dc2626",
    green_600 = "#16a34a",
    green_950 = "#052e16",
}

-- Helper function to set highlights
local function hl(group, opts)
    vim.api.nvim_set_hl(0, group, opts)
end

-- Apply the theme
function M.setup()
    local colors = M.colors

    -- Clear existing highlights
    vim.cmd("highlight clear")
    if vim.fn.exists("syntax_on") then
        vim.cmd("syntax reset")
    end

    vim.o.termguicolors = true
    vim.g.colors_name = "vivid_nightfall"

    -- ============================================================================
    -- Editor UI
    -- ============================================================================
    -- Changed bg from colors.none to colors.bg_main to give it the purple tint
    hl("Normal", { fg = colors.zinc_200, bg = colors.bg_main })
    hl("NormalNC", { fg = colors.zinc_300, bg = colors.bg_main })
    hl("NormalFloat", { fg = colors.zinc_200, bg = colors.bg_darkest })
    hl("FloatBorder", { fg = colors.purple_500, bg = colors.bg_darkest })

    hl("Cursor", { fg = colors.black, bg = colors.purple_500 })
    hl("CursorLine", { bg = colors.ui_dark })
    hl("CursorLineNr", { fg = colors.purple_500, bold = true })
    hl("LineNr", { fg = colors.zinc_600 })
    hl("SignColumn", { fg = colors.zinc_600, bg = colors.none })

    hl("Visual", { bg = colors.ui_medium })
    hl("VisualNOS", { bg = colors.ui_medium })
    hl("Search", { fg = colors.black, bg = colors.yellow_500 })
    hl("IncSearch", { fg = colors.black, bg = colors.purple_500 })

    hl("Pmenu", { fg = colors.zinc_200, bg = colors.bg_darkest })
    hl("PmenuSel", { fg = colors.white, bg = colors.purple_500 })
    hl("PmenuSbar", { bg = colors.zinc_800 })
    hl("PmenuThumb", { bg = colors.purple_500 })

    hl("StatusLine", { fg = colors.zinc_200, bg = colors.bg_darkest })
    hl("StatusLineNC", { fg = colors.zinc_600, bg = colors.bg_darkest })
    hl("TabLine", { fg = colors.zinc_400, bg = colors.bg_darkest })
    hl("TabLineFill", { bg = colors.bg_darkest })
    hl("TabLineSel", { fg = colors.white, bg = colors.purple_500 })

    hl("VertSplit", { fg = colors.zinc_800, bg = colors.none })
    hl("WinSeparator", { fg = colors.zinc_800, bg = colors.none })

    hl("ColorColumn", { bg = colors.bg_darkest })
    hl("Folded", { fg = colors.zinc_500, bg = colors.bg_darkest })
    hl("FoldColumn", { fg = colors.zinc_600, bg = colors.none })

    -- ============================================================================
    -- Syntax Highlighting
    -- ============================================================================
    hl("Comment", { fg = colors.zinc_500, italic = true })
    hl("Todo", { fg = colors.yellow_500, bold = true })

    hl("Constant", { fg = colors.fuchsia_300 })
    hl("String", { fg = colors.fuchsia_200 })
    hl("Character", { fg = colors.fuchsia_300 })
    hl("Number", { fg = colors.purple_200 })
    hl("Boolean", { fg = colors.purple_200, bold = true })
    hl("Float", { fg = colors.purple_200 })

    hl("Identifier", { fg = colors.zinc_200 })
    hl("Function", { fg = colors.purple_500, bold = true })

    hl("Statement", { fg = colors.fuchsia_400, bold = true })
    hl("Conditional", { fg = colors.fuchsia_400, bold = true })
    hl("Repeat", { fg = colors.fuchsia_400, bold = true })
    hl("Label", { fg = colors.fuchsia_400 })
    hl("Operator", { fg = colors.zinc_300 })
    hl("Keyword", { fg = colors.fuchsia_400, bold = true })
    hl("Exception", { fg = colors.red_600, bold = true })

    hl("PreProc", { fg = colors.purple_200 })
    hl("Include", { fg = colors.purple_200 })
    hl("Define", { fg = colors.purple_200 })
    hl("Macro", { fg = colors.purple_200 })
    hl("PreCondit", { fg = colors.purple_200 })

    hl("Type", { fg = colors.blue_400 })
    hl("StorageClass", { fg = colors.blue_400, bold = true })
    hl("Structure", { fg = colors.blue_400 })
    hl("Typedef", { fg = colors.blue_400 })

    hl("Special", { fg = colors.yellow_500 })
    hl("SpecialChar", { fg = colors.yellow_500 })
    hl("Tag", { fg = colors.purple_500 })
    hl("Delimiter", { fg = colors.zinc_400 })
    hl("SpecialComment", { fg = colors.zinc_500, italic = true })
    hl("Debug", { fg = colors.red_600 })

    -- ============================================================================
    -- Diagnostic
    -- ============================================================================
    hl("DiagnosticError", { fg = colors.red_600 })
    hl("DiagnosticWarn", { fg = colors.yellow_600 })
    hl("DiagnosticInfo", { fg = colors.blue_400 })
    hl("DiagnosticHint", { fg = colors.purple_200 })

    hl("DiagnosticUnderlineError", { undercurl = true, sp = colors.red_600 })
    hl("DiagnosticUnderlineWarn", { undercurl = true, sp = colors.yellow_600 })
    hl("DiagnosticUnderlineInfo", { undercurl = true, sp = colors.blue_400 })
    hl("DiagnosticUnderlineHint", { undercurl = true, sp = colors.purple_200 })

    -- ============================================================================
    -- LSP
    -- ============================================================================
    hl("LspReferenceText", { bg = colors.zinc_800 })
    hl("LspReferenceRead", { bg = colors.zinc_800 })
    hl("LspReferenceWrite", { bg = colors.zinc_800 })

    -- ============================================================================
    -- Git Signs
    -- ============================================================================
    hl("GitSignsAdd", { fg = colors.green_600 })
    hl("GitSignsChange", { fg = colors.yellow_500 })
    hl("GitSignsDelete", { fg = colors.red_600 })

    hl("DiffAdd", { bg = colors.green_950 })
    hl("DiffChange", { bg = colors.zinc_800 })
    hl("DiffDelete", { fg = colors.red_600, bg = colors.zinc_950 })
    hl("DiffText", { bg = colors.zinc_700 })

    -- ============================================================================
    -- Treesitter
    -- ============================================================================
    hl("@variable", { fg = colors.zinc_200 })
    hl("@variable.builtin", { fg = colors.purple_200 })
    hl("@variable.parameter", { fg = colors.zinc_300 })
    hl("@variable.member", { fg = colors.zinc_200 })

    hl("@constant", { fg = colors.fuchsia_300 })
    hl("@constant.builtin", { fg = colors.purple_200 })
    hl("@module", { fg = colors.blue_400 })

    hl("@string", { fg = colors.fuchsia_200 })
    hl("@string.escape", { fg = colors.yellow_500 })
    hl("@string.regexp", { fg = colors.yellow_500 })

    hl("@character", { fg = colors.fuchsia_300 })
    hl("@number", { fg = colors.purple_200 })
    hl("@boolean", { fg = colors.purple_200, bold = true })
    hl("@float", { fg = colors.purple_200 })

    hl("@function", { fg = colors.purple_500, bold = true })
    hl("@function.builtin", { fg = colors.purple_500 })
    hl("@function.call", { fg = colors.purple_500 })
    hl("@function.macro", { fg = colors.purple_200 })
    hl("@function.method", { fg = colors.purple_500 })

    hl("@keyword", { fg = colors.fuchsia_400, bold = true })
    hl("@keyword.function", { fg = colors.fuchsia_400, bold = true })
    hl("@keyword.operator", { fg = colors.fuchsia_400 })
    hl("@keyword.return", { fg = colors.fuchsia_400, bold = true })

    hl("@conditional", { fg = colors.fuchsia_400, bold = true })
    hl("@repeat", { fg = colors.fuchsia_400, bold = true })
    hl("@label", { fg = colors.fuchsia_400 })

    hl("@operator", { fg = colors.zinc_300 })
    hl("@exception", { fg = colors.red_600, bold = true })

    hl("@type", { fg = colors.blue_400 })
    hl("@type.builtin", { fg = colors.blue_400 })
    hl("@type.definition", { fg = colors.blue_400 })

    hl("@property", { fg = colors.zinc_200 })
    hl("@attribute", { fg = colors.purple_200 })

    hl("@constructor", { fg = colors.blue_400 })
    hl("@namespace", { fg = colors.blue_400 })

    hl("@comment", { fg = colors.zinc_500, italic = true })
    hl("@comment.todo", { fg = colors.yellow_500, bold = true })

    hl("@tag", { fg = colors.purple_500 })
    hl("@tag.attribute", { fg = colors.purple_200 })
    hl("@tag.delimiter", { fg = colors.zinc_400 })

    -- ============================================================================
    -- Telescope
    -- ============================================================================
    hl("TelescopeNormal", { fg = colors.zinc_200, bg = colors.bg_darkest })
    hl("TelescopeBorder", { fg = colors.purple_500, bg = colors.bg_darkest })
    hl("TelescopePromptNormal", { fg = colors.zinc_200, bg = colors.bg_darkest })
    hl("TelescopePromptBorder", { fg = colors.purple_500, bg = colors.bg_darkest })
    hl("TelescopePromptTitle", { fg = colors.white, bg = colors.purple_500, bold = true })
    hl("TelescopePreviewTitle", { fg = colors.white, bg = colors.purple_500, bold = true })
    hl("TelescopeResultsTitle", { fg = colors.white, bg = colors.purple_500, bold = true })
    hl("TelescopeSelection", { fg = colors.white, bg = colors.purple_500 })
    hl("TelescopeSelectionCaret", { fg = colors.purple_500 })
    hl("TelescopeMatching", { fg = colors.yellow_500, bold = true })

    -- ============================================================================
    -- nvim-cmp
    -- ============================================================================
    hl("CmpItemAbbrMatch", { fg = colors.purple_500, bold = true })
    hl("CmpItemAbbrMatchFuzzy", { fg = colors.purple_200 })
    hl("CmpItemKind", { fg = colors.fuchsia_400 })
    hl("CmpItemMenu", { fg = colors.zinc_500 })

    -- ============================================================================
    -- nvim-tree
    -- ============================================================================
    hl("NvimTreeNormal", { fg = colors.zinc_200, bg = colors.bg_main })
    hl("NvimTreeFolderName", { fg = colors.purple_500 })
    hl("NvimTreeFolderIcon", { fg = colors.purple_500 })
    hl("NvimTreeOpenedFolderName", { fg = colors.purple_200, bold = true })
    hl("NvimTreeEmptyFolderName", { fg = colors.zinc_600 })
    hl("NvimTreeRootFolder", { fg = colors.fuchsia_400, bold = true })
    hl("NvimTreeSpecialFile", { fg = colors.yellow_500 })
    hl("NvimTreeExecFile", { fg = colors.green_600, bold = true })
    hl("NvimTreeGitDirty", { fg = colors.yellow_500 })
    hl("NvimTreeGitNew", { fg = colors.green_600 })
    hl("NvimTreeGitDeleted", { fg = colors.red_600 })

    -- ============================================================================
    -- Indent Blankline
    -- ============================================================================
    hl("IblIndent", { fg = colors.zinc_800 })
    hl("IblScope", { fg = colors.purple_500 })

    -- ============================================================================
    -- WhichKey
    -- ============================================================================
    hl("WhichKey", { fg = colors.purple_500, bold = true })
    hl("WhichKeyGroup", { fg = colors.fuchsia_400 })
    hl("WhichKeyDesc", { fg = colors.zinc_200 })
    hl("WhichKeySeparator", { fg = colors.zinc_600 })
    hl("WhichKeyFloat", { bg = colors.bg_darkest })

    -- ============================================================================
    -- Noice
    -- ============================================================================
    hl("NoiceCmdlinePopup", { fg = colors.zinc_200, bg = colors.bg_darkest })
    hl("NoiceCmdlinePopupBorder", { fg = colors.purple_500, bg = colors.bg_darkest })
    hl("NoiceCmdlineIcon", { fg = colors.purple_500 })

    -- ============================================================================
    -- Bufferline
    -- ============================================================================
    hl("BufferLineIndicatorSelected", { fg = colors.purple_500 })
    hl("BufferLineFill", { bg = colors.bg_darkest })
    hl("BufferLineBufferSelected", { fg = colors.white, bg = colors.bg_main, bold = true })
    hl("BufferLineBufferVisible", { fg = colors.zinc_400, bg = colors.bg_darkest })

    -- ============================================================================
    -- Lualine (will be picked up automatically)
    -- ============================================================================
    vim.g.lualine_theme = {
        normal = {
            a = { fg = colors.white, bg = colors.purple_500, gui = "bold" },
            b = { fg = colors.zinc_200, bg = colors.zinc_800 },
            c = { fg = colors.zinc_400, bg = colors.bg_darkest },
        },
        insert = {
            a = { fg = colors.white, bg = colors.green_600, gui = "bold" },
        },
        visual = {
            a = { fg = colors.white, bg = colors.fuchsia_400, gui = "bold" },
        },
        replace = {
            a = { fg = colors.white, bg = colors.red_600, gui = "bold" },
        },
        command = {
            a = { fg = colors.white, bg = colors.yellow_600, gui = "bold" },
        },
        inactive = {
            a = { fg = colors.zinc_600, bg = colors.bg_darkest },
            b = { fg = colors.zinc_600, bg = colors.bg_darkest },
            c = { fg = colors.zinc_600, bg = colors.bg_darkest },
        },
    }

    -- ============================================================================
    -- Terminal Colors
    -- ============================================================================
    vim.g.terminal_color_0 = colors.zinc_950
    vim.g.terminal_color_1 = colors.red_600
    vim.g.terminal_color_2 = colors.green_600
    vim.g.terminal_color_3 = colors.yellow_500
    vim.g.terminal_color_4 = colors.blue_400
    vim.g.terminal_color_5 = colors.fuchsia_400
    vim.g.terminal_color_6 = colors.purple_200
    vim.g.terminal_color_7 = colors.zinc_200
    vim.g.terminal_color_8 = colors.zinc_700
    vim.g.terminal_color_9 = colors.red_600
    vim.g.terminal_color_10 = colors.green_600
    vim.g.terminal_color_11 = colors.yellow_500
    vim.g.terminal_color_12 = colors.blue_400
    vim.g.terminal_color_13 = colors.fuchsia_400
    vim.g.terminal_color_14 = colors.purple_200
    vim.g.terminal_color_15 = colors.white
end

return M
