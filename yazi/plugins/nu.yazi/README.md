# nu.yazi

A plugin for [yazi](https://github.com/sxyazi/yazi) to execute nu code.

## Usage

Inside the nushell code there are some variables and definitions available:
- `$all`: array that containst either the hovered file or the selected files.
- `$hover`: string that contains the hovered file (empty string if there is no hovered file).
- `$select`: array that contains the selected files.

- `!`: alias for `ya emit` for communicating actions to yazi.
- `dbg`: custom command that prints it's argument to stderr and exists with a 1 status code so it will be shown in a notification inside yazi.

For the plugin itself, it takes the argument `--hide` that will hide the yazi window until the plugin ends, enabling user interactions with programs like `fzf`.

## Dependencies
- [nushell](https://github.com/nushell/nushell)

## Installation

```sh
ya pack -a 'Tyarel8/nu'
```

## Examples

Add this to your `keymap.toml`:

```toml
[[manager.prepend_keymap]]
on   = ["c", "t"]
run  = "plugin nu -- open --raw $hover | clip"
desc = "Copy the file contents"

[[manager.prepend_keymap]]
on   = ["c", "a"]
run  = """plugin nu -- '$all | each { str sandwich "`" } | str join " " | clip'"""
desc = "Copy as args"

[[manager.prepend_keymap]]
on   = ["c", "u"]
run  = "plugin nu -- $all | each { path url } | str join (char nl) | clip"
desc = "Copy file url"

[[manager.prepend_keymap]]
on = ["g", "y"]
run = """plugin nu -- '
    if ($hover | path type) != symlink { return }
    ls -D -l $hover | first | get target | if ($in | path type) == dir { ! cd $in } else { ! reveal $in }
'"""
desc = "Follow Symlink"

[[manager.prepend_keymap]]
on = ["'", "'", "s"]
run = """plugin nu -- '
    let $sch = ("~/AppData/Roaming/.minecraft/schematics" | path expand)
    mv ...$all $sch
    ! escape --select
    ! reveal ($sch | path join ($all.0 | path basename))'
"""
desc = "Move files to minecraft schematics"
```

> [!NOTE]  
> This plugin loads your nushell configuration, so some commands shown in the examples are not available in nushell by default.
