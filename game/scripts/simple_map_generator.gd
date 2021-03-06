extends Node

var grid_map

export(int) var distance
export(int) var state = 0
export(float) var time = 0

const TIME = 1
var cubes_built = 0

func _init():
	# there is a order how the function init and ready are called when a game is loaded:
	# 1. _init()
	# 2. all properties are loaded from the editor (define default values here)
	# 3. _ready()
	pass


func _ready():
	print ("state:", state)
	set_process(true)
	set_process_input(true)
	
func _process(delta):
	time += delta
	
	if(time < TIME):
		return
	
	if (grid_map == null):
		if(time > 1):
			_initialize()
			time -= 1
		
		return
	else:
		time -= TIME
		if (time > TIME):
			time = time / 2
		
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
		

func _input(event):
	if (event.type == InputEvent.KEY && event.is_pressed()):
		if (event.scancode == KEY_B):
			get_tree().set_input_as_handled()
			print ("Baking geometry")
			print ("World size in cubes: ", cubes_built)
			grid_map.set_bake(true)
			grid_map.bake_geometry()
		
		if (event.scancode == KEY_C):
			get_tree().set_input_as_handled()
			print ("World size in cubes: ", cubes_built)
			

func _initialize():
	var parent = get_parent()
	if (parent.has_node("Map")):
		grid_map = parent.get_node("Map")
		if(grid_map == null):
			print("grid map not found")
