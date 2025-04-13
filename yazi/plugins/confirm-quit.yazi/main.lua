local function entry()
	local yes = ya.confirm {
		pos = { "center", w = 60, h = 10 },
		title = "Quit?",
		content = ui.Text("There are multiple tabs open. Are you sure you want to quit?"):wrap(ui.Text.WRAP),
	}
	if yes then
		ya.mgr_emit("quit", {})
	end
end

return { entry = entry }
