--- @sync entry
return {
	entry = function()
		local h = cx.active.current.hovered

		ya.notify {
			title = "Info",
			content = "Entering...",
			timeout = 3,
		}

		if h and h.cha.is_dir then
			ya.mgr_emit("enter", {})
		else
			ya.mgr_emit("open", {})
		end
	end,
}
