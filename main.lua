local Color = require "color"
local Shader = require "shader"
local Vec2 = require "vec2"

local DEBUG = true

local WIDTH = 800
local HEIGHT = 600
local g = 9.81
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
  love.physics.setMeter(pixels_per_meter)
  world = love.physics.newWorld(0, g * pixels_per_meter, true)

  objects = {} -- table to hold all our physical objects

  objects.ground = {}
  objects.ground.body = love.physics.newBody(world, WIDTH / 2, HEIGHT - 50 / 2)
  objects.ground.shape = love.physics.newRectangleShape(WIDTH, 50)
  objects.ground.fixture = love.physics.newFixture(
    objects.ground.body,
    objects.ground.shape
  )

  objects.car = {}
  objects.car.body = love.physics.newBody(world, WIDTH / 2, HEIGHT / 2, "dynamic")
  objects.car.shape = love.physics.newRectangleShape(100, 30)
  objects.car.fixture = love.physics.newFixture(
    objects.car.body,
    objects.car.shape,
    1  -- density
  )
  objects.car.fixture:setRestitution(0.4)
end

function love.update(dt)
  t = t + dt
  -- shader.shader:send("time", t)
  world:update(dt)

  if love.keyboard.isDown("right") then
    objects.car.body:applyForce(400, 0)
  elseif love.keyboard.isDown("left") then
    objects.car.body:applyForce(-400, 0)
  end
end

function love.keypressed(k)
  if k == "escape" then
    love.event.quit()
  elseif k == "up" then
    objects.car.body:setLinearVelocity(0, 0)
    objects.car.body:applyLinearImpulse(0, -400)
  end
end

function love.draw()
  love.graphics.setBackgroundColor(Color:from_index(26):rgba())

  -- Draw ground.
  love.graphics.setColor(Color:from_index(11):rgba())
  love.graphics.polygon(
    "fill",
    objects.ground.body:getWorldPoints(objects.ground.shape:getPoints())
  )

  -- Draw car
  love.graphics.setColor(Color:from_index(7):rgba())
  love.graphics.polygon(
    "fill",
    objects.car.body:getWorldPoints(objects.car.shape:getPoints())
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
