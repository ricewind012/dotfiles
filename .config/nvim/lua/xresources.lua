function string.split(self, s)
    local t = {}
    for piece in self:gmatch("([^"..(s or " ").."]+)") do
        table.insert(t, piece)
    end
        
    return #t > 0 and t or {self}
end

local colors = {}
local output = io.popen('xrdb -query'):read('*a')
--output.close()

for line in string.gmatch(output, '[^\r\n]*') do
    if line:match('#%x%x%x%x%x%x') then
        local split = line:split(':')
        local k = split[1]:match('%w+')
        local v = split[2]:match('#%x%x%x%x%x%x')

        colors[k] = v
    end
end

-- ======================================
-- funtion to get lighter color
-- ======================================
local function get_lighter_color(c, hex)
    local before_color = colors[c]
    local s = string.sub(before_color, 2, 7)
    local after_color = tonumber('0x' .. s) + hex

    return '#' .. string.format('%x', after_color)
end

-- ======================================
-- funtion to get darker color
-- ======================================
local function get_darker_color(c, hex)
    local before_color = colors[c]
    local s = string.sub(before_color, 2, 7)
    local after_color = tonumber('0x' .. s) - hex

    return '#' .. string.format('%x', after_color)
end

-- =================
-- Color properties
-- =================
local xresources = {
    fg = colors['foreground'];
		fg2 = colors['fg2'];
    bg = colors['background'];
		bg2 = colors['bg2'];
    black = colors['color0'];
    red = colors['color1'];
    green = colors['color2'];
    yellow = colors['color3'];
    blue = colors['color4'];
    purple = colors['color5'],
    cyan = colors['color6'];
    white = colors['color7'];
    light_black = colors['color8'];
    light_red = colors['color9'];
    light_green = colors['color10'];
    light_yellow = colors['color11'];
    light_blue = colors['color12'];
    light_purple = colors['color13'];
    light_cyan = colors['color14'];
    light_white = colors['color15'];

		hl = colors['hl'];
		hf = colors['hf'];

    none = 'NONE';
}

-- ======================
-- Terminal colors
-- ======================
function xresources.terminal_color()
    vim.g.terminal_color_0 = xresources.bg
    vim.g.terminal_color_1 = xresources.red
    vim.g.terminal_color_2 = xresources.green
    vim.g.terminal_color_3 = xresources.yellow
    vim.g.terminal_color_4 = xresources.blue
    vim.g.terminal_color_5 = xresources.purple
    vim.g.terminal_color_6 = xresources.cyan
    vim.g.terminal_color_7 = xresources.fg
    vim.g.terminal_color_8 = xresources.bg
    vim.g.terminal_color_9 = xresources.red
    vim.g.terminal_color_10 = xresources.green
    vim.g.terminal_color_11 = xresources.yellow
    vim.g.terminal_color_12 = xresources.blue
    vim.g.terminal_color_13 = xresources.purple
    vim.g.terminal_color_14 = xresources.cyan
    vim.g.terminal_color_15 = xresources.fg
end

-- ====================
-- Highlight function
-- ====================
function xresources.highlight(group, color)
    local style = color.style and 'gui=' .. color.style or 'gui=NONE'
    local fg = color.fg and 'guifg=' .. color.fg or 'guifg=NONE'
    local bg = color.bg and 'guibg=' .. color.bg or 'guibg=NONE'
    local sp = color.sp and 'guisp=' .. color.sp or ''
    vim.api.nvim_command('highlight ' .. group .. ' ' .. style .. ' ' .. fg ..
        ' ' .. bg..' '..sp)
end

