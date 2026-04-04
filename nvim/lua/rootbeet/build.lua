local lush = require 'lush'
local colors = require 'rootbeet.colors'

local function write_file(path, text)
  -- ensure parent directories exist
  local dir = path:match('(.+)/[^/]+$')
  if dir then
    os.execute('mkdir -p ' .. dir)
  end
  local file, err = io.open(path, 'w+')
  if not file then
    error('Cannot open file ' .. path .. ': ' .. (err or 'unknown error'))
  end
  file:write(text)
  file:close()
end

local function render(template, colors)
  return string.gsub(template, '%$([%l_]+)', function(s)
    return colors[s].hex
  end)
end

local M = {}

function M.buildNvimTheme()
  local preamble = [[
hi clear
if exists("syntax_on")
  syntax reset
endif
let g:colors_name="rootbeet"
set background=dark
]]
  local lushwright = require 'shipwright.transform.lush'
  local theme = require 'rootbeet.lush_theme'
  local vimscript = table.concat(lushwright.to_vimscript(theme), '\n')

  write_file('nvim/colors/rootbeet.vim', preamble .. vimscript)
end

function M.kitty()
  local template = [[
foreground $fg
background $bg

selection_foreground $bg
selection_background $blue

cursor $green
cursor_text_color $bg

url_color $blue

active_border_color $bg_white
inactive_border_color $bg_black
bell_border_color $yellow

active_tab_foreground $fg
active_tab_background $bg_white
inactive_tab_foreground $black
inactive_tab_background $bg_black
tab_bar_background $bg

mark1_background $purple
mark2_background $cyan
mark3_background $blue

color0 $black
color8 $black

color1 $red
color9 $red

color2  $green
color10 $green

color3  $yellow
color11 $yellow

color4  $blue
color12 $blue

color5  $purple
color13 $purple

color6  $cyan
color14 $cyan

color7  $white
color15 $white
]]

  write_file('rootbeet-theme/kitty/rootbeet.conf', render(template, colors))
end

function M.fish()
  local template = [[
set fish_color_command $green
set fish_color_error $red
set fish_color_normal $fg
set fish_color_operator $white
set fish_color_param normal
set fish_color_quote $cyan
set fish_color_search_match --background=$bg_yellow
set fish_color_valid_path normal --underline
set fish_pager_color_progress $black
]]

  write_file('rootbeet-theme/fish/rootbeet.fish', string.gsub(render(template, colors), '#', ''))
end

function M.blink()
  local template = [[
t.prefs_.set('color-palette-overrides', [
  '$black', '$red', '$green', '$yellow', '$blue', '$purple', '$cyan', '$white',
  '$black', '$red', '$green', '$yellow', '$blue', '$purple', '$cyan', '$white',
]);

cursor = '$green'

t.prefs_.set('cursor-color', cursor + '80');
t.prefs_.set('foreground-color', '$fg');
t.prefs_.set('background-color', '$bg');
]]

  write_file('rootbeet-theme/blink/blink.js', render(template, colors))
end

function M.slack()
  -- no idea what second color is for, so making it obnoxious red,
  -- let's see if it pops up
  local template = [[
$bg,#ff0000,$bg_white,$fg,$bg_black,$fg,$green,$red,$bg,$fg
]]

  write_file('rootbeet-theme/slack/slack.txt', render(template, colors))
end

function M.fzf()
  local theme = {
    'query:regular',
    'hl:$yellow',
    'hl+:bold:$yellow',
    'prompt:$purple',
    'bg+:$bg_purple',
    'gutter:-1', -- -1 is background in fzf lingo
    'info:$black',
    'separator:$bg_black',
    'scrollbar:$black',
    'border:$black',
  }
  local template = '--color ' .. table.concat(theme, ',')
  write_file('rootbeet-theme/fzf/fzf.txt', render(template, colors))
end

function M.ghostty()
  local template = [[
cursor-color = $green
cursor-text = $bg

foreground = $fg
background = $bg

palette = 0=$black
palette = 1=$red
palette = 2=$green
palette = 3=$yellow
palette = 4=$blue
palette = 5=$purple
palette = 6=$cyan
palette = 7=$white
palette = 8=$black
palette = 9=$red
palette = 10=$green
palette = 11=$yellow
palette = 12=$blue
palette = 13=$purple
palette = 14=$cyan
palette = 15=$white
]]

  write_file('rootbeet-theme/ghostty/rootbeet', render(template, colors))
end

function M.tmux()
  local template = [[
set -g mode-style fg='$bg',bg='$fg'
set -g message-style fg='$bg',bg='$yellow'
set -g status-style bg='$bg_black',fg='$fg'
set -g pane-active-border-style fg='$black'
set -g pane-border-style fg='$bg_black'
set -g window-status-current-style bg='$bg_white'
set -g window-status-activity-style bg='#{window-status-style}'
]]

  write_file('rootbeet-theme/tmux/rootbeet.conf', render(template, colors))
end

