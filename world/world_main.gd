
extends Spatial

export(FixedMaterial) var material = null

var map
var nav

const SPEED=4.0

var camrot=0.0

var begin=Vector3()
var end=Vector3()
var m = FixedMaterial.new()

var path=[]

func _notification(note):
	if (note == NOTIFICATION_PAUSED):
		print ("paused")

func _process(delta):
	#print("update")
	#print(get_node("Position3D").get_linear_velocity())
	if (path.size()>1):
		#print("path > 1")
		var to_walk = delta*SPEED
		var to_watch = Vector3(0,1,0)
		while(to_walk>0 and path.size()>=2):
			var pfrom = path[path.size()-1]
			var pto = path[path.size()-2]
			to_watch = (pto - pfrom).normalized()*3
			var d = pfrom.distance_to(pto)
			if (d<=to_walk):
				path.remove(path.size()-1)
				to_walk-=d
			else:
				path[path.size()-1] = pfrom.linear_interpolate(pto,to_walk/d)
				to_walk=0
				
		var atpos = path[path.size()-1]
		var atdir = to_watch
		#atdir.y=0
		
		var t = Transform()
		t.origin=atpos
		t=t.looking_at(atpos+atdir,Vector3(0,1,0))
		get_node("Position3D").set_transform(t)
		#get_node("RigidBody").set_transform(t)
		#get_node("Position3D").set_linear_velocity(atdir)
		#print(get_node("Position3D").get_linear_velocity())
		
		if (path.size()<2):
			#print("path < 2")
			path=[]
			set_process(false)
				
	else:
		set_process(false)

var draw_path = true
var im
func _update_path():
	m.set_line_width(1)
	m.set_point_size(3)
	m.set_fixed_flag(FixedMaterial.FLAG_USE_POINT_SIZE,true)
	m.set_flag(Material.FLAG_UNSHADED,true)
	
	var p = nav.get_simple_path(begin,end,false)
	#print("->PFAD: ",p," Length: ", p.size())
	path=Array(p) # Vector3array to complex to use, convert to regular array
	#print("converted: ",path, " Length: ", path.size())
	path.invert()
	set_process(true)
	
	if (draw_path):
		im.set_material_override(m)
		im.clear()
		im.begin(Mesh.PRIMITIVE_POINTS,null)
		im.add_vertex(begin)
		im.add_vertex(end)
		im.end()
		im.begin(Mesh.PRIMITIVE_LINE_STRIP,null)
		for x in p:
			im.add_vertex(x)
		im.end()

func _input(ev):
		
	if (ev.type==InputEvent.MOUSE_BUTTON and ev.button_index==BUTTON_LEFT and ev.pressed):
        #print (str("pause mode", get_pause_mode()))        
		var from = get_node("DirectionalLight/Camera").project_ray_origin(ev.pos)
		var to = from+get_node("DirectionalLight/Camera").project_ray_normal(ev.pos)*100
		var p = nav.get_closest_point_to_segment(from,to)
		#print("FROM: ",from)
		#print("TO: ",to)
		#print("Segment: ",p)
	
		begin=nav.get_closest_point(get_node("Position3D").get_translation())
		end=p
		#print("BEGIN: ",begin)

		_update_path()
		

func _ready():
	# Initalization here
	
	map = get_node("GridMap")
	
	#print(map.get_cell_size())
	#print(map.get_theme())
	#print(map.get_octant_size())
	generate_map(map)
	map.bake_geometry()
	
	var navi = generate_navi(map,50,50)
	var p = navi
	var mesh = generate_navi_mesh(p)
	
	nav = Navigation.new()
	var navmesh = NavigationMeshInstance.new()
	var navi = NavigationMesh.new()
	navi.set_vertices(p)
	for i in range(0,p.size(),3):
		var poly = IntArray()
		poly.push_back(i)
		poly.push_back(i+1)
		poly.push_back(i+2)
		navi.add_polygon(poly)
	
	var m = MeshInstance.new()
	
	add_child(nav)
	nav.add_child(m)
	m.add_child(navmesh)
	
	navmesh.set_navigation_mesh(navi)
	m.set_mesh(mesh)
	
	im = ImmediateGeometry.new()
	nav.add_child(im)
	
	#print_tree()
	#print(m.get_mesh())
	##print(navmesh.get_navigation_mesh())
	#print(navi.get_vertices())
	#print(navi.get_polygon_count())
	
	set_fixed_process(true)
	set_process_input(true)
	pass

func generate_map(map):
	for i in range(-50,50):
		for j in range(-50,50):
			map.set_cell_item(i,j,0,1)
			map.set_cell_item(i,j,-1,1)
	
	
	map.set_cell_item(1,1,0,-1)
	map.set_cell_item(2,1,0,-1)
	map.set_cell_item(3,1,0,-1)
	map.set_cell_item(4,1,0,-1)
	
	map.set_cell_item(3,2,0,-1)
	
	for i in range (-99, 99):
		map.set_cell_item(i,3,0,-1)

	
	map.set_cell_item(3,4,0,-1)
	
	map.set_cell_item(1,5,0,-1)
	map.set_cell_item(2,5,0,-1)
	map.set_cell_item(3,5,0,-1)
	map.set_cell_item(4,5,0,-1)
	return