function xresources.load_syntax()
    local syntax = {
        -- ==================
        -- Syntax group
        -- ===================
        Boolean = {fg=xresources.purple};
        Comment = {fg=xresources.fg2};
        Constant = {fg=xresources.cyan};
        Character = {fg=xresources.green};
        Conditional = {fg=xresources.red};
        Debug = {fg=xresources.yellow};
        Define = {fg=xresources.purple};
        Delimiter = {fg=xresources.fg};
        Error = {fg=xresources.red};
        Exception = {fg=xresources.red};
        Float = {fg=xresources.purple};
        Function = {fg=xresources.green};
        Identifier = {fg=xresources.blue};
        Ignore = {fg=xresources.fg2};
        Include = {fg=xresources.purple};
        Keyword = {fg=xresources.red};
        Label = {fg=xresources.light_red};
        Macro = {fg=xresources.cyan};
        Number = {fg=xresources.purple};
        Operator = {fg=xresources.light_red};
        PreProc = {fg=xresources.purple};
        PreCondit = {fg=xresources.purple};
        Repeat = {fg=xresources.red};
        Statement = {fg=xresources.red};
        StorageClass = {fg=xresources.light_red};
        Special = {fg=xresources.yellow};
        SpecialChar = {fg=xresources.yellow};
        Structure = {fg=xresources.light_red};
        String = {fg=xresources.green};
        SpecialComment = {fg=xresources.fg2};
        Typedef = {fg=xresources.red};
        Tag = {fg=xresources.light_red};
        Type = {fg=xresources.yellow};
        Todo = {fg=xresources.hf,bg=xresources.hl};
        Underlined = {fg=xresources.none,style='underline'};

        -- =============
        -- Treesitter
        -- ==============
        TSError = { fg = xresources.red };
        TSPunctDelimitter = { fg = xresources.cyan };
        TSPunctBracket = {};
        TSPunctSpecial = { fg = xresources.cyan };
        TSConstant = { fg = xresources.yellow };
        TSConstBuiltin = { fg = xresources.blue };
        TSContMacro = { fg = xresources.purple };
        TSString = { fg = xresources.green };
        TSStringRegex = { fg = xresources.red };
        TSCharacter = { fg = xresources.green };
        TSNumber = { fg = xresources.yellow };
        TSBoolean = { fg = xresources.yellow };
        TSFloat = { fg = xresources.yellow };
        TSAnnotation = { fg = xresources.blue };
        TSAttribute = { fg = xresources.yellow };
        TSNamespace = { fg = xresources.blue };
        TSFunctionBuiltin = { fg = xresources.blue };
        TSFunction = { fg = xresources.blue };
        TSFuncMacro = { fg = xresources.blue };
        TSParameter = { fg = xresources.red };
        TSParameterReference = { fg = xresources.red };
        TSMethod = { fg = xresources.blue };
        TSField = { fg = xresources.yellow };
        TSProperty = { fg = xresources.red };
        TSConstructor = { fg = xresources.blue };
        TSConditional= { fg = xresources.purple };
        TSRepeat= { fg = xresources.purple };
        TSLabel= { fg = xresources.purple };
        TSKeyword= { fg = xresources.purple };
        TSKeywordFunction= { fg = xresources.purple };
        TSKeywordOperator= { fg = xresources.cyan };
        TSOperator= { fg = xresources.cyan };
        TSExeption= { fg = xresources.red };
        TSType= { fg = xresources.blue };
        TSTypeBuiltin= { fg = xresources.red };
        TSStructure= { fg = xresources.yellow };
        TSInclude= { fg = xresources.red };
        TSVariable= {fg= xresources.yellow};
        TSVariableBuiltin= { fg = xresources.blue };
        TSText= {};
        TSStrong= { fg = xresources.purple };
        TSEmphasis= { fg = xresources.cyan };
        TSUnderline= { fg = xresources.yellow };
        TSTitle= { fg = xresources.yellow };
        TSLiteral= { fg = xresources.green };
        TSUri= { fg = xresources.green };
        TSTag= {};
        TSTagDelimitter= {};

        -- ===================
        -- Highlight Group
        -- ===================
        BufferInactive= { fg=xresources.fg };
        BufferInactiveTarge = { fg=xresources.fg };
        BufferInactiveSign = { fg=xresources.blue };
        BufferCurrent = { fg=xresources.yellow, bg=xresources.bg, style ='bold'};
        BufferCurrentSign = { fg=xresources.blue, bg=xresources.bg };
        BufferTabPageFill = { fg=xresources.blue, bg=xresources.bg };
        BufferCurrentMod = { fg=xresources.blue, bg=xresources.bg };
        BufferInactiveMod = { fg=xresources.blue };
        ColorColumn = {bg=xresources.bg2};
        Conceal = {fg=xresources.fg2,bg=xresources.none};
        CursorLineNr = {bg=xresources.bg2,fg=xresources.fg};
        CursorIM = {fg=xresources.none,bg=xresources.none,style='reverse'};
        CursorColumn = {fg=xresources.none};
        CursorLine = {fg=xresources.none,bg=xresources.bg2};
        Cursor = {fg=xresources.none,bg=xresources.none,style='reverse'};
        DiffAdd = {fg=xresources.bg,bg=xresources.green};
        DiffChange = {fg=xresources.bg,bg=xresources.yellow};
        DiffDelete = {fg=xresources.bg,bg=xresources.red};
        DiffText = {fg=xresources.bg,bg=xresources.fg};
        Directory = {fg=xresources.fg2,bg=xresources.none};
        debugBreakpoint = {fg=xresources.bg,bg=xresources.red};
        EndOfBuffer = {fg=xresources.bg,bg=xresources.none};
        ErrorMsg = {fg=xresources.red,bg=xresources.none,style='bold'};
        FoldColumn = {fg=xresources.fg,bg=xresources.bg};
        Folded = {fg=xresources.fg2};
        iCursor = {fg=xresources.none,bg=xresources.none,style='reverse'};
        IncSearch = {fg=xresources.fg2,bg=xresources.yellow,style=xresources.none};
        lCursor = {fg=xresources.none,bg=xresources.none,style='reverse'};
        LineNr = {fg=xresources.fg2};
        ModeMsg = {fg=xresources.fg,bg=xresources.none,style='bold'};
        MatchParen = {fg=xresources.hf,bg=xresources.hl};
        Normal = {fg = xresources.fg,bg=xresources.bg};
        NormalFloat = {fg=xresources.fg};
        NonText = {fg=xresources.fg2};
        Pmenu = {fg=xresources.fg};
        PmenuSel = {fg=xresources.fg2,bg=xresources.blue};
        PmenuSelBold = {fg=xresources.fg2,g=xresources.blue};
        PmenuSbar = {fg=xresources.none};
        PmenuThumb = {fg=xresources.purple,bg=xresources.green};
        Question = {fg=xresources.yellow};
        QuickFixLine = {fg=xresources.purple,style='bold'};
        StatusLine = {fg=xresources.fg,bg=xresources.bg,style='reverse'};
        StatusLineNC = {fg=xresources.fg2,style=xresources.none};
        SpellBad = {fg=xresources.red,bg=xresources.none,style='undercurl'};
        SpellCap = {fg=xresources.blue,bg=xresources.none,style='undercurl'};
        SpellLocal = {fg=xresources.cyan,bg=xresources.none,style='undercurl'};
        SpellRare = {fg=xresources.purple,bg=xresources.none,style = 'undercurl'};
        SignColumn = {fg=xresources.fg,bg=xresources.bg};
        Search = {fg=xresources.bg,bg=xresources.yellow};
        SpecialKey = {fg=xresources.fg2};
        TabLineSel = {bg=xresources.bg};
        Title = {fg=xresources.green,style='bold'};
        Terminal = {fg = xresources.fg,bg=xresources.bg};
        TabLineFill = {style=xresources.none};
        VertSplit = {fg=xresources.fg2,bg=xresources.fg2};
        vCursor = {fg=xresources.none,bg=xresources.none,style='reverse'};
        WarningMsg = {fg=xresources.yellow,bg=xresources.none,style='bold'};
        Whitespace = {fg=xresources.fg2};
        WildMenu = {fg=xresources.fg,bg=xresources.green};
        Visual = {fg=xresources.hf,bg=xresources.hl};
        VisualNOS = {fg=xresources.bg,bg=xresources.fg};
    }
    return syntax
