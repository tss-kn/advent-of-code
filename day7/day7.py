from dataclasses import dataclass
import sys

@dataclass
class Point:
    x: float
    y: float
    
class Beam:
    tip_pos: Point
    split_count = 0
    visited_splits = set()
    
    def __init__(self, start_pos: Point, grid: list[str]):
        self.start_pos = start_pos
        self.grid = grid
        
        self.tip_pos = start_pos
        self.grid_dimensions = (len(self.grid[0]),len(self.grid))
        
    def step(self):
        self.grid[self.tip_pos.y] = \
            self.grid[self.tip_pos.y][:self.tip_pos.x] + "|" \
            + self.grid[self.tip_pos.y][self.tip_pos.x+1:]
        
        self.tip_pos.y += 1
        
        if(self.tip_pos.y >= self.grid_dimensions[1]):
            return
        
        cell = self.grid[self.tip_pos.y][self.tip_pos.x] 
        
        if(cell == "^"):
            self.split(self.tip_pos)
            return
        
        self.step()
    
    def split(self, pos: Point):
        if(pos.x, pos.y) not in Beam.visited_splits:
            Beam.visited_splits.add((pos.x, pos.y)) 
            Beam.split_count += 1
        else:
            return
            
        print(f"Split at {pos}")
        
        left = Point(pos.x - 1, pos.y)
        right = Point(pos.x + 1, pos.y)
        
        if(0 <= left.x < self.grid_dimensions[0]):
            Beam(left, self.grid).step()
        if(0 <= right.x < self.grid_dimensions[0]):
            Beam(right, self.grid).step()
        
    def __repr__(self):
        return "\n".join(self.grid)

if(len(sys.argv) != 2):
    print("Usage - python day7.py input_file")
    sys.exit(127)

with open(sys.argv[1], 'r') as file:
    file_content = file.read()
    
grid = file_content.split("\n")

s_p = Point(0,0)
for y, l in enumerate(grid):
    x = l.find("S")
    if(x != -1):
        s_p.x = x
        s_p.y = y + 1
        break

beam = Beam(s_p, grid)
print(beam.grid)
print(beam.grid_dimensions)
beam.step()
print(beam)
print(beam.split_count)