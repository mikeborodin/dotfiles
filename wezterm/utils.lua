local function is_vim(pane)
  local is_vim_env = pane:get_user_vars().IS_NVIM == "true"
  if is_vim_env == true then
    return true
  end
  local process_name =
    string.gsub(pane:get_foreground_process_name(), "(.*[/\\])(.*)", "%2")
  return process_name == "nvim" or process_name == "vim"
end