end

-- ================================
-- Language specific highlighting
-- ================================
function xresources.load_plugin_syntax()
    local plugin_syntax = {
        -- ================
        -- CSS
        -- ================
        cssAttrComma= {fg=xresources.purple};
        cssAttributeSelector= {fg=xresources.green};
        cssBraces= {fg=xresources.fg};
        cssClassName= {fg=xresources.yellow};
        cssClassNameDot= {fg=xresources.yellow};
        cssDefinition= {fg=xresources.purple};
        cssFontAttr= {fg=xresources.yellow};
        cssFontDescriptor= {fg=xresources.purple};
        cssFunctionName= {fg=xresources.blue};
        cssIdentifier= {fg=xresources.blue};
        cssImportant= {fg=xresources.purple};
        cssInclude= {fg=xresources.fg};
        cssIncludeKeyword= {fg=xresources.purple};
        cssMediaType= {fg=xresources.yellow};
        cssProp= {fg=xresources.fg};
        cssPseudoClassId= {fg=xresources.yellow};
        cssSelectorOp= {fg=xresources.purple};
        cssSelectorOp2= {fg=xresources.purple};
        cssTagName= {fg=xresources.red};
        -- ================
        -- GO
        -- =================
        goDeclaration= {fg=xresources.purple};
        goBuiltins= {fg=xresources.cyan};
        goFunctionCall= {fg=xresources.blue};
        goVarDefs= {fg=xresources.red};
        goVarAssign= {fg=xresources.red};
        goVar= {fg=xresources.purple};
        goConst= {fg=xresources.purple};
        goType= {fg=xresources.yellow};
        goTypeName= {fg=xresources.yellow};
        goDeclType= {fg=xresources.cyan};
        goTypeDecl= {fg=xresources.purple};
        -- ==============
        -- JavaScript
        -- ==============
        javaScriptBraces={fg = xresources.yellow };
        javaScriptFunction ={ fg =xresources.purple };
        javaScriptIdentifier = { fg = xresources.purple };
        javaScriptNull = { fg = xresources.yellow };
        javaScriptNumber ={ fg = xresources.yellow };
        javaScriptRequire ={ fg =xresources.cyan };
        javaScriptReserved = { fg = xresources.purple };
        -- ==============================================
        -- vim-javascript
        -- ==============================================
        jsArrowFunction = { fg = xresources.purple };
        jsClassKeyword ={ fg = xresources.purple };
        jsClassMethodType = { fg = xresources.purple };
        jsDocParam = { fg = xresources.blue };
        jsDocTags ={ fg = xresources.purple };
        jsExport ={ fg = xresources.purple };
        jsExportDefault ={ fg = xresources.purple };
        jsExtendsKeyword = { fg = xresources.purple };
        jsFrom = { fg = xresources.purple };
        jsFuncCall = { fg = xresources.blue };
        jsFunction ={ fg = xresources.purple };
        jsGenerator = { ffg = xresources.yellow };
        jsGlobalObjects = { fg = xresources.yellow };
        jsImport ={ fg = xresources.purple };
        jsModuleAs = { fg = xresources.purple };
        jsModuleWords = { fg = xresources.purple };
        jsModules ={ fg = xresources.purple };
        jsNull ={ fg = xresources.yellow };
        jsOperator = { fg = xresources.purple };
        jsStorageClass = { fg = xresources.purple };
        jsSuper = { fg = xresources.red };
        jsTemplateBraces = { fg = xresources.red };
        jsTemplateVar ={ fg = xresources.green };
        jsThis = { fg = xresources.red };
        jsUndefined = { fg = xresources.yellow };
        -- =====================================
        --  yajs.vim
        -- =====================================
        javascriptArrowFunc ={ fg = xresources.purple };
        javascriptClassExtends = { fg = xresources.purple };
        javascriptClassKeyword ={ fg = xresources.purple };
        javascriptDocNotation ={ fg = xresources.purple };
        javascriptDocParamName = { fg = xresources.blue };
        javascriptDocTags ={ fg = xresources.purple };
        javascriptEndColons = { fg = xresources.fg};
        javascriptExport ={ fg = xresources.purple };
        javascriptFuncArg ={ fg = xresources.fg };
        javascriptFuncKeyword ={ fg = xresources.purple };
        javascriptIdentifier ={ fg = xresources.red };
        javascriptImport ={ fg = xresources.purple };
        javascriptMethodName ={ fg =xresources.fg };
        javascriptObjectLabel = { fg =xresources.fg };
        javascriptOpSymbol= { fg =xresources.cyan};
        javascriptOpSymbols ={ fg = xresources.cyan };
        javascriptPropertyName = { fg = xresources.green };
        javascriptTemplateSB = { fg = xresources.red };
        javascriptVariable ={ fg = xresources.purple };
        -- ============
        -- Vim
        -- ============
        vimCommentTitle = {fg=xresources.fg2};
        vimLet = {fg=xresources.yellow};
        vimVar = {fg=xresources.cyan};
        vimFunction = {fg=xresources.purple};
        vimIsCommand = {fg=xresources.fg};
        vimCommand = {fg=xresources.blue};
        vimNotFunc = {fg=xresources.purple};
        vimUserFunc = {fg=xresources.yellow};
        vimFuncName= {fg=xresources.yellow};
        -- =================
        -- Git stuff
        -- ===================
        -- Vim GitGutter
        -- ==================
        GitGutterAdd = {fg=xresources.green};
        GitGutterChange = {fg=xresources.blue};
        GitGutterDelete = {fg=xresources.red};
        GitGutterChangeDelete = {fg=xresources.purple};
        -- =======
        -- Diff
        -- ========
        diffAdded = {fg = xresources.green};
        diffRemoved = {fg =xresources.red};
        diffChanged = {fg = xresources.blue};
        diffOldFile = {fg = xresources.yellow};
        diffNewFile = {fg = xresources.yellow};
        diffFile     = {fg = xresources.cyan};
        diffLine     = {fg = xresources.fg2};
        diffIndexLine = {fg = xresources.purple};
        -- ========
        -- Commit
        -- ========
        gitcommitSummary = {fg = xresources.red};
        gitcommitUntracked = {fg = xresources.fg2};
        gitcommitDiscarded = {fg = xresources.fg2};
        gitcommitSelected = { fg=xresources.fg2};
        gitcommitUnmerged = { fg=xresources.fg2};
        gitcommitOnBranch = { fg=xresources.fg2};
        gitcommitArrow  = {fg = xresources.fg2};
        gitcommitFile  = {fg = xresources.green};
        --- ===========================================
        -- vista.vim
        -- =============================================
        Vistacyan = {fg=xresources.fg2};
        VistaChildrenNr = {fg=xresources.yellow};
        VistaKind = {fg=xresources.purple};
        VistaScope = {fg=xresources.red};
        VistaScopeKind = {fg=xresources.blue};
        VistaTag = {fg=xresources.purple,style='bold'};
        VistaPrefix = {fg=xresources.fg2};
        VistaColon = {fg=xresources.purple};
        VistaIcon = {fg=xresources.yellow};
        VistaLineNr = {fg=xresources.fg};
        -- ===========
        -- vim-signify
        -- ===========
        SignifySignAdd = {fg=xresources.green};
        SignifySignChange = {fg=xresources.blue};
        SignifySignDelete = {fg=xresources.red};
        -- ==============
        -- vim-dadbod-ui
        -- ==============
        dbui_tables = {fg=xresources.blue};
        -- =================
        -- dashboard-nvim
        -- =================
        DashboardShortCut = {fg=xresources.purple};
        DashboardHeader = {fg=xresources.yellow};
        DashboardCenter = {fg=xresources.blue};
        DashboardFooter = {fg=xresources.fg2};
        -- =========================
        -- Neovim LSP
        -- =========================
        LspDiagnosticsError = { fg = xresources.red };
        LspDiagnosticsWarning = { fg = xresources.yellow };
        LspDiagnosticsInformation = { fg = xresources.green };
        LspDiagnosticsHint = { fg = xresources.cyan };
        LspDiagnosticsSignError = {fg=xresources.red};
        LspDiagnosticsSignWarning = {fg=xresources.yellow};
        LspDiagnosticsSignInformation = {fg=xresources.blue};
        LspDiagnosticsSignHint = {fg=xresources.cyan};
        LspDiagnosticsVirtualTextError = {fg=xresources.red};
        LspDiagnosticsVirtualTextWarning= {fg=xresources.yellow};
        LspDiagnosticsVirtualTextInformation = {fg=xresources.green};
        LspDiagnosticsVirtualTextHint = {fg=xresources.cyan};
        LspDiagnosticsUnderlineError = {style="undercurl",sp=xresources.red};
        LspDiagnosticsUnderlineWarning = {style="undercurl",sp=xresources.yellow};
        LspDiagnosticsUnderlineInformation = {style="undercurl",sp=xresources.green};
        LspDiagnosticsUnderlineHint = {style="undercurl",sp=xresources.cyan};
        -- ===============
        -- vim-cursorword
        -- ===============
        CursorWord0 = {bg=xresources.fg2};
        CursorWord1 = {bg=xresources.fg2};
        -- ==================
        -- Nvim Tree
        -- ==================
        NvimTreeEmptyFolderName = {fg=xresources.blue};
        NvimTreeOpenedFolderName= {fg=xresources.blue};
        NvimTreeFolderName = {fg=xresources.blue};
        NvimTreeRootFolder = {fg=xresources.red};
        NvimTreeSpecialFile = {fg=xresources.fg,bg=xresources.none,stryle='NONE'};
        NvimTreeFolderIcon = { fg = xresources.blue};
        -- ==================
        -- Telescope Nvim
        -- ==================
        TelescopeBorder = {fg=xresources.cyan};
        TelescopePromptBorder = {fg=xresources.blue}
    }
    return plugin_syntax
end

local async_load_plugin

async_load_plugin = vim.loop.new_async(vim.schedule_wrap(function ()
    xresources.terminal_color()
    local syntax = xresources.load_plugin_syntax()
    for group, colors in pairs(syntax) do
        xresources.highlight(group,colors)
    end
    async_load_plugin:close()
end))

function xresources.colorscheme()
    vim.api.nvim_command('hi clear')
    if vim.fn.exists('syntax_on') then
        vim.api.nvim_command('syntax reset')
    end
    vim.o.termguicolors = true
    vim.g.colors_name = 'xresources'
    local syntax = xresources.load_syntax()
    for group, colors in pairs(syntax) do
        xresources.highlight(group,colors)
    end
    async_load_plugin:send()
end

xresources.colorscheme()

return xresources