func generate_navi(gridMap,x_size,y_size):
	var cell_size = gridMap.get_cell_size()
	var hover = 0#0.01
	var navi = Vector3Array()
	for x in range(0,x_size+1):
		for y in range(0,y_size+1):
			#print(gridMap.get_cell_item(x,y,0))
			if(gridMap.get_cell_item(x,y,0) == -1):
				if!(gridMap.get_cell_item(x-1,y,0) == 1 && gridMap.get_cell_item(x+1,y,0) == 1 || gridMap.get_cell_item(x,y-1,0) == -1): #nur wenns kein schacht ist
					navi.push_back(Vector3(x*cell_size, y*cell_size+hover, 0))
					navi.push_back(Vector3(x*cell_size+cell_size, y*cell_size+hover, 0))
					navi.push_back(Vector3(x*cell_size+cell_size, y*cell_size+hover, cell_size))
					
					navi.push_back(Vector3(x*cell_size+cell_size, y*cell_size+hover, cell_size))
					navi.push_back(Vector3(x*cell_size, y*cell_size+hover, cell_size))
					navi.push_back(Vector3(x*cell_size, y*cell_size+hover, 0))
				else:
					navi.push_back(Vector3(x*cell_size, y*cell_size+cell_size, hover))
					navi.push_back(Vector3(x*cell_size+cell_size, y*cell_size+cell_size, hover))
					navi.push_back(Vector3(x*cell_size+cell_size, y*cell_size, hover))
					
					navi.push_back(Vector3(x*cell_size+cell_size, y*cell_size, hover))
					navi.push_back(Vector3(x*cell_size, y*cell_size, hover))
					navi.push_back(Vector3(x*cell_size, y*cell_size+cell_size, hover))
					if(gridMap.get_cell_item(x-1,y,0) == -1):
						navi.push_back(Vector3((x-1)*cell_size, y*cell_size+cell_size, hover))
						navi.push_back(Vector3((x-1)*cell_size+cell_size, y*cell_size+cell_size, hover))
						navi.push_back(Vector3((x-1)*cell_size+cell_size, y*cell_size, hover))
						
						navi.push_back(Vector3((x-1)*cell_size+cell_size, y*cell_size, hover))
						navi.push_back(Vector3((x-1)*cell_size, y*cell_size, hover))
						navi.push_back(Vector3((x-1)*cell_size, y*cell_size+cell_size, hover))
					if(gridMap.get_cell_item(x+1,y,0) == -1):
						navi.push_back(Vector3((x+1)*cell_size, y*cell_size+cell_size, hover))
						navi.push_back(Vector3((x+1)*cell_size+cell_size, y*cell_size+cell_size, hover))
						navi.push_back(Vector3((x+1)*cell_size+cell_size, y*cell_size, hover))
						
						navi.push_back(Vector3((x+1)*cell_size+cell_size, y*cell_size, hover))
						navi.push_back(Vector3((x+1)*cell_size, y*cell_size, hover))
						navi.push_back(Vector3((x+1)*cell_size, y*cell_size+cell_size, hover))
					if(gridMap.get_cell_item(x,y-1,0) == -1):
						navi.push_back(Vector3(x*cell_size, (y-1)*cell_size+cell_size, hover))
						navi.push_back(Vector3(x*cell_size+cell_size, (y-1)*cell_size+cell_size, hover))
						navi.push_back(Vector3(x*cell_size+cell_size, (y-1)*cell_size, hover))
						
						navi.push_back(Vector3(x*cell_size+cell_size, (y-1)*cell_size, hover))
						navi.push_back(Vector3(x*cell_size, (y-1)*cell_size, hover))
						navi.push_back(Vector3(x*cell_size, (y-1)*cell_size+cell_size, hover))
			pass
	return navi
	pass

func generate_navi_mesh(Vector3arr):
	var up = Vector3(0, 1, 0)
	
	# PRIMITIVE_POINTS = 0 - Render array as points (one vertex equals one point).
	# PRIMITIVE_LINES = 1 - Render array as lines (every two vertices a line is created).
	# PRIMITIVE_LINE_STRIP = 2 - Render array as line strip.
	# PRIMITIVE_LINE_LOOP = 3 - Render array as line loop (like line strip, but closed).
	# PRIMITIVE_TRIANGLES = 4 - Render array as triangles (every three vertices a triangle is created).
	# PRIMITIVE_TRIANGLE_STRIP = 5 - Render array as triangle strips.
	# PRIMITIVE_TRIANGLE_FAN = 6 - Render array as triangle fans.
	
	var surface = SurfaceTool.new()
	surface.begin(4) # 5 means TRIANGLE_STRIP
	
	if(material):
		surface.set_material(material)
	
	for i in range(0,Vector3arr.size(),3):
		surface.add_uv(Vector2(0, 1))
		surface.add_normal(up)
		surface.add_vertex(Vector3arr.get(i))
		surface.add_uv(Vector2(1, 0))
		surface.add_normal(up)
		surface.add_vertex(Vector3arr.get(i+1))
		surface.add_uv(Vector2(1, 1))
		surface.add_normal(up)
		surface.add_vertex(Vector3arr.get(i+2))
	
	return surface.commit()
	pass

