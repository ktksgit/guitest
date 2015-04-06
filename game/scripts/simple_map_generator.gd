extends Node

var grid_map
export(int) var distance = 0

export(int) var state = 0
export(float) var time = 0
var cubes_built = 0

func _ready():
	set_process(true)
	
func _process(delta):
	if(time < 0.1):
		time += delta
		return
		
	time -= 0.1

	if (grid_map == null):
		_initialize()
	else:
		var y = distance
		
		grid_map.set_cell_item(-state,y,-1,1)
		grid_map.set_cell_item(-state,y,-2,1)
		
		y = -distance
		grid_map.set_cell_item(state,y,-1,1)
		grid_map.set_cell_item(state,y,-2,1)
		
		var x = distance
		grid_map.set_cell_item(x,state,-1,1)
		grid_map.set_cell_item(x,state,-2,1)
		
		x = -distance
		grid_map.set_cell_item(x,-state,-1,1)
		grid_map.set_cell_item(x,-state,-2,1)
		
		state += 1
		if (state >= distance):
			distance += 1
			state = -distance
			
		cubes_built = distance * distance * 2

func _initialize():
	grid_map = get_parent().get_node("GridMap")
