-- Window Control --

local laptopScreen = 'Color LCD'
local monitorScreen = 'U28E510'

hs.hotkey.bind({"ctrl", "shift"}, "E", function()
  local mainFF

  for name, win in pairs(hs.application.find("Firefox"):visibleWindows()) do if not string.find(win:title(), "Twitch") then mainFF = win 
      break 
    end 
  end

  local windowLayout = {
    {nil, mainFF, monitorScreen, hs.geometry.unitrect(0,0,0.67,0.9), nil, nil}, 
    {"Terminal", nil, monitorScreen, hs.geometry.unitrect(0.67,0,0.33,0.65), nil, nil} 
  }

  hs.layout.apply(windowLayout)
end)

hs.hotkey.bind({"cmd","alt"}, "right", function()
  local win = hs.window.focusedWindow()
  win:moveToUnit(hs.geometry.unitrect(0.67, 0.60, 0.33, 0.40))
end)

hs.hotkey.bind({"cmd","alt"}, "down", function()
  local win = hs.window.focusedWindow()
  local size = win:size()
  local max = win:screen():frame()

  size.h = max.h
  win:setSize(size)
end)

hs.hotkey.bind({"ctrl","shift"}, "F", function()
  local win = hs.window.focusedWindow()
  local max = win:screen():frame()

  win:setSize(max)
end)

-- MISC --

hs.hotkey.bind({"cmd", "shift"}, "C", function() 
  hs.toggleConsole()
end)

hs.hotkey.bind({"cmd", "ctrl", "shift"}, "C", function() 
  hs.eventtap.keyStrokes('label-imperial-kayak-suburban-surfboat-delicacy')
end)

-- EE Spoon init --

hs.loadSpoon("ReloadConfiguration")
spoon.ReloadConfiguration:start()

hs.loadSpoon("EliteExtra")
spoon.EliteExtra:bindHotkeys(
  {search={{"cmd","shift"}, "W"}}
)
spoon.EliteExtra.server_url = "http://viz.extra.int"
spoon.EliteExtra.use_dbeaver = true
spoon.EliteExtra.use_named_connections = true
spoon.EliteExtra:start()
