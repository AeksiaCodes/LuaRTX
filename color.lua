-- i stole this from https://github.com/themousery/color.lua and modified the colors to be 3d colors

local module = {
  _version = "color.lua v2019.14.12",
  _description = "a simple color library for Lua based on the Pcolor class from processing",
  _url = "https://github.com/themousery/color.lua",
  _license = [[
    Copyright (c) 2018 themousery
    Permission is hereby granted, free of charge, to any person obtaining a copy
    of this software and associated documentation files (the "Software"), to deal
    in the Software without restriction, including without limitation the rights
    to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
    copies of the Software, and to permit persons to whom the Software is
    furnished to do so, subject to the following conditions:
    The above copyright notice and this permission notice shall be included in all
    copies or substantial portions of the Software.
    THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
    IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
    FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
    AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
    LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
    OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
    SOFTWARE.
  ]]
}

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
local function iscolor(t)
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