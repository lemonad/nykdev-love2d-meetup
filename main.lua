local Color = require "color"
local Shader = require "shader"
local Vec2 = require "vec2"
local Camera = require "hump.camera"

local DEBUG = true

local WIDTH = 800
local HEIGHT = 600
local g = 0
local pixels_per_meter = 128

local t = 0
local points = 5

local zoom = 1

function love.load()
  math.randomseed(os.time())
  sniglet_font = love.graphics.newFont("fonts/sniglet.fnt")
  sniglet_small_font = love.graphics.newFont("fonts/snigletsmall.fnt")

  love.physics.setMeter(pixels_per_meter)
  world = love.physics.newWorld(0, g * pixels_per_meter, true)

  left_shoulder = {}
  left_shoulder.body = love.physics.newBody(world, 25, HEIGHT / 2)
  left_shoulder.shape = love.physics.newRectangleShape(50, HEIGHT)
  left_shoulder.fixture = love.physics.newFixture(
    left_shoulder.body,
    left_shoulder.shape
  )

  right_shoulder = {}
  right_shoulder.body = love.physics.newBody(world, WIDTH - 25, HEIGHT / 2)
  right_shoulder.shape = love.physics.newRectangleShape(50, HEIGHT)
  right_shoulder.fixture = love.physics.newFixture(
    right_shoulder.body,
    right_shoulder.shape
  )

  car_pos = Vec2(WIDTH / 2, HEIGHT / 2)
  hero_speed = 200
  hero_turn_speed = 2
  car_speed = 10

  -- car = {}
  -- car.body = love.physics.newBody(world, WIDTH / 2, HEIGHT / 2, "dynamic")
  -- car.shape = love.physics.newRectangleShape(50, 80)
  -- car.fixture = love.physics.newFixture(
  --   car.body,
  --   car.shape,
  --   0.2  -- density
  -- )
  -- car.fixture:setRestitution(1.0)
  -- car.body:setAngularDamping(5)

  camera = Camera(WIDTH / 2, HEIGHT / 2)

  hero = {}
  hero.body = love.physics.newBody(world, WIDTH / 2, HEIGHT / 2, "dynamic")
  hero.shape = love.physics.newRectangleShape(80, 50)
  hero.shape = love.physics.newRectangleShape(-45, 20, 5, 10)
  hero.fixture = love.physics.newFixture(
    hero.body,
    hero.shape,
    3  -- density
  )
  hero.fixture:setRestitution(1.0)
  hero.body:setLinearDamping(0.5)
  hero.body:setAngularDamping(500)
  hero_vector = nil
  hero.body:setAngle(-math.pi / 2)
  hero.image = love.graphics.newImage("car.png")
  hero.quad = love.graphics.newQuad(0, 0, 48, 64, 48, 64)

  tiles = {}
  for y = 1, 11 do
    tiles[y] = {}
    for x = 1, 10 do
      tiles[y][x] = (love.math.random() > 0.95) and 11 or 10
    end
  end
  background_offset = 0

  other_cars = {}

  -- music = love.audio.newSource(".mp3", "stream")
  -- music:setLooping(true)
  -- music:setVolume(0.5)
  -- love.audio.play(music)

  -- sfx = love.audio.newSource("sfx/.wav", "static")

  -- shader = Shader()
  --
end

function love.update(dt)
  t = t + dt
  -- shader.shader:send("time", t)
  world:update(dt)

  camera:zoom(zoom)
  zoom = zoom - dt * 0.00001

  local fx = 0
  local fy = 0
  if love.keyboard.isDown("right") then
    fx = hero_turn_speed * dt
  elseif love.keyboard.isDown("left") then
    fx = -hero_turn_speed * dt
  end
  if love.keyboard.isDown("up") then
    fy = -hero_speed * dt
  elseif love.keyboard.isDown("down") then
    fy = hero_speed * dt
  end
  angle = hero.body:getAngle()
  local y = math.sin(angle)
  local x = math.cos(angle)
  hero.body:applyForce(-x * fy, -y * fy)

  hero.body:setAngle(angle + fx)

  -- local x, y = car.body:getPosition()
  -- local dx = WIDTH / 2 - x
  -- local dy = HEIGHT / 2 - y

  -- car.body:applyForce(dx * dt * car_speed, dy * dt * car_speed)

  background_offset = background_offset + 100 * dt
  if background_offset > 60 then
    for y = 11, 2, -1 do
      for x = 1, 10 do
        tiles[y][x] = tiles[y - 1][x]
      end
    end
    background_offset = background_offset - 60
    for x = 1, 10 do
      tiles[1][x] = (love.math.random() > 0.95) and 11 or 10
    end
  end

  if love.math.random() > 0.8 then
    -- spawn car
    local x = love.math.random() * (WIDTH - 150)
    local y = -50

    local car = {}
    car.body = love.physics.newBody(world, x, y, "dynamic")
    car.shape = love.physics.newRectangleShape(50, 80)
    car.fixture = love.physics.newFixture(
      car.body,
      car.shape,
      0.5  -- density
    )
    car.fixture:setRestitution(1.0)
    car.body:setAngularDamping(0)
    car.body:applyForce(0, car_speed * 200 * (0.5 + love.math.random() * 0.5))

    other_cars[#other_cars + 1] = car
  end

end

function love.keypressed(k)
  if k == "escape" then
    love.event.quit()
  end
end

function love.draw()
  camera:attach()

  love.graphics.setBackgroundColor(Color:from_index(26):rgba())
  -- Draw tiles
  for y = 1, 11 do
    for x = 1, 10 do
      love.graphics.setColor(Color:from_index(tiles[y][x]):rgba())
      love.graphics.rectangle(
        "fill",
        (x - 1) * 80,
        (y - 1) * 60 + background_offset - 60,
        80,
        60
      )
    end
  end

  -- Draw shoulders.
  love.graphics.setColor(Color:from_index(16):rgba())
  love.graphics.polygon(
    "fill",
    left_shoulder.body:getWorldPoints(left_shoulder.shape:getPoints())
  )
  love.graphics.polygon(
    "fill",
    right_shoulder.body:getWorldPoints(right_shoulder.shape:getPoints())
  )

  -- Draw upper and lower limits.
  love.graphics.setColor(Color:from_index(11):rgba())

  -- Draw car
  for i = 1, #other_cars do
    love.graphics.setColor(Color:from_index(27):rgba())
    love.graphics.polygon(
      "fill",
      other_cars[i].body:getWorldPoints(other_cars[i].shape:getPoints())
    )
  end

  -- Draw hero
  love.graphics.setColor(Color:from_index(8):rgba())
  love.graphics.draw(
    hero.image,
    hero.quad,
    hero.body:getX(),
    hero.body:getY(),
    hero.body:getAngle(),
    1, 1,
    32, 32,
    0, 0
    )

  -- Draw hero
  -- love.graphics.setColor(Color:from_index(8):rgba())
  -- love.graphics.polygon(
  --   "fill",
  --   hero.body:getWorldPoints(hero.shape:getPoints())
  -- )

  camera:detach()

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
