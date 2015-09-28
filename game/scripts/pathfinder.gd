extends Navigation

var nGridMap
var currentID = 0

func _ready():
	
	pass

func start(var gridMap):
	nGridMap = gridMap
	
	var mesh = _generateNavigationMesh(nGridMap, -2, -2, 8, 8)
	
	self.navmesh_remove(currentID)
	currentID = self.navmesh_create( mesh, Transform())

func _generateNavigationMesh(gridMap,posX, posY, dX, dY):
	var navi = Vector3Array()
	
	for x in range(posX,posX+dX):
		for y in range(posY, posY+dY):
			for z in range(-1,0):
				if(gridMap.get_cell_item(x,y,z) == -1):
					var verticalWay = false
					if (gridMap.get_cell_item(x,y-1,z) != -1):
						#no way down
						navi = _pushHorizontalArea(navi,x,y,z)
						if(gridMap.get_cell_item(x,y+1,z) == -1):
							#there is a way up
							navi = _pushVerticalArea(navi,x,y,z)
							verticalWay = true
					else: 
						#here is a way down
						navi = _pushVerticalArea(navi,x,y,z)
						verticalWay = true
					
					if(verticalWay):
						if(gridMap.get_cell_item(x+1,y,z) == -1):
							#a way to the right
							navi = _pushVerticalArea(navi,x+1,y,z)
						
						if(gridMap.get_cell_item(x-1,y,z) == -1):
							#a way to the left
							navi = _pushVerticalArea(navi,x-1,y,z)
	
	var mesh = NavigationMesh.new()
	mesh.set_vertices(navi)
	for i in range (0, navi.size(), 3):
		var polygon = IntArray([i,i+1,i+2])
		mesh.add_polygon(polygon)
	
	return mesh

func _pushVerticalArea(area, x,y,z):
	area.push_back(Vector3(x, y+1, z))
	area.push_back(Vector3(x+1, y+1, z))
	area.push_back(Vector3(x+1, y, z))
	
	area.push_back(Vector3(x+1, y, z))
	area.push_back(Vector3(x, y, z))
	area.push_back(Vector3(x, y+1, z))
	
	return area
	
func _pushHorizontalArea(area,x,y,z):
	area.push_back(Vector3(x, y, z+1))
	area.push_back(Vector3(x+1, y, z+1))
	area.push_back(Vector3(x+1, y, z))
	
	area.push_back(Vector3(x+1, y, z))
	area.push_back(Vector3(x, y, z))
	area.push_back(Vector3(x, y, z+1))
	
	return area