function M.yazi()
  local schema_line = '"$schema" = "https://yazi-rs.github.io/schemas/theme.json"\n\n'
  local theme_template = [[
[mgr]
cwd = { fg = "$cyan" }

hovered         = { fg = "$fg", bg = "$bg_white" }
preview_hovered = { fg = "$bg", bg = "$fg" }

find_keyword  = { fg = "$yellow", italic = true }
find_position = { fg = "$purple", bg = "reset", italic = true }

marker_copied   = { fg = "$green", bg = "$green" }
marker_cut      = { fg = "$red", bg = "$red" }
marker_marked   = { fg = "$cyan", bg = "$cyan" }
marker_selected = { fg = "$blue", bg = "$blue" }

tab_active   = { fg = "$bg", bg = "$fg" }
tab_inactive = { fg = "$fg", bg = "$bg_white" }
tab_width    = 1

count_copied   = { fg = "$bg", bg = "$green" }
count_cut      = { fg = "$bg", bg = "$red" }
count_selected = { fg = "$bg", bg = "$blue" }

border_symbol = "│"
border_style  = { fg = "$black" }

syntect_theme = "~/.config/yazi/rootbeet.tmTheme"

[mode]
normal_main = { fg = "$bg", bg = "$blue", bold = true }
normal_alt  = { fg = "$blue", bg = "$bg_black"}

select_main = { fg = "$bg", bg = "$green", bold = true }
select_alt  = { fg = "$green", bg = "$bg_black"}

unset_main  = { fg = "$bg", bg = "$purple", bold = true }
unset_alt   = { fg = "$purple", bg = "$bg_black"}

[status]
separator_open  = ""
separator_close = ""

progress_label  = { fg = "#ffffff", bold = true }
progress_normal = { fg = "$blue", bg = "$bg_white" }
progress_error  = { fg = "$red", bg = "$bg_white" }

perm_type  = { fg = "$blue" }
perm_read  = { fg = "$yellow" }
perm_write = { fg = "$red" }
perm_exec  = { fg = "$green" }
perm_sep   = { fg = "$black" }

[input]
border   = { fg = "$black" }
title    = {}
value    = {}
selected = { reversed = true }

[pick]
border   = { fg = "$black" }
active   = { fg = "$purple" }
inactive = {}

[confirm]
border     = { fg = "$black" }
title      = { fg = "$black" }
content    = {}
list       = {}
btn_yes    = { reversed = true }
btn_no     = {}

[cmp]
border = { fg = "$black" }

[tasks]
border  = { fg = "$black" }
title   = {}
hovered = { underline = true }

[which]
mask            = { bg = "$bg_black" }
cand            = { fg = "$cyan" }
rest            = { fg = "$white" }
desc            = { fg = "$purple" }
separator       = "  "
separator_style = { fg = "$bg_white" }

[help]
on      = { fg = "$cyan" }
run     = { fg = "$purple" }
desc    = { fg = "$white" }
hovered = { bg = "$bg_white", bold = true }
footer  = { fg = "$fg", bg = "$bg_white" }

[notify]
title_info  = { fg = "$cyan" }
title_warn  = { fg = "$yellow" }
title_error = { fg = "$red" }

[filetype]
rules = [
	# Media
	{ mime = "image/*", fg = "$cyan" },
	{ mime = "{audio,video}/*", fg = "$yellow" },

	# Archives
	{ mime = "application/*zip", fg = "$purple" },
	{ mime = "application/x-{tar,bzip*,7z-compressed,xz,rar}", fg = "$purple" },

	# Documents
	{ mime = "application/{pdf,doc,rtf}", fg = "$green" },

	# Fallback
	{ name = "*", fg = "$fg" },
	{ name = "*/", fg = "$blue" }
]

[spot]
border = { fg = "$black" }
title  = { fg = "$black" }
tbl_cell = { fg = "$blue", reversed = true }
tbl_col = { bold = true }

[icon]
files = [
  { name = "kritadisplayrc", text = "", fg = "$purple" },
  { name = ".gtkrc-2.0", text = "", fg = "$cyan" },
  { name = "bspwmrc", text = "", fg = "$bg_black" },
  { name = "webpack", text = "󰜫", fg = "$blue" },
  { name = "tsconfig.json", text = "", fg = "$blue" },
  { name = ".vimrc", text = "", fg = "$green" },
  { name = "gemfile$", text = "", fg = "$bg_black" },
  { name = "xmobarrc", text = "", fg = "$red" },
  { name = "avif", text = "", fg = "$black" },
  { name = "fp-info-cache", text = "", fg = "$cyan" },
  { name = ".zshrc", text = "", fg = "$green" },
  { name = "robots.txt", text = "󰚩", fg = "$black" },
  { name = "dockerfile", text = "󰡨", fg = "$blue" },
  { name = ".git-blame-ignore-revs", text = "", fg = "$brown" },
  { name = ".nvmrc", text = "", fg = "$green" },
  { name = "hyprpaper.conf", text = "", fg = "$blue" },
  { name = ".prettierignore", text = "", fg = "$blue" },
  { name = "rakefile", text = "", fg = "$bg_black" },
  { name = "code_of_conduct", text = "", fg = "$red" },
  { name = "cmakelists.txt", text = "", fg = "$fg" },
  { name = ".env", text = "", fg = "$yellow" },
  { name = "copying.lesser", text = "", fg = "$yellow" },
  { name = "readme", text = "󰂺", fg = "$cyan" },
  { name = "settings.gradle", text = "", fg = "$bg_white" },
  { name = "gruntfile.coffee", text = "", fg = "$brown" },
  { name = ".eslintignore", text = "", fg = "$bg_white" },
  { name = "kalgebrarc", text = "", fg = "$blue" },
  { name = "kdenliverc", text = "", fg = "$blue" },
  { name = ".prettierrc.cjs", text = "", fg = "$blue" },
  { name = "cantorrc", text = "", fg = "$blue" },
  { name = "rmd", text = "", fg = "$blue" },
  { name = "vagrantfile$", text = "", fg = "$black" },
  { name = ".Xauthority", text = "", fg = "$brown" },
  { name = "prettier.config.ts", text = "", fg = "$blue" },
  { name = "node_modules", text = "", fg = "$red" },
  { name = ".prettierrc.toml", text = "", fg = "$blue" },
  { name = "build.zig.zon", text = "", fg = "$brown" },
  { name = ".ds_store", text = "", fg = "$bg_white" },
  { name = "PKGBUILD", text = "", fg = "$blue" },
  { name = ".prettierrc", text = "", fg = "$blue" },
  { name = ".bash_profile", text = "", fg = "$green" },
  { name = ".npmignore", text = "", fg = "$red" },
  { name = ".mailmap", text = "󰊢", fg = "$brown" },
  { name = ".codespellrc", text = "󰓆", fg = "$green" },
  { name = "svelte.config.js", text = "", fg = "$brown" },
  { name = "eslint.config.ts", text = "", fg = "$bg_white" },
  { name = "config", text = "", fg = "$black" },
  { name = ".gitlab-ci.yml", text = "", fg = "$brown" },
  { name = ".gitconfig", text = "", fg = "$brown" },
  { name = "_gvimrc", text = "", fg = "$green" },
  { name = ".xinitrc", text = "", fg = "$brown" },
  { name = "checkhealth", text = "󰓙", fg = "$blue" },
  { name = "sxhkdrc", text = "", fg = "$bg_black" },
  { name = ".bashrc", text = "", fg = "$green" },
  { name = "tailwind.config.mjs", text = "󱏿", fg = "$blue" },
  { name = "ext_typoscript_setup.txt", text = "", fg = "$brown" },
  { name = "commitlint.config.ts", text = "󰜘", fg = "$cyan" },
  { name = "py.typed", text = "", fg = "$yellow" },
  { name = ".nanorc", text = "", fg = "$bg_black" },
  { name = "commit_editmsg", text = "", fg = "$brown" },
  { name = ".luaurc", text = "", fg = "$blue" },
  { name = "fp-lib-table", text = "", fg = "$cyan" },
  { name = ".editorconfig", text = "", fg = "$cyan" },
  { name = "justfile", text = "", fg = "$black" },
  { name = "kdeglobals", text = "", fg = "$blue" },
  { name = "license.md", text = "", fg = "$yellow" },
  { name = ".clang-format", text = "", fg = "$black" },
  { name = "docker-compose.yaml", text = "󰡨", fg = "$blue" },
  { name = "copying", text = "", fg = "$yellow" },
  { name = "go.mod", text = "", fg = "$blue" },
  { name = "lxqt.conf", text = "", fg = "$blue" },
  { name = "brewfile", text = "", fg = "$bg_black" },
  { name = "gulpfile.coffee", text = "", fg = "$red" },
  { name = ".dockerignore", text = "󰡨", fg = "$blue" },
  { name = ".settings.json", text = "", fg = "$black" },
  { name = "tailwind.config.js", text = "󱏿", fg = "$blue" },
  { name = ".clang-tidy", text = "", fg = "$black" },
  { name = ".gvimrc", text = "", fg = "$green" },
  { name = "nuxt.config.cjs", text = "󱄆", fg = "$green" },
  { name = "xsettingsd.conf", text = "", fg = "$brown" },
  { name = "nuxt.config.js", text = "󱄆", fg = "$green" },
  { name = "eslint.config.cjs", text = "", fg = "$bg_white" },
  { name = "sym-lib-table", text = "", fg = "$cyan" },
  { name = ".condarc", text = "", fg = "$green" },
  { name = "xmonad.hs", text = "", fg = "$red" },
  { name = "tmux.conf", text = "", fg = "$green" },
  { name = "xmobarrc.hs", text = "", fg = "$red" },
  { name = ".prettierrc.yaml", text = "", fg = "$blue" },
  { name = ".pre-commit-config.yaml", text = "󰛢", fg = "$brown" },
  { name = "i3blocks.conf", text = "", fg = "$cyan" },
  { name = "xorg.conf", text = "", fg = "$brown" },
  { name = ".zshenv", text = "", fg = "$green" },
  { name = "vlcrc", text = "󰕼", fg = "$brown" },
  { name = "license", text = "", fg = "$yellow" },
  { name = "unlicense", text = "", fg = "$yellow" },
  { name = "tmux.conf.local", text = "", fg = "$green" },
  { name = ".SRCINFO", text = "󰣇", fg = "$blue" },
  { name = "tailwind.config.ts", text = "󱏿", fg = "$blue" },
  { name = "security.md", text = "󰒃", fg = "$white" },
  { name = "security", text = "󰒃", fg = "$white" },
  { name = ".eslintrc", text = "", fg = "$bg_white" },
  { name = "gradle.properties", text = "", fg = "$bg_white" },
  { name = "code_of_conduct.md", text = "", fg = "$red" },
  { name = "PrusaSlicerGcodeViewer.ini", text = "", fg = "$brown" },
  { name = "PrusaSlicer.ini", text = "", fg = "$brown" },
  { name = "procfile", text = "", fg = "$black" },
  { name = "mpv.conf", text = "", fg = "$bg" },
  { name = ".prettierrc.json5", text = "", fg = "$blue" },
  { name = "i3status.conf", text = "", fg = "$cyan" },
  { name = "prettier.config.mjs", text = "", fg = "$blue" },
  { name = ".pylintrc", text = "", fg = "$black" },
  { name = "prettier.config.cjs", text = "", fg = "$blue" },
  { name = ".luacheckrc", text = "", fg = "$blue" },
  { name = "containerfile", text = "󰡨", fg = "$blue" },
  { name = "eslint.config.mjs", text = "", fg = "$bg_white" },
  { name = "gruntfile.js", text = "", fg = "$brown" },
  { name = "bun.lockb", text = "", fg = "$cyan" },
  { name = ".gitattributes", text = "", fg = "$brown" },
  { name = "gruntfile.ts", text = "", fg = "$brown" },
  { name = "pom.xml", text = "", fg = "$bg_black" },
  { name = "favicon.ico", text = "", fg = "$yellow" },
  { name = "package-lock.json", text = "", fg = "$bg_black" },
  { name = "build", text = "", fg = "$green" },
  { name = "package.json", text = "", fg = "$red" },
  { name = "nuxt.config.ts", text = "󱄆", fg = "$green" },
  { name = "nuxt.config.mjs", text = "󱄆", fg = "$green" },
  { name = "mix.lock", text = "", fg = "$black" },
  { name = "makefile", text = "", fg = "$black" },
  { name = "gulpfile.js", text = "", fg = "$red" },
  { name = "lxde-rc.xml", text = "", fg = "$white" },
  { name = "kritarc", text = "", fg = "$purple" },
  { name = "gtkrc", text = "", fg = "$cyan" },
  { name = "ionic.config.json", text = "", fg = "$blue" },
  { name = ".prettierrc.mjs", text = "", fg = "$blue" },
  { name = ".prettierrc.yml", text = "", fg = "$blue" },
  { name = ".npmrc", text = "", fg = "$red" },
  { name = "weston.ini", text = "", fg = "$yellow" },
  { name = "gulpfile.babel.js", text = "", fg = "$red" },
  { name = "i18n.config.ts", text = "󰗊", fg = "$black" },
  { name = "commitlint.config.js", text = "󰜘", fg = "$cyan" },
  { name = ".gitmodules", text = "", fg = "$brown" },
  { name = "gradle-wrapper.properties", text = "", fg = "$bg_white" },
  { name = "hypridle.conf", text = "", fg = "$blue" },
  { name = "vercel.json", text = "▲", fg = "$cyan" },
  { name = "hyprlock.conf", text = "", fg = "$blue" },
  { name = "go.sum", text = "", fg = "$blue" },
  { name = "kdenlive-layoutsrc", text = "", fg = "$blue" },
  { name = "gruntfile.babel.js", text = "", fg = "$brown" },
  { name = "compose.yml", text = "󰡨", fg = "$blue" },
  { name = "i18n.config.js", text = "󰗊", fg = "$black" },
  { name = "readme.md", text = "󰂺", fg = "$cyan" },
  { name = "gradlew", text = "", fg = "$bg_white" },
  { name = "go.work", text = "", fg = "$blue" },
  { name = "gulpfile.ts", text = "", fg = "$red" },
  { name = "gnumakefile", text = "", fg = "$black" },
  { name = "FreeCAD.conf", text = "", fg = "$red" },
  { name = "compose.yaml", text = "󰡨", fg = "$blue" },
  { name = "eslint.config.js", text = "", fg = "$bg_white" },
  { name = "hyprland.conf", text = "", fg = "$blue" },
  { name = "docker-compose.yml", text = "󰡨", fg = "$blue" },
  { name = "groovy", text = "", fg = "$bg_white" },
  { name = "QtProject.conf", text = "", fg = "$green" },
  { name = "platformio.ini", text = "", fg = "$brown" },
  { name = "build.gradle", text = "", fg = "$bg_white" },
  { name = ".nuxtrc", text = "󱄆", fg = "$green" },
  { name = "_vimrc", text = "", fg = "$green" },
  { name = ".zprofile", text = "", fg = "$green" },
  { name = ".xsession", text = "", fg = "$brown" },
  { name = "prettier.config.js", text = "", fg = "$blue" },
  { name = ".babelrc", text = "", fg = "$yellow" },
  { name = "workspace", text = "", fg = "$green" },
  { name = ".prettierrc.json", text = "", fg = "$blue" },
  { name = ".prettierrc.js", text = "", fg = "$blue" },
  { name = ".Xresources", text = "", fg = "$brown" },
  { name = ".gitignore", text = "", fg = "$red" },
  { name = ".justfile", text = "", fg = "$black" },
  { name = "CODEOWNERS", text = "", fg = "$black" },
  { name = "slang.yaml", text = "󰗊", fg = "$black" },
  { name = "phrase.yaml", text = "󰗊", fg = "$black" },
  { name = ".metadata", text = "󰙅", fg = "$black" },
  { name = "pubspec.lock", text = "󰙅", fg = "$black" },
  { name = "devbox.lock", text = "", fg = "$black" },
  { name = "AndroidManifest.xml", text = "", fg = "#00f900" },
  { name = ".fvmrc", text = "", fg = "#fcd205" },
  { name = ".xctestplan", text = "", fg = "#fcd205" },
  { name = ".xcode-version", text = "", fg = "$black" },
  { name = ".flutter-plugins-dependencies", text = "", fg = "$black" },
  { name = ".flutter-plugins", text = "", fg = "$black" },
]
exts = [
  { name = "otf", text = "", fg = "$cyan" },
  { name = "import", text = "", fg = "$cyan" },
  { name = "krz", text = "", fg = "$purple" },
  { name = "adb", text = "", fg = "$cyan" },
  { name = "ttf", text = "", fg = "$cyan" },
  { name = "webpack", text = "󰜫", fg = "$blue" },
  { name = "dart", text = "", fg = "$blue" },
  { name = "vsh", text = "", fg = "$black" },
  { name = "doc", text = "󰈬", fg = "$bg_white" },
  { name = "zsh", text = "", fg = "$green" },
  { name = "ex", text = "", fg = "$black" },
  { name = "hx", text = "", fg = "$brown" },
  { name = "fodt", text = "", fg = "$blue" },
  { name = "mojo", text = "", fg = "$brown" },
  { name = "templ", text = "", fg = "$yellow" },
  { name = "nix", text = "", fg = "$blue" },
  { name = "cshtml", text = "󱦗", fg = "$bg_white" },
  { name = "fish", text = "", fg = "$bg_white" },
  { name = "ply", text = "󰆧", fg = "$black" },
  { name = "sldprt", text = "󰻫", fg = "$green" },
  { name = "gemspec", text = "", fg = "$bg_black" },
  { name = "mjs", text = "", fg = "$yellow" },
  { name = "csh", text = "", fg = "$bg_white" },
  { name = "cmake", text = "", fg = "$fg" },
  { name = "fodp", text = "", fg = "$brown" },
  { name = "vi", text = "", fg = "$yellow" },
  { name = "msf", text = "", fg = "$blue" },
  { name = "blp", text = "󰺾", fg = "$blue" },
  { name = "less", text = "", fg = "$bg_white" },
  { name = "sh", text = "", fg = "$bg_white" },
  { name = "odg", text = "", fg = "$yellow" },
  { name = "mint", text = "󰌪", fg = "$green" },
  { name = "dll", text = "", fg = "$bg" },
  { name = "odf", text = "", fg = "$red" },
  { name = "sqlite3", text = "", fg = "$cyan" },
  { name = "Dockerfile", text = "󰡨", fg = "$blue" },
  { name = "ksh", text = "", fg = "$bg_white" },
  { name = "rmd", text = "", fg = "$blue" },
  { name = "wv", text = "", fg = "$blue" },
  { name = "xml", text = "󰗀", fg = "$brown" },
  { name = "iml", text = "󰗀", fg = "$brown" },
  { name = "markdown", text = "", fg = "$fg" },
  { name = "qml", text = "", fg = "$green" },
  { name = "3gp", text = "", fg = "$brown" },
  { name = "pxi", text = "", fg = "$blue" },
  { name = "flac", text = "", fg = "$black" },
  { name = "gpr", text = "", fg = "$purple" },
  { name = "huff", text = "󰡘", fg = "$bg_white" },
  { name = "json", text = "", fg = "$yellow" },
  { name = "gv", text = "󱁉", fg = "$bg_white" },
  { name = "bmp", text = "", fg = "$black" },
  { name = "lock", text = "", fg = "$white" },
  { name = "sha384", text = "󰕥", fg = "$black" },
  { name = "cobol", text = "⚙", fg = "$bg_white" },
  { name = "cob", text = "⚙", fg = "$bg_white" },
  { name = "java", text = "", fg = "$red" },
  { name = "cjs", text = "", fg = "$yellow" },
  { name = "qm", text = "", fg = "$blue" },
  { name = "ebuild", text = "", fg = "$bg_white" },
  { name = "mustache", text = "", fg = "$brown" },
  { name = "terminal", text = "", fg = "$green" },
  { name = "ejs", text = "", fg = "$yellow" },
  { name = "brep", text = "󰻫", fg = "$green" },
  { name = "rar", text = "", fg = "$brown" },
  { name = "gradle", text = "", fg = "$blue" },
  { name = "gnumakefile", text = "", fg = "$black" },
  { name = "applescript", text = "", fg = "$black" },
  { name = "elm", text = "", fg = "$blue" },
  { name = "ebook", text = "", fg = "$brown" },
  { name = "kra", text = "", fg = "$purple" },
  { name = "tf", text = "", fg = "$bg_white" },
  { name = "xls", text = "󰈛", fg = "$bg_white" },
  { name = "fnl", text = "", fg = "$yellow" },
  { name = "kdbx", text = "", fg = "$green" },
  { name = "kicad_pcb", text = "", fg = "$cyan" },
  { name = "cfg", text = "", fg = "$black" },
  { name = "ape", text = "", fg = "$blue" },
  { name = "org", text = "", fg = "$cyan" },
  { name = "yml", text = "", fg = "$black" },
  { name = "swift", text = "", fg = "$brown" },
  { name = "eln", text = "", fg = "$black" },
  { name = "sol", text = "", fg = "$blue" },
  { name = "awk", text = "", fg = "$bg_white" },
  { name = "7z", text = "", fg = "$brown" },
  { name = "apl", text = "⍝", fg = "$brown" },
  { name = "epp", text = "", fg = "$brown" },
  { name = "app", text = "", fg = "$bg_white" },
  { name = "dot", text = "󱁉", fg = "$bg_white" },
  { name = "kpp", text = "", fg = "$purple" },
  { name = "eot", text = "", fg = "$cyan" },
  { name = "hpp", text = "", fg = "$black" },
  { name = "spec.tsx", text = "", fg = "$bg_white" },
  { name = "hurl", text = "", fg = "$red" },
  { name = "cxxm", text = "", fg = "$blue" },
  { name = "c", text = "", fg = "$blue" },
  { name = "fcmacro", text = "", fg = "$red" },
  { name = "sass", text = "", fg = "$red" },
  { name = "yaml", text = "󰙅", fg = "$brown" },
  { name = "properties", text = "", fg = "$blue" },
  { name = "xz", text = "", fg = "$brown" },
  { name = "material", text = "󰔉", fg = "$red" },
  { name = "json5", text = "", fg = "$yellow" },
  { name = "signature", text = "λ", fg = "$brown" },
  { name = "3mf", text = "󰆧", fg = "$black" },
  { name = "jpg", text = "", fg = "$black" },
  { name = "xpi", text = "", fg = "$brown" },
  { name = "fcmat", text = "", fg = "$red" },
  { name = "pot", text = "", fg = "$blue" },
  { name = "bin", text = "", fg = "$bg_white" },
  { name = "xlsx", text = "󰈛", fg = "$bg_white" },
  { name = "aac", text = "", fg = "$blue" },
  { name = "kicad_sym", text = "", fg = "$cyan" },
  { name = "xcstrings", text = "", fg = "$blue" },
  { name = "lff", text = "", fg = "$cyan" },
  { name = "xcf", text = "", fg = "$bg_white" },
  { name = "azcli", text = "", fg = "$black" },
  { name = "license", text = "", fg = "$yellow" },
  { name = "jsonc", text = "", fg = "$yellow" },
  { name = "xaml", text = "󰙳", fg = "$bg_white" },
  { name = "md5", text = "󰕥", fg = "$black" },
  { name = "xm", text = "", fg = "$blue" },
  { name = "sln", text = "", fg = "$black" },
  { name = "jl", text = "", fg = "$black" },
  { name = "ml", text = "", fg = "$brown" },
  { name = "http", text = "", fg = "$blue" },
  { name = "x", text = "", fg = "$blue" },
  { name = "wvc", text = "", fg = "$blue" },
  { name = "wrz", text = "󰆧", fg = "$black" },
  { name = "csproj", text = "󰪮", fg = "$bg_white" },
  { name = "wrl", text = "󰆧", fg = "$black" },
  { name = "wma", text = "", fg = "$blue" },
  { name = "woff2", text = "", fg = "$cyan" },
  { name = "woff", text = "", fg = "$cyan" },
  { name = "tscn", text = "", fg = "$black" },
  { name = "webmanifest", text = "", fg = "$yellow" },
  { name = "webm", text = "", fg = "$brown" },
  { name = "fcbak", text = "", fg = "$red" },
  { name = "log", text = "󱘿", fg = "$fg" },
  { name = "wav", text = "", fg = "$blue" },
  { name = "wasm", text = "", fg = "$bg_white" },
  { name = "styl", text = "", fg = "$green" },
  { name = "gif", text = "", fg = "$black" },
  { name = "resi", text = "", fg = "$red" },
  { name = "aiff", text = "", fg = "$blue" },
  { name = "sha256", text = "󰕥", fg = "$black" },
  { name = "igs", text = "󰻫", fg = "$green" },
  { name = "vsix", text = "", fg = "$black" },
  { name = "vim", text = "", fg = "$green" },
  { name = "diff", text = "", fg = "$bg_white" },
  { name = "drl", text = "", fg = "$red" },
  { name = "erl", text = "", fg = "$red" },
  { name = "vhdl", text = "󰍛", fg = "$green" },
  { name = "🔥", text = "", fg = "$brown" },
  { name = "hrl", text = "", fg = "$red" },
  { name = "fsi", text = "", fg = "$blue" },
  { name = "mm", text = "", fg = "$blue" },
  { name = "bz", text = "", fg = "$brown" },
  { name = "vh", text = "󰍛", fg = "$green" },
  { name = "kdb", text = "", fg = "$green" },
  { name = "gz", text = "", fg = "$brown" },
  { name = "cpp", text = "", fg = "$blue" },
  { name = "ui", text = "", fg = "$black" },
  { name = "txt", text = "󰈙", fg = "$green" },
  { name = "spec.ts", text = "", fg = "$blue" },
  { name = "ccm", text = "", fg = "$red" },
  { name = "typoscript", text = "", fg = "$brown" },
  { name = "typ", text = "", fg = "$blue" },
  { name = "txz", text = "", fg = "$brown" },
  { name = "test.ts", text = "", fg = "$blue" },
  { name = "tsx", text = "", fg = "$bg_white" },
  { name = "mk", text = "", fg = "$black" },
  { name = "webp", text = "", fg = "$black" },
  { name = "opus", text = "", fg = "$black" },
  { name = "bicep", text = "", fg = "$blue" },
  { name = "ts", text = "", fg = "$blue" },
  { name = "tres", text = "", fg = "$black" },
  { name = "torrent", text = "", fg = "$cyan" },
  { name = "cxx", text = "", fg = "$blue" },
  { name = "iso", text = "", fg = "$cyan" },
  { name = "ixx", text = "", fg = "$blue" },
  { name = "hxx", text = "", fg = "$black" },
  { name = "gql", text = "", fg = "$red" },
  { name = "tmux", text = "", fg = "$green" },
  { name = "ini", text = "", fg = "$black" },
  { name = "m3u8", text = "󰲹", fg = "$red" },
  { name = "image", text = "", fg = "$cyan" },
  { name = "tfvars", text = "", fg = "$bg_white" },
  { name = "tex", text = "", fg = "$bg_white" },
  { name = "cbl", text = "⚙", fg = "$bg_white" },
  { name = "flc", text = "", fg = "$cyan" },
  { name = "elc", text = "", fg = "$black" },
  { name = "test.tsx", text = "", fg = "$bg_white" },
  { name = "twig", text = "", fg = "$green" },
  { name = "sql", text = "", fg = "$cyan" },
  { name = "test.jsx", text = "", fg = "$blue" },
  { name = "htm", text = "", fg = "$brown" },
  { name = "gcode", text = "󰐫", fg = "$black" },
  { name = "test.js", text = "", fg = "$yellow" },
  { name = "ino", text = "", fg = "$blue" },
  { name = "tcl", text = "󰛓", fg = "$bg_white" },
  { name = "cljs", text = "", fg = "$blue" },
  { name = "tsconfig", text = "", fg = "$brown" },
  { name = "img", text = "", fg = "$cyan" },
  { name = "t", text = "", fg = "$blue" },
  { name = "fcstd1", text = "", fg = "$red" },
  { name = "out", text = "", fg = "$bg_white" },
  { name = "jsx", text = "", fg = "$blue" },
  { name = "bash", text = "", fg = "$green" },
  { name = "edn", text = "", fg = "$blue" },
  { name = "rss", text = "", fg = "$brown" },
  { name = "flf", text = "", fg = "$cyan" },
  { name = "cache", text = "", fg = "$cyan" },
  { name = "sbt", text = "", fg = "$red" },
  { name = "cppm", text = "", fg = "$blue" },
  { name = "svelte", text = "", fg = "$brown" },
  { name = "mo", text = "∞", fg = "$black" },
  { name = "sv", text = "󰍛", fg = "$green" },
  { name = "ko", text = "", fg = "$cyan" },
  { name = "suo", text = "", fg = "$black" },
  { name = "sldasm", text = "󰻫", fg = "$green" },
  { name = "icalendar", text = "", fg = "$bg_black" },
  { name = "go", text = "", fg = "$blue" },
  { name = "sublime", text = "", fg = "$brown" },
  { name = "stl", text = "󰆧", fg = "$black" },
  { name = "mobi", text = "", fg = "$brown" },
  { name = "graphql", text = "", fg = "$red" },
  { name = "m3u", text = "󰲹", fg = "$red" },
  { name = "cpy", text = "⚙", fg = "$bg_white" },
  { name = "kdenlive", text = "", fg = "$blue" },
  { name = "pyo", text = "", fg = "$yellow" },
  { name = "po", text = "", fg = "$blue" },
  { name = "scala", text = "", fg = "$red" },
  { name = "exs", text = "", fg = "$black" },
  { name = "odp", text = "", fg = "$brown" },
  { name = "dump", text = "", fg = "$cyan" },
  { name = "stp", text = "󰻫", fg = "$green" },
  { name = "step", text = "󰻫", fg = "$green" },
  { name = "ste", text = "󰻫", fg = "$green" },
  { name = "aif", text = "", fg = "$blue" },
  { name = "strings", text = "", fg = "$blue" },
  { name = "cp", text = "", fg = "$blue" },
  { name = "fsscript", text = "", fg = "$blue" },
  { name = "mli", text = "", fg = "$brown" },
  { name = "bak", text = "󰁯", fg = "$black" },
  { name = "ssa", text = "󰨖", fg = "$yellow" },
  { name = "toml", text = "", fg = "$bg_white" },
  { name = "makefile", text = "", fg = "$black" },
  { name = "php", text = "", fg = "$black" },
  { name = "zst", text = "", fg = "$brown" },
  { name = "spec.jsx", text = "", fg = "$blue" },
  { name = "kbx", text = "󰯄", fg = "$black" },
  { name = "fbx", text = "󰆧", fg = "$black" },
  { name = "blend", text = "󰂫", fg = "$brown" },
  { name = "ifc", text = "󰻫", fg = "$green" },
  { name = "spec.js", text = "", fg = "$yellow" },
  { name = "so", text = "", fg = "$cyan" },
  { name = "desktop", text = "", fg = "$bg_white" },
  { name = "sml", text = "λ", fg = "$brown" },
  { name = "slvs", text = "󰻫", fg = "$green" },
  { name = "pp", text = "", fg = "$brown" },
  { name = "ps1", text = "󰨊", fg = "$black" },
  { name = "dropbox", text = "", fg = "$black" },
  { name = "kicad_mod", text = "", fg = "$cyan" },
  { name = "bat", text = "", fg = "$green" },
  { name = "slim", text = "", fg = "$brown" },
  { name = "skp", text = "󰻫", fg = "$green" },
  { name = "css", text = "", fg = "$blue" },
  { name = "xul", text = "", fg = "$brown" },
  { name = "ige", text = "󰻫", fg = "$green" },
  { name = "glb", text = "", fg = "$brown" },
  { name = "ppt", text = "󰈧", fg = "$red" },
  { name = "sha512", text = "󰕥", fg = "$black" },
  { name = "ics", text = "", fg = "$bg_black" },
  { name = "mdx", text = "", fg = "$blue" },
  { name = "sha1", text = "󰕥", fg = "$black" },
  { name = "f3d", text = "󰻫", fg = "$green" },
  { name = "ass", text = "󰨖", fg = "$yellow" },
  { name = "godot", text = "", fg = "$black" },
  { name = "ifb", text = "", fg = "$bg_black" },
  { name = "cson", text = "", fg = "$yellow" },
  { name = "lib", text = "", fg = "$bg" },
  { name = "luac", text = "", fg = "$blue" },
  { name = "heex", text = "", fg = "$black" },
  { name = "scm", text = "󰘧", fg = "$cyan" },
  { name = "psd1", text = "󰨊", fg = "$black" },
  { name = "sc", text = "", fg = "$red" },
  { name = "scad", text = "", fg = "$yellow" },
  { name = "kts", text = "", fg = "$black" },
  { name = "svh", text = "󰍛", fg = "$green" },
  { name = "mts", text = "", fg = "$blue" },
  { name = "nfo", text = "", fg = "$yellow" },
  { name = "pck", text = "", fg = "$black" },
  { name = "rproj", text = "󰗆", fg = "$green" },
  { name = "rlib", text = "", fg = "$brown" },
  { name = "cljd", text = "", fg = "$blue" },
  { name = "ods", text = "", fg = "$green" },
  { name = "res", text = "", fg = "$red" },
  { name = "apk", text = "", fg = "$green" },
  { name = "haml", text = "", fg = "$cyan" },
  { name = "d.ts", text = "", fg = "$brown" },
  { name = "razor", text = "󱦘", fg = "$bg_white" },
  { name = "rake", text = "", fg = "$bg_black" },
  { name = "patch", text = "", fg = "$bg_white" },
  { name = "cuh", text = "", fg = "$black" },
  { name = "d", text = "", fg = "$red" },
  { name = "query", text = "", fg = "$green" },
  { name = "psb", text = "", fg = "$blue" },
  { name = "nu", text = "", fg = "#009051" },
  { name = "mov", text = "", fg = "$brown" },
  { name = "lrc", text = "󰨖", fg = "$yellow" },
  { name = "pyx", text = "", fg = "$blue" },
  { name = "pyw", text = "", fg = "$blue" },
  { name = "cu", text = "", fg = "$green" },
  { name = "bazel", text = "", fg = "$green" },
  { name = "obj", text = "󰆧", fg = "$black" },
  { name = "pyi", text = "", fg = "$yellow" },
  { name = "pyd", text = "", fg = "$yellow" },
  { name = "exe", text = "", fg = "$bg_white" },
  { name = "pyc", text = "", fg = "$yellow" },
  { name = "fctb", text = "", fg = "$red" },
  { name = "part", text = "", fg = "$cyan" },
  { name = "blade.php", text = "", fg = "$red" },
  { name = "git", text = "", fg = "$brown" },
  { name = "psd", text = "", fg = "$blue" },
  { name = "qss", text = "", fg = "$green" },
  { name = "csv", text = "", fg = "$green" },
  { name = "psm1", text = "󰨊", fg = "$black" },
  { name = "dconf", text = "", fg = "$cyan" },
  { name = "config.ru", text = "", fg = "$bg_black" },
  { name = "prisma", text = "", fg = "$black" },
  { name = "conf", text = "", fg = "$black" },
  { name = "clj", text = "", fg = "$green" },
  { name = "o", text = "", fg = "$bg_white" },
  { name = "mp4", text = "", fg = "$brown" },
  { name = "cc", text = "", fg = "$red" },
  { name = "kicad_prl", text = "", fg = "$cyan" },
  { name = "bz3", text = "", fg = "$brown" },
  { name = "asc", text = "󰦝", fg = "$black" },
  { name = "png", text = "", fg = "$black" },
  { name = "android", text = "", fg = "$green" },
  { name = "pm", text = "", fg = "$blue" },
  { name = "h", text = "", fg = "$black" },
  { name = "pls", text = "󰲹", fg = "$red" },
  { name = "ipynb", text = "", fg = "$brown" },
  { name = "pl", text = "", fg = "$blue" },
  { name = "ads", text = "", fg = "$cyan" },
  { name = "sqlite", text = "", fg = "$cyan" },
  { name = "pdf", text = "", fg = "$bg_white" },
  { name = "pcm", text = "", fg = "$black" },
  { name = "ico", text = "", fg = "$yellow" },
  { name = "a", text = "", fg = "$cyan" },
  { name = "R", text = "󰟔", fg = "$black" },
  { name = "ogg", text = "", fg = "$black" },
  { name = "pxd", text = "", fg = "$blue" },
  { name = "kdenlivetitle", text = "", fg = "$blue" },
  { name = "jxl", text = "", fg = "$black" },
  { name = "nswag", text = "", fg = "$green" },
  { name = "nim", text = "", fg = "$yellow" },
  { name = "bqn", text = "⎉", fg = "$black" },
  { name = "cts", text = "", fg = "$blue" },
  { name = "fcparam", text = "", fg = "$red" },
  { name = "rs", text = "", fg = "$brown" },
  { name = "mpp", text = "", fg = "$blue" },
  { name = "fdmdownload", text = "", fg = "$cyan" },
  { name = "pptx", text = "󰈧", fg = "$red" },
  { name = "jpeg", text = "", fg = "$black" },
  { name = "bib", text = "󱉟", fg = "$yellow" },
  { name = "vhd", text = "󰍛", fg = "$green" },
  { name = "m", text = "", fg = "$blue" },
  { name = "js", text = "", fg = "$yellow" },
  { name = "eex", text = "", fg = "$black" },
  { name = "tbc", text = "󰛓", fg = "$bg_white" },
  { name = "astro", text = "", fg = "$red" },
  { name = "sha224", text = "󰕥", fg = "$black" },
  { name = "xcplayground", text = "", fg = "$brown" },
  { name = "el", text = "", fg = "$black" },
  { name = "m4v", text = "", fg = "$brown" },
  { name = "m4a", text = "", fg = "$blue" },
  { name = "cs", text = "󰌛", fg = "$bg_white" },
  { name = "hs", text = "", fg = "$black" },
  { name = "tgz", text = "", fg = "$brown" },
  { name = "fs", text = "", fg = "$blue" },
  { name = "luau", text = "", fg = "$blue" },
  { name = "dxf", text = "󰻫", fg = "$green" },
  { name = "download", text = "", fg = "$cyan" },
  { name = "cast", text = "", fg = "$brown" },
  { name = "qrc", text = "", fg = "$green" },
  { name = "lua", text = "", fg = "$blue" },
  { name = "lhs", text = "", fg = "$black" },
  { name = "md", text = "", fg = "$fg" },
  { name = "leex", text = "", fg = "$black" },
  { name = "ai", text = "", fg = "$yellow" },
  { name = "lck", text = "", fg = "$white" },
  { name = "kt", text = "", fg = "$black" },
  { name = "bicepparam", text = "", fg = "$black" },
  { name = "hex", text = "", fg = "$black" },
  { name = "zig", text = "", fg = "$brown" },
  { name = "bzl", text = "", fg = "$green" },
  { name = "cljc", text = "", fg = "$green" },
  { name = "kicad_dru", text = "", fg = "$cyan" },
  { name = "fctl", text = "", fg = "$red" },
  { name = "f#", text = "", fg = "$blue" },
  { name = "odt", text = "", fg = "$blue" },
  { name = "conda", text = "", fg = "$green" },
  { name = "vala", text = "", fg = "$bg_white" },
  { name = "erb", text = "", fg = "$bg_black" },
  { name = "mp3", text = "", fg = "$blue" },
  { name = "bz2", text = "", fg = "$brown" },
  { name = "coffee", text = "", fg = "$yellow" },
  { name = "cr", text = "", fg = "$cyan" },
  { name = "f90", text = "󱈚", fg = "$bg_white" },
  { name = "jwmrc", text = "", fg = "$black" },
  { name = "c++", text = "", fg = "$red" },
  { name = "fcscript", text = "", fg = "$red" },
  { name = "fods", text = "", fg = "$green" },
  { name = "cue", text = "󰲹", fg = "$red" },
  { name = "srt", text = "󰨖", fg = "$yellow" },
  { name = "info", text = "", fg = "$yellow" },
  { name = "hh", text = "", fg = "$black" },
  { name = "sig", text = "λ", fg = "$brown" },
  { name = "html", text = "", fg = "$brown" },
  { name = "iges", text = "󰻫", fg = "$green" },
  { name = "kicad_wks", text = "", fg = "$cyan" },
  { name = "hbs", text = "", fg = "$brown" },
  { name = "fcstd", text = "", fg = "$red" },
  { name = "gresource", text = "", fg = "$cyan" },
  { name = "sub", text = "󰨖", fg = "$yellow" },
  { name = "ical", text = "", fg = "$bg_black" },
  { name = "crdownload", text = "", fg = "$cyan" },
  { name = "pub", text = "󰷖", fg = "$yellow" },
  { name = "vue", text = "", fg = "$green" },
  { name = "gd", text = "", fg = "$black" },
  { name = "fsx", text = "", fg = "$blue" },
  { name = "mkv", text = "", fg = "$brown" },
  { name = "py", text = "", fg = "$yellow" },
  { name = "kicad_sch", text = "", fg = "$cyan" },
  { name = "epub", text = "", fg = "$brown" },
  { name = "env", text = "", fg = "$yellow" },
  { name = "magnet", text = "", fg = "$bg_white" },
  { name = "elf", text = "", fg = "$bg_white" },
  { name = "fodg", text = "", fg = "$yellow" },
  { name = "svg", text = "󰜡", fg = "$brown" },
  { name = "dwg", text = "󰻫", fg = "$green" },
  { name = "docx", text = "󰈬", fg = "$bg_white" },
  { name = "pro", text = "", fg = "$yellow" },
  { name = "db", text = "", fg = "$cyan" },
  { name = "rb", text = "", fg = "$bg_black" },
  { name = "r", text = "󰟔", fg = "$black" },
  { name = "scss", text = "", fg = "$red" },
  { name = "cow", text = "󰆚", fg = "$brown" },
  { name = "gleam", text = "", fg = "$purple" },
  { name = "v", text = "󰍛", fg = "$green" },
  { name = "kicad_pro", text = "", fg = "$cyan" },
  { name = "liquid", text = "", fg = "$green" },
  { name = "zip", text = "", fg = "$brown" },
]
]]

  write_file('yazi/theme.toml', schema_line .. render(theme_template, colors))

  -- tmTheme for syntax highlighting in yazi preview (XML/plist format)
  -- This maps neovim's rootbeet highlight groups to TextMate scopes
  local tmtheme_template = [[
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
	<key>name</key>
	<string>rootbeet</string>
	<key>settings</key>
	<array>
		<dict>
			<key>settings</key>
			<dict>
				<key>background</key>
				<string>$bg</string>
				<key>foreground</key>
				<string>$fg</string>
				<key>caret</key>
				<string>$green</string>
				<key>lineHighlight</key>
				<string>$bg_black</string>
				<key>selection</key>
				<string>$bg_purple</string>
				<key>selectionBorder</key>
				<string>$bg_purple</string>
				<key>findHighlight</key>
				<string>$bg_yellow</string>
				<key>guide</key>
				<string>$bg_white</string>
				<key>gutterForeground</key>
				<string>$bg_white</string>
			</dict>
		</dict>
		<dict>
			<key>name</key>
			<string>Comment</string>
			<key>scope</key>
			<string>comment, punctuation.definition.comment</string>
			<key>settings</key>
			<dict>
				<key>foreground</key>
				<string>$comment</string>
				<key>fontStyle</key>
				<string>italic</string>
			</dict>
		</dict>
		<dict>
			<key>name</key>
			<string>String</string>
			<key>scope</key>
			<string>string, constant.other.symbol</string>
			<key>settings</key>
			<dict>
				<key>foreground</key>
				<string>$green</string>
			</dict>
		</dict>
		<dict>
			<key>name</key>
			<string>Number</string>
			<key>scope</key>
			<string>constant.numeric</string>
			<key>settings</key>
			<dict>
				<key>foreground</key>
				<string>$green</string>
			</dict>
		</dict>
		<dict>
			<key>name</key>
			<string>Constant</string>
			<key>scope</key>
			<string>constant, constant.language, constant.character</string>
			<key>settings</key>
			<dict>
				<key>foreground</key>
				<string>$green</string>
			</dict>
		</dict>
		<dict>
			<key>name</key>
			<string>Built-in constant</string>
			<key>scope</key>
			<string>constant.language</string>
			<key>settings</key>
			<dict>
				<key>foreground</key>
				<string>$green</string>
				<key>fontStyle</key>
				<string>italic</string>
			</dict>
		</dict>
		<dict>
			<key>name</key>
			<string>Variable</string>
			<key>scope</key>
			<string>variable, variable.other</string>
			<key>settings</key>
			<dict>
				<key>foreground</key>
				<string>$fg</string>
			</dict>
		</dict>
		<dict>
			<key>name</key>
			<string>Identifier</string>
			<key>scope</key>
			<string>variable.other.readwrite, variable.other.object</string>
			<key>settings</key>
			<dict>
				<key>foreground</key>
				<string>$brown</string>
			</dict>
		</dict>
		<dict>
			<key>name</key>
			<string>Keyword</string>
			<key>scope</key>
			<string>keyword, storage.type, storage.modifier</string>
			<key>settings</key>
			<dict>
				<key>foreground</key>
				<string>$white</string>
			</dict>
		</dict>
		<dict>
			<key>name</key>
			<string>Statement</string>
			<key>scope</key>
			<string>keyword.control, keyword.operator.logical, keyword.operator.assignment</string>
			<key>settings</key>
			<dict>
				<key>foreground</key>
				<string>$white</string>
			</dict>
		</dict>
		<dict>
			<key>name</key>
			<string>Operator</string>
			<key>scope</key>
			<string>keyword.operator</string>
			<key>settings</key>
			<dict>
				<key>foreground</key>
				<string>$white</string>
			</dict>
		</dict>
		<dict>
			<key>name</key>
			<string>Function</string>
			<key>scope</key>
			<string>entity.name.function, support.function, meta.function-call</string>
			<key>settings</key>
			<dict>
				<key>foreground</key>
				<string>$yellow</string>
			</dict>
		</dict>
		<dict>
			<key>name</key>
			<string>Built-in function</string>
			<key>scope</key>
			<string>support.function.builtin</string>
			<key>settings</key>
			<dict>
				<key>foreground</key>
				<string>$yellow</string>
				<key>fontStyle</key>
				<string>italic</string>
			</dict>
		</dict>
		<dict>
			<key>name</key>
			<string>Type</string>
			<key>scope</key>
			<string>entity.name.type, entity.name.class, entity.name.struct, entity.name.enum, entity.name.union, entity.name.trait, entity.name.interface, support.type, support.class</string>
			<key>settings</key>
			<dict>
				<key>foreground</key>
				<string>$purple</string>
			</dict>
		</dict>
		<dict>
			<key>name</key>
			<string>Constructor / Tag</string>
			<key>scope</key>
			<string>entity.name.tag, entity.name.function.constructor, meta.tag</string>
			<key>settings</key>
			<dict>
				<key>foreground</key>
				<string>$yellow</string>
			</dict>
		</dict>
		<dict>
			<key>name</key>
			<string>Tag attribute</string>
			<key>scope</key>
			<string>entity.other.attribute-name</string>
			<key>settings</key>
			<dict>
				<key>foreground</key>
				<string>$brown</string>
			</dict>
		</dict>
		<dict>
			<key>name</key>
			<string>Preprocessor</string>
			<key>scope</key>
			<string>meta.preprocessor, keyword.control.import, keyword.control.directive</string>
			<key>settings</key>
			<dict>
				<key>foreground</key>
				<string>$white</string>
			</dict>
		</dict>
		<dict>
			<key>name</key>
			<string>Library / Module</string>
			<key>scope</key>
			<string>entity.name.module, entity.name.namespace, support.other.module</string>
			<key>settings</key>
			<dict>
				<key>foreground</key>
				<string>$brown</string>
			</dict>
		</dict>
		<dict>
			<key>name</key>
			<string>Special</string>
			<key>scope</key>
			<string>punctuation, meta.brace, meta.delimiter</string>
			<key>settings</key>
			<dict>
				<key>foreground</key>
				<string>$white</string>
			</dict>
		</dict>
		<dict>
			<key>name</key>
			<string>Invalid</string>
			<key>scope</key>
			<string>invalid</string>
			<key>settings</key>
			<dict>
				<key>foreground</key>
				<string>$fg</string>
				<key>background</key>
				<string>$red</string>
			</dict>
		</dict>
		<dict>
			<key>name</key>
			<string>Diff added</string>
			<key>scope</key>
			<string>markup.inserted</string>
			<key>settings</key>
			<dict>
				<key>foreground</key>
				<string>$green</string>
			</dict>
		</dict>
		<dict>
			<key>name</key>
			<string>Diff deleted</string>
			<key>scope</key>
			<string>markup.deleted</string>
			<key>settings</key>
			<dict>
				<key>foreground</key>
				<string>$red</string>
			</dict>
		</dict>
		<dict>
			<key>name</key>
			<string>Diff changed</string>
			<key>scope</key>
			<string>markup.changed</string>
			<key>settings</key>
			<dict>
				<key>foreground</key>
				<string>$brown</string>
			</dict>
		</dict>
		<dict>
			<key>name</key>
			<string>Heading</string>
			<key>scope</key>
			<string>markup.heading, entity.name.section</string>
			<key>settings</key>
			<dict>
				<key>foreground</key>
				<string>$yellow</string>
				<key>fontStyle</key>
				<string>bold</string>
			</dict>
		</dict>
		<dict>
			<key>name</key>
			<string>Bold</string>
			<key>scope</key>
			<string>markup.bold</string>
			<key>settings</key>
			<dict>
				<key>fontStyle</key>
				<string>bold</string>
			</dict>
		</dict>
		<dict>
			<key>name</key>
			<string>Italic</string>
			<key>scope</key>
			<string>markup.italic</string>
			<key>settings</key>
			<dict>
				<key>fontStyle</key>
				<string>italic</string>
			</dict>
		</dict>
		<dict>
			<key>name</key>
			<string>Link</string>
			<key>scope</key>
			<string>markup.underline.link, string.other.link</string>
			<key>settings</key>
			<dict>
				<key>foreground</key>
				<string>$blue</string>
				<key>fontStyle</key>
				<string>underline</string>
			</dict>
		</dict>
		<dict>
			<key>name</key>
			<string>Code / Raw</string>
			<key>scope</key>
			<string>markup.inline.raw, markup.raw</string>
			<key>settings</key>
			<dict>
				<key>foreground</key>
				<string>$green</string>
			</dict>
		</dict>
	</array>
</dict>
</plist>
]]

  -- The render function uses $var patterns, but we also need $comment and $brown
  -- which are derived colors. We build a colors table with all needed values.
  local tmcolors = {}
  for k, v in pairs(colors) do
    tmcolors[k] = v
  end
  tmcolors.comment = colors.white.da(20)
  write_file('yazi/rootbeet.tmTheme', render(tmtheme_template, tmcolors))
end

function M.all()
  M.buildNvimTheme()
  M.kitty()
  M.fish()
  M.blink()
  M.slack()
  M.fzf()
  M.ghostty()
  M.tmux()
  M.yazi()
end

return M
