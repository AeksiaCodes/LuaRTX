local vector = require("vector")
local color = require("color")
Spheres = {
  {center = {x = 0, y = -100.5, z = 0}, radius = 100, color = {r = 0, g = 255, b = 0}},
  {center = {x = 0.95, y = 0.1, z = -1}, radius = 0.3, color = {r = 255, g = 255, b = 0}},
  {center = {x = -0.5, y = -0.25, z = -1}, radius = 0.5, color = {r = 0, g = 0, b = 255}},
  {center = {x = 0.4, y = 0.3, z = -1.1}, radius = 0.25, color = {r = 0, g = 255, b = 255}},
  {center = {x = -2, y = -0.3, z = -1.2}, radius = 0.5, color = {r = 255, g = 0, b = 255}},
}
aspect_ratio = 16.0 / 9.0;
image_width = 1920;
image_height = (image_width / aspect_ratio);
viewport_height = 2.0;
viewport_width = aspect_ratio * viewport_height;
focal_length = 1.0;

origin = vector.new(0, 0, 0);
horizontal = vector.new(viewport_width, 0, 0);
vertical = vector.new(0, viewport_height, 0);
lower_left_corner = origin - horizontal/2 - vertical/2 - vector.new(0, 0, focal_length)



function random_double(min, max) 
  
  return  min + (max-min)*math.random(0, 1)
  
end

function hit_sphere(center, radius, origin, direction) 
   -- determines whether a ray hits a sphere
   oc = origin - center 
    a = direction:magSq();
    half_b = oc:dot(direction);
    c = oc:magSq() - radius*radius;
    discriminant = half_b*half_b - a*c;
    -- print("#: " .. tostring(center) .. " " .. tostring(direction) .. " " .. tostring(origin) .. " " .. radius)
    if (discriminant < 0) then
        return -1.0;
    else 
        return (-half_b - math.sqrt(discriminant) ) / (a);
    end
end

function background_color(dir) 
    dir:norm()

    local t = 0.5*(dir.y + 1.0)
    c = color.new(1, 1, 1)
    d = color.new(0.5, 0.7, 1.0)
    return ((1.0-t)*c + t*d)*255
end

function raycast(ori, dir, dist, increment) 
    dir:norm()
    local i_min = -1
    local t_min = math.huge
    for i = 1, #Spheres, 1 do
      
      local t = hit_sphere(vector.new(Spheres[i]['center']['x'], Spheres[i]['center']['y'], Spheres[i]['center']['z']), Spheres[i]['radius'], origin, dir)
      if t > 0 then
        if t < t_min then
          t_min = t
          i_min = i
        end
      end
    end
    
    if i_min == -1 then
      return background_color(dir)
    else
        center = vector.new(Spheres[i_min]['center']['x'], Spheres[i_min]['center']['y'], Spheres[i_min]['center']['z'])
         hit_point = origin + (t_min * dir)
        local N = hit_point - center
        N:norm()
        return (color.new(Spheres[i_min]['color']['r'], Spheres[i_min]['color']['g'], Spheres[i_min]['color']['b']) + raycast(hit_point, N, 500, 1)) * 0.5
        
        end
    
    
      
end

file = io.open("image.ppm", "w")
io.output(file)

io.write("P3\n" .. image_width .. " " .. image_height .. "\n255\n")

j = image_height - 1

while (j >= 0) do
  i = 0
  print("Scanlines remaining: " .. j)
    while (i < image_width) do 
    u = (i) / (image_width-1)
    v = (j) / (image_height-1)
    
  direction = lower_left_corner + (u * horizontal) + (v * vertical) - origin
  -- direction:norm()
  --print(i .. " " .. j)
  io.write(tostring(raycast(origin, direction, 500, 1)) .. "\n")
  
    
    i = i + 1
    
    end 
  
  
j = j - 1

end
  
print("Done.")
  
  
  