return {
  cmd = { "dart", "language-server", "--protocol=lsp" },
  filetypes = { "dart" },
  init_options = {
    closingLabels = false,
    flutterOutline = false,
    onlyAnalyzeProjectsWithOpenFiles = true,
    outline = false,
    suggestFromUnimportedLibraries = true,
  },
  root_markers = { "pubspec.yaml" },
  settings = {
    dart = {
      completeFunctionCalls = true,
      showTodos = false,
      lineLength = 100,
      enableSnippets = false,
      updateImportsOnRename = true,
      includeDependenciesInWorkspaceSymbols = false,
      checkForSdkUpdates = false,
      projectSearchDepth = 1,
      documentation = 'full',
      debugSdkLibraries = false,
      debugExternalLibraries = false,
      debugExternalPackageLibraries = false,
      analysisExcludedFolders = {
        vim.fn.expand('$HOME/fvm'),
        vim.fn.expand('$HOME/.pub-cache'),
      },
    },
  },
}
