. ./classes/locationclass.ps1

# 0 0 0 - Start
$start = [Location]::new(
  @(0,0,0), 
  "Start", 
@"
* You're on the first floor of the dungeon.
You see a wooden staircase in the distance. The ceiling has several man-sized holes in it. 
Shafts of sunlight come through the ceiling. The walls are mottled with dust.
"@, 
  "AltDescription")

# 1 0 0 - Hallway
$hallway1f = [Location]::new(
  @(1,0,0),
  "Hallway1F", 
@"
* You walk down the hallway. Lining the corridor on both sides are small alcoves full of old cobwebs, 
stacks of books and papers, and
the odd suit of armor.
"@,
  "AltDescription",
  "Skeleton"
)

# 2 0 0 - Spiral Staircase
$staircase1f = [Location]::new(
  @(2,0,0), 
  "Staircase1F", 
  "* The staircase spirals down at a sickening angle. You can't quite make out what is at the bottom.", 
  "AltDescription"
)

# 2 0 1 - Spiral Staircase
$staircaseb1 = [Location]::new(
  @(2,0,1), 
  "StaircaseB1", 
@"
At the bottom of the stairs is a large atrium. Black mold dots the plasterwork on the ceiling.
You are standing in the center; there are pathways branching
to the North, South, and West. The hallway is directly behind you to the East.
"@, 
  "AltDescription"
)

# 3 0 1 - Atrium
$atrium = [Location]::new(
  @(3,0,1),
  "Atrium",
@"
You are standing in the center of a large atrium. There are pathways branching
to the North, South, and West. The hallway is directly behind you to the East.
"@,
  "AltDescription"
)

$rooms = @(
  $start,
  $hallway1f,
  $staircase1f,
  $atrium
)