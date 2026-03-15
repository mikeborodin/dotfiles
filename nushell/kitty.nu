# Kitty session helpers

const sessions_dir = "~/.config/kitty/sessions"
const nu_shim = "/Users/mike/.local/share/mise/shims/nu"

# Start a dev session for a folder, or switch to it if it already exists
def devsesh [folder: path] {
    let resolved = ($folder | path expand)

    if not ($resolved | path exists) {
        error make { msg: $"Folder does not exist: ($resolved)" }
    }

    let name = ($resolved | path basename)
    let session_file = ([$sessions_dir $"($name).kitty-session"] | path join | path expand)

    # Generate session file if it doesn't exist
    if not ($session_file | path exists) {
        let content = ([
            $"# ($name) session"
            ""
            "new_tab editor"
            $"cd ($resolved)"
            "layout tall"
            $"launch --title editor ($nu_shim) --login --execute v"
            ""
            "new_tab shell"
            $"cd ($resolved)"
            "launch --title shell"
            ""
            "new_tab git"
            $"cd ($resolved)"
            $"launch --title git ($nu_shim) --login --execute gg"
        ] | str join "\n")

        mkdir ($sessions_dir | path expand)
        $content | save $session_file
        print $"Created session: ($name)"
    }

    # Switch to the session
    kitty @ action goto_session $session_file
}
