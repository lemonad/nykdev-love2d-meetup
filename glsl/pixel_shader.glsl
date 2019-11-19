#pragma language glsl3
uniform float time;
uniform vec2 seed;

const float pi = atan(1.0) * 4.0;

highp float rand(vec2 co) {
  highp float a = 12.9898;
  highp float b = 78.233;
  highp float c = 43758.5453;
  highp float dt= dot(co.xy, vec2(a,b));
  highp float sn= mod(dt, 3.14);
  return fract(sin(sn) * c);
}

vec4 effect(vec4 color, Image image, vec2 uvs, vec2 screen_coords) {
  float width = love_ScreenSize.x;
  float height = 400.0;
  vec2 screen_coords_norm = vec2(
      screen_coords.x / width,
      screen_coords.y / height
    );
  float t = time;

  vec2 initial_seed = vec2(5050.0, 9090.0);
  vec2 wseed = seed;

  return vec4(154.0 / 255, 185.0 / 255, 169.0 / 255, 1.0);
}
