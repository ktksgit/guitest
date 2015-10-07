extends "res://game/char/serialize.gd"

#TODO: the collision shape of the dwarf is not saved
# and should not be saved

const GRID_MAP_PATH = "/root/Node/World/Map"
const SPEED = 0.5 # m/s

export(Vector3Array) var walkPath
export(int) var currentWalkIndex = 0


func _ready():
	var shape = BoxShape.new()
	shape.set_extents(Vector3(1.2, 2.2, 0.2))
	get_node("StaticBody").add_shape(shape)
	
	set_process(true)
	pass

func _process(delta):
	if(walkPath == null):
		set_process(false)
		return

	if(currentWalkIndex >= walkPath.size()):
		currentWalkIndex = 0
		walkPath = null
		return
	
	var curPos = get_translation()
	var curDest = walkPath.get(currentWalkIndex)
	
	curDest.y += 0.01
	curDest.z += 0.02
	
	if(curDest.distance_to(curPos) < 0.01):
		currentWalkIndex += 1
		return
	
	var direction = curDest - curPos
	
	if(direction.length() < SPEED * delta):
		set_translation(curDest)
	else:
		
		set_translation(curPos + direction.normalized() * SPEED * delta)

func select():
	print("selected dwarf")
	
func walk(var vDest, var pathfinder):
	print("Destination: ", vDest)
	var start = pathfinder.get_closest_point(get_translation())
	
	walkPath = pathfinder.get_simple_path(start, vDest)
	currentWalkIndex = 0
	
	set_process(true)
	
func dig (var location):
	print("Dig: ", location)
	
	var position = get_translation()
	if (position.distance_to(location) < 1.8):
		var map = get_node(GRID_MAP_PATH)
		var x = _toInt(location.x)
		var y = _toInt(location.y)
		var dwarf_y = _toInt(position.y)
		var dwarf_x = _toInt(position.x)
		if(dwarf_x == x && y == dwarf_y - 1):
			return
			
		if(abs(dwarf_x - x) > 1 || abs(dwarf_y - y) > 1):
			return
		
		map.set_cell_item(x,y,-1, -1)
		print("Digging done at x,y: ", x, ",",y)

func _on_StaticBody_input_event( camera, event, click_pos, click_normal, shape_idx ):
	# FIX/TODO this does not work
	print("selected ")
	print(click_pos)

func _toInt(var value):
	if(value < 0):
		value -= 1
	
	return int(value)
