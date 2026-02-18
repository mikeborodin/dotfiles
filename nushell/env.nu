# Nushell Environment Config File
$env.PROMPT_INDICATOR = {|| " " }
$env.PROMPT_INDICATOR_VI_INSERT = {|| " " }
$env.PROMPT_INDICATOR_VI_NORMAL = {|| "󱊷 " }
$env.PROMPT_MULTILINE_INDICATOR = {|| "| " }
$env.TRANSIENT_PROMPT_COMMAND = {|| "* " }
$env.TRANSIENT_PROMPT_INDICATOR = {|| "" }
$env.TRANSIENT_PROMPT_INDICATOR_VI_INSERT = {|| "" }
$env.TRANSIENT_PROMPT_INDICATOR_VI_NORMAL = {|| "" }
$env.TRANSIENT_PROMPT_MULTILINE_INDICATOR = {|| "" }
$env.TRANSIENT_PROMPT_COMMAND_RIGHT = {|| "" }

$env.CMD_DURATION_MS = '0823'

$env.ANDROID_AVD_HOME = $"($env.HOME)/.config/.android/avd"
$env.ANDROID_HOME =  $"($env.HOME)/Library/Android/sdk"
$env.ANDROID_SDK_ROOT = $env.ANDROID_HOME
$env.QEMU_AUDIO_DRV = 'none'
$env.PATROL_MIGRATED = true
$env.HOMEBREW_NO_AUTO_UPDATE = 1

$env.QEMU_AUDIO_DRV = 'none'


$env.FZF_DEFAULT_OPTS = ( 
"--color=fg:#c0caf5,bg:#24283b,hl:#6f76b9
--color=fg+:#c0caf5,bg+:#292e42,hl+:#6f76b9
--color=info:#7aa2f7,prompt:#7dcfff,pointer:#7dcfff
--color=marker:#9ece6a,spinner:#9ece6a,header:#9ece6a
--reverse
--prompt '  '
--pointer 󰨃" 
)


$env.PATH = (
    ($env.HOME | path join 'programs/neovim/out/bin') 
    | append $env.PATH
    | append '/usr/local/bin'
    | append ($env.HOME | path join 'fvm/default/bin')
    | append ($env.HOME | path join 'programs/nnn/source')
    | append ($env.HOME | path join '.tmux/tmuxifier/bin')
    | append ($env.HOME | path join 'scripts')
    | append ($env.HOME | path join 'programs/bin')
    | append ($env.HOME | path join '.rvm/bin')
    | append ($env.HOME | path join '.rd/bin')
    | append ($env.HOME | path join '.shorebird/bin')
    | append ($env.HOME | path join '.amplify/bin')
    | append ($env.HOME | path join '.maestro/bin')
    | append ($env.HOME | path join '.npm-packages')
    | append ($env.HOME | path join 'go/bin')
    | append ($env.HOME | path join '.android/sdk/platform-tools')
    | append ($env.HOME | path join 'Library/Android/sdk/platform-tools')
    | append ($env.HOME | path join 'Library/Android/sdk/cmdline-tools/latest/bin')
    | append ($env.HOME | path join 'Library/Python/3.9/bin')
    | append ($env.HOME | path join 'Library/Android/sdk/emulator')
    | append ($env.HOME | path join 'programs/sonar-scanner/bin')
    | append ($env.HOME | path join '.pub-cache/bin')
    | append ($env.HOME | path join '.maestro/bin')
    | append ($env.HOME | path join 'personal_projects/extract/bin')
    | append ($env.HOME | path join 'personal_projects/other/bin')
    | append ($env.HOME | path join 'personal_projects/status/bin')
    | append ($env.HOME | path join 'personal_projects/testui/bin')
    | append ($env.HOME | path join 'personal_projects/buildrunnerui/bin')
    | append '/Users/mike/.local/bin'
    | append '/Applications/Firefox.app/Contents/MacOS'
    | append '/opt/homebrew/bin'
)

$env.AGENT_BASE_URL = 'https://openrouter.ai/api/v1'

# Specifies how environment variables are:
# - converted from a string to a value on Nushell startup (from_string)
# - converted from a value back to a string when running external commands (to_string)
# Note: The conversions happen *after* config.nu is loaded
$env.ENV_CONVERSIONS = {
    "PATH": {
        from_string: { |s| $s | split row (char esep) | path expand --no-symlink }
        to_string: { |v| $v | path expand --no-symlink | str join (char esep) }
    }
    "Path": {
        from_string: { |s| $s | split row (char esep) | path expand --no-symlink }
        to_string: { |v| $v | path expand --no-symlink | str join (char esep) }
    }
}

# Directories to search for scripts when calling source or use
# The default for this is $nu.default-config-dir/scripts
$env.NU_LIB_DIRS = [
    ($nu.default-config-dir | path join 'scripts') # add <nushell-config-dir>/scripts
    ($nu.data-dir | path join 'completions') # default home for nushell completions
]

$env.NU_PLUGIN_DIRS = [
    ($nu.default-config-dir | path join 'plugins') # add <nushell-config-dir>/plugins
]


source ($nu.default-config-dir | path join 'path.nu')
# source ($nu.default-config-dir | path join 'oh-my-posh.nu')
source ($nu.default-config-dir | path join 'aliases.nu')
source ($nu.default-config-dir | path join 'secrets.nu')

let dotfiles_dir = ($nu.default-config-dir | path dirname)
$env.OPENCODE_CONFIG = ($dotfiles_dir | path join 'opencode/opencode.json')

if (which devbox | is-not-empty) {
    load-env (
       (devbox global shellenv)
       | str trim
       | lines
       | parse 'export {name}="{value}";'
       | transpose --header-row --as-record
    )
} 

path add ($env.HOME | path join ".local" "bin")

let mise_path = $nu.default-config-dir | path join mise.nu
^mise activate nu | save $mise_path --force
