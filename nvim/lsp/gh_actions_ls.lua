---@brief
--- https://github.com/lttb/gh-actions-language-server
---
--- Language server for GitHub Actions.
---
--- The projects [forgejo](https://forgejo.org/) and [gitea](https://about.gitea.com/)
--- design their actions to be as compatible to github as possible
--- with only [a few differences](https://docs.gitea.com/usage/actions/comparison#unsupported-workflows-syntax) between the systems.
--- The `gh_actions_ls` is therefore enabled for those `yaml` files as well.
---
--- The `gh-actions-language-server` can be installed via `npm`:
---
--- ```sh
--- npm install -g gh-actions-language-server
--- ```
return {
  cmd = { 'gh-actions-language-server', '--stdio' },
  filetypes = { 'yaml.github' },
  root_markers = {
    '.github',
  },
  single_file_support = true,
  workspace_required = true,
  capabilities = {
    workspace = {
      didChangeWorkspaceFolders = {
        dynamicRegistration = true,
      },
    },
  },
  init_options = {
    -- Requires the `repo` and `workflow` scopes
    sessionToken = os.getenv 'GH_TOKEN',
  },
}
