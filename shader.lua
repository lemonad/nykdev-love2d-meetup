local Class = require("class")
local Color = require("color")
local Vec2 = require("vec2")

local S = Class:derive("Shader")

function S:new()
  local color = Color:color_from_index(27)
  self.canvas = love.graphics.newCanvas(800, 600)
  self.shader = love.graphics.newShader("glsl/pixel_shader.glsl")
end

function S:update(t, dt)
end

function S:draw()
  love.graphics.setBlendMode("alpha", "premultiplied")
  love.graphics.setColor(1, 1, 1, 1)
  -- love.graphics.draw(self.canvas, 0, nil, 0)
  love.graphics.setBlendMode("alpha")
end

function S:draw_on_canvas()
  love.graphics.setCanvas(self.canvas)
  love.graphics.clear()
  love.graphics.setShader(self.shader)
  love.graphics.rectangle('fill', 0, 0, 800, 600)
  love.graphics.setShader()
  love.graphics.setCanvas()
end

return S
