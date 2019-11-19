local Color = require "color"
local Shader = require "shader"
local Vec2 = require "vec2"

local DEBUG = true

local WIDTH = 800
local HEIGHT = 600
local g = 0
local pixels_per_meter = 64

local t = 0
local points = 0

function love.load()
  math.randomseed(os.time())
  sniglet_font = love.graphics.newFont("fonts/sniglet.fnt")
  sniglet_small_font = love.graphics.newFont("fonts/snigletsmall.fnt")

  -- music = love.audio.newSource(".mp3", "stream")
  -- music:setLooping(true)
  -- music:setVolume(0.5)
  -- love.audio.play(music)

  -- sfx = love.audio.newSource("sfx/.wav", "static")

  -- shader = Shader()
  --
  car_pos = Vec2(WIDTH / 2, HEIGHT / 2)
  car_speed = 200
end

function love.update(dt)
  t = t + dt
  -- shader.shader:send("time", t)

  local fx = 0
  local fy = 0
  if love.keyboard.isDown("right") then
    car_pos.x = car_pos.x + car_speed * dt
  elseif love.keyboard.isDown("left") then
    car_pos.x = car_pos.x - car_speed * dt
  elseif love.keyboard.isDown("up") then
    car_pos.y = car_pos.y - car_speed * dt
  elseif love.keyboard.isDown("down") then
    car_pos.y = car_pos.y + car_speed * dt
  end
end

function love.keypressed(k)
  if k == "escape" then
    love.event.quit()
  end
end

function love.draw()
  love.graphics.setBackgroundColor(Color:from_index(26):rgba())

  -- Draw upper and lower limits.
  love.graphics.setColor(Color:from_index(11):rgba())
  love.graphics.polygon(
    "fill",
    car_pos.x - 40,
    car_pos.y - 30,
    car_pos.x + 40,
    car_pos.y - 30,
    car_pos.x + 40,
    car_pos.y + 30,
    car_pos.x - 40,
    car_pos.y + 30
  )

  -- Draw HUD
  love.graphics.setColor(1, 1, 1)
  if DEBUG then
    love.graphics.setFont(sniglet_small_font)
    love.graphics.print("Current FPS: "..tostring(love.timer.getFPS()), 10, 520)
  end

  love.graphics.printf("NYK<3DEV", 250, 0, 300, "center")

  love.graphics.setFont(sniglet_font)
  love.graphics.print(tostring(points), 10, 0)
  love.graphics.origin()
end
