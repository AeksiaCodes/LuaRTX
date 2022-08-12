local vector = require("vector")
local color = require("color")

Spheres = {
  {center = {x = 0, y = 0, z = -1}, radius = 0.3, color = {r = 255, g = 255, b = 0}},
  {center = {x = 0, y = -100.5, z = 0}, radius = 100, color = {r = 0, g = 255, b = 0}},
}
aspect_ratio = 16.0 / 9.0;
image_width = 640;
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

    t = 0.5*(dir.y + 1.0)
    c = color.new(1, 1, 1)
    d = color.new(0.5, 0.7, 1.0)
    return ((1.0-t)*c + t*d)*255
end

function addNewSphere(center, radius, dir)
    -- returns color of the sphere if it's hit

  local t = hit_sphere(center, radius, origin, dir)
  --print(t)
  if (t > 0) then
    hit_point = origin + (t * dir)
    local N = hit_point - center
    N:norm()
    return (255/2)*color(N.x+1, N.y+1, N.z+1)
  else
    return false
  end
  
end

function raycast(ori, dir, dist, increment) 
    dir:norm()
    
    for i = 1, #Spheres, 1 do
      result = addNewSphere(vector.new(Spheres[i]['center']['x'], Spheres[i]['center']['y'], Spheres[i]['center']['z']), Spheres[i]['radius'], dir)
      if (iscolor(result)) then
        return result
      end
    end
    return background_color(dir)

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
  
  
  