vim.g.my_selected_diagnostic = 0

function PopulateLoclistWithDiagnostics()
  local diagnostics = vim.diagnostic.get(nil)
  local items = {}

  for _, item in ipairs(diagnostics) do
    table.insert(items, {
      bufnr = item.bufnr,
      lnum = item.lnum + 1,
      col = item.col + 1,
      text = item.message,
      type = item.severity == vim.diagnostic.severity.ERROR and "E" or "W"
    })
  end
  require('notify')(items[vim.g.my_selected_diagnostic])
end
