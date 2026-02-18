def "parse vars" [] {
  $in | from csv --noheaders --no-infer | rename 'op' 'name' 'value'
}

def --env "update-env" [] {
  for $var in $in {
    if $var.op == "set" {
      if ($var.name | str upcase) == 'PATH' {
        $env.PATH = ($var.value | split row (char esep))
      } else {
        load-env {($var.name): $var.value}
      }
    } else if $var.op == "hide" and $var.name in $env {
      hide-env $var.name
    }
  }
}
export-env {
  
  'set,PATH,/Users/mike/.local/share/devbox/global/default/.devbox/virtenv/ruby_3_2/bin:/Users/mike/.local/share/devbox/global/default/.devbox/nix/profile/default/bin:/Users/mike/Downloads/ioquake3.app/Contents/MacOS:/Users/mike/personal_projects/buildrunnerui/bin:/Users/mike/personal_projects/testui/bin:/Users/mike/personal_projects/status/bin:/Users/mike/personal_projects/other/bin:/Users/mike/personal_projects/extract/bin:/Users/mike/personal_projects/testui3:/Users/mike/.maestro/bin:/Users/mike/.npm-packages/bin:/Users/mike/.pub-cache/bin:/Users/mike/Library/Android/sdk/emulator:/Users/mike/Library/Python/3.9/bin:/Users/mike/Library/Android/sdk/cmdline-tools/latest/bin:/Users/mike/Library/Android/sdk/platform-tools:/Users/mike/.android/sdk/platform-tools:/Users/mike/.opencode/bin:/Users/mike/programs/neovim/out/bin:/Users/mike/programs/bin:/Users/mike/scripts:/Users/mike/go/bin:/Users/mike/programs/nnn/source:/Users/mike/fvm/default/bin:/Users/mike/.local/bin:/Applications/Firefox.app/Contents/MacOS:/opt/homebrew/bin:/Users/mike/.local/share/nvim/mason/bin:/Users/mike/.nix-profile/bin:/nix/var/nix/profiles/default/bin:/usr/bin:/bin:/usr/sbin:/sbin:/usr/local/bin:/Users/mike/.tmux/tmuxifier/bin:/Users/mike/.rvm/bin:/Users/mike/.rd/bin:/Users/mike/.shorebird/bin:/Users/mike/.amplify/bin:/Users/mike/.npm-packages:/Users/mike/programs/sonar-scanner/bin:/Users/mike/.local/share/devbox/global/default/.devbox/virtenv/runx/bin
hide,MISE_SHELL,
hide,__MISE_DIFF,
hide,__MISE_DIFF,' | parse vars | update-env
  $env.MISE_SHELL = "nu"
  let mise_hook = {
    condition: { "MISE_SHELL" in $env }
    code: { mise_hook }
  }
  add-hook hooks.pre_prompt $mise_hook
  add-hook hooks.env_change.PWD $mise_hook
}

def --env add-hook [field: cell-path new_hook: any] {
  let field = $field | split cell-path | update optional true | into cell-path
  let old_config = $env.config? | default {}
  let old_hooks = $old_config | get $field | default []
  $env.config = ($old_config | upsert $field ($old_hooks ++ [$new_hook]))
}

export def --env --wrapped main [command?: string, --help, ...rest: string] {
  let commands = ["deactivate", "shell", "sh"]

  if ($command == null) {
    ^"/Users/mike/.local/bin/mise"
  } else if ($command == "activate") {
    $env.MISE_SHELL = "nu"
  } else if ($command in $commands) {
    ^"/Users/mike/.local/bin/mise" $command ...$rest
    | parse vars
    | update-env
  } else {
    ^"/Users/mike/.local/bin/mise" $command ...$rest
  }
}

def --env mise_hook [] {
  ^"/Users/mike/.local/bin/mise" hook-env -s nu
    | parse vars
    | update-env
}

