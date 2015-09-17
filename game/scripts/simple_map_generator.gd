extends Node

var grid_map
export(int) var distance = 0

export(int) var state = 0
export(float) var time = 0
var cubes_built = 0

func _ready():
	set_process(true)
	
func _process(delta):
	if(time < 0.5):
		time += delta
		return
	
	time -= 0.5

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
			
		cubes_built = 4 * distance * distance * 2
		#print ("cubes: ", cubes_built)
		
		#grid_map.set_bake(true)
		#grid_map.bake_geometry()
		
func _initialize():
	grid_map = get_parent().get_node("GridMap")
