use std "path add"

path add "/opt/homebrew/bin"
path add "/Applications/Firefox.app/Contents/MacOS"
path add "/opt/homebrew/bin"

path add ($env.HOME | path join ".local" "bin")
path add ($env.HOME | path join "/fvm/default/bin")

path add ($env.HOME | path join "/programs/nnn/source")
path add ($env.HOME | path join "/.tmux/tmuxifier/bin")
path add ($env.HOME | path join "/go/bin")

path add ($env.HOME | path join "/scripts")
path add ($env.HOME | path join "/programs/bin")
path add ($env.HOME | path join "/programs/sonar-scanner/bin")


path add ($env.HOME | path join "/.android/sdk/platform-tools")
path add ($env.HOME | path join "/Library/Android/sdk/platform-tools")
path add ($env.HOME | path join "/Library/Android/sdk/cmdline-tools/latest/bin")
path add ($env.HOME | path join "/Library/Python/3.9/bin")
path add ($env.HOME | path join "/Library/Android/sdk/emulator")
path add ($env.HOME | path join "/.pub-cache/bin")
path add ($env.HOME | path join "/.maestro/bin")

path add ($env.HOME | path join "/personal_projects/extract/bin")
path add ($env.HOME | path join "/personal_projects/other/bin")
path add ($env.HOME | path join "/personal_projects/status/bin")
path add ($env.HOME | path join "/personal_projects/testui/bin")
path add ($env.HOME | path join "/personal_projects/buildrunnerui/bin")


# $env.DYLD_LIBRARY_PATH="$(brew --prefix)/lib:$DYLD_LIBRARY_PATH"

