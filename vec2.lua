---@class Vec2
---@field x number
---@field y number
---@field new fun(self: Vec2, x: number, y: number): Vec2

---@type Vec2
Vec2 = {}
Vec2.__index = Vec2
Vec2.__eq = function(a, b)
  return a.x == b.x and a.y == b.y
end
Vec2.__tostring = function(v)
  return v.x .. ',' .. v.y
end
Vec2.__add = function(a, b)
  return Vec2:new(a.x + b.x, a.y + b.y)
end
Vec2.__sub = function(a, b)
  return Vec2:new(a.x - b.x, a.y - b.y)
end
Vec2.__unm = function(v)
  return Vec2:new(-v.x, -v.y)
end

---@return Vec2
---@param x number
---@param y number
function Vec2:new(x, y)
  ---@type Vec2
  local v = { x = x, y = y }
  setmetatable(v, self)
  return v
end
