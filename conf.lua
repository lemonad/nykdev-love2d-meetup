function love.conf(t)
  t.version = "11.3"

  t.window.title = "Nykdev"
  t.window.width = 800
  t.window.height = 600
  t.modules.joystick = false
  t.modules.physics = true

  t.window.fullscreen = love._os == "Android" or love._os == "iOS" -- Fullscreen on mobile
  t.window.fullscreentype = "desktop"                              -- "desktop" fullscreen is required for scrale
  t.window.highdpi = love._os == "iOS" or love._os == "OS X"

  t.window.fsaa = 8
  t.window.vsync = -1
end
