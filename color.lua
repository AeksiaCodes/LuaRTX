
function round(num, numDecimalPlaces)
  local mult = 10^(numDecimalPlaces or 0)
  return math.floor(num * mult + 0.5) / mult
end

-- create the module
local color = {}
color.__index = color

-- get a random function from Love2d or base lua, in that order.
local rand = math.random
-- makes a new color
local function new(r,g,b)
  return setmetatable({r=r or 0, g=g or 0, b=b or 0}, color)
end

function color:__tostring()
  return round(self.r)  .. " " .. round(self.g) .. " " .. round(self.b)
end


--check if an object is a color
function iscolor(t)
  return getmetatable(t) == color
end

-- set the values of the color to something new
function color:set(r,g,b)
  self.r, self.g, self.b = r or self.r, g or self.g, b or self.b
  return self
end

-- returns a copy of a color
function color:clone()
  return new(self.r, self.g, self.b)
end
function color.__add(a,c)
   assert(iscolor(a) and iscolor(c), "add: wrong argument types: (expected <color> and <color>)")
  return new(a.r+c.r, a.g+c.g, a.b+c.b)
end

function color.__mul(a,c)
  if type(a) == 'number' then 
    return new(a * c.r, a * c.g, a * c.b)
  elseif type(c) == 'number' then
    return new(a.r * c, a.g * c, a.b * c)
  end
end

-- pack up and return module
module.new = new
module.random = random
module.fromAngle = fromAngle
module.iscolor = iscolor
return setmetatable(module, {__call = function(_,...) return new(...) end})