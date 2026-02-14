local mods = { "cmd", "ctrl" }

hs.hotkey.bind(mods, "right", function()
	hs.window.focusedWindow():focusWindowEast()
end)

hs.hotkey.bind(mods, "left", function()
	hs.window.focusedWindow():focusWindowWest()
end)

hs.hotkey.bind(mods, "up", function()
	hs.window.focusedWindow():focusWindowNorth()
end)

hs.hotkey.bind(mods, "down", function()
	hs.window.focusedWindow():focusWindowSouth()
end)
