local vector = require("vector")

function raycast(ori, dir, dist, increment) 
    dir:norm()
    curDist = 0
    
    while (curDist <= dist) do
      
      ori.x = ori.x + (dir.x * increment)
      ori.y = ori.y + (dir.y * increment)
      ori.z = ori.z + (dir.z * increment)
      
      curDist = curDist + increment
      
    end
    
    print(ori.x .. ", " .. ori.y .. ", " .. ori.z)
    
end

