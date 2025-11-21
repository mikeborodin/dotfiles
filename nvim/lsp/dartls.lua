return {
  cmd = { "dart", "language-server", "--protocol=lsp" },
  filetypes = { "dart" },
  init_options = {
    closingLabels = true,
    flutterOutline = true,
    onlyAnalyzeProjectsWithOpenFiles = true,
    outline = true,
    suggestFromUnimportedLibraries = true
  },
  root_markers = { "pubspec.yaml" },
  settings = {
    dart = {
      completeFunctionCalls = true,
      showTodos = false
    },
  }
}